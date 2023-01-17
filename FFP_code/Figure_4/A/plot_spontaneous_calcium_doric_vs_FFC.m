%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% A flexible and versatile system for multi-color fiber photometry and optogenetic manipulation
% Andrey Formozov, Alexander Dieter, J. Simon Wiegert
% code: Dieter, A, 2022 
% reviewed: Formozov, A, 2023
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% prepare workspace
clear all; clc;  close all;

% add "FFP_code" into path 
filePath = matlab.desktop.editor.getActiveFilename; % file path to the current script
location = regexp(filePath,'FFP_code','split'); % "location of the "FFP_code" folder"
addpath(location{1}+"FFP_code\");
% or add "FFP_code" into path manually by uncommenting and specifying the path:
% addpath('path_to_scripts\FFP_code')

%% define data files

path = data_location + '\FFP_data\Figure_4\A\';

% fused fiber coupler 
photometry = '25417_FFC-2022-08-23-164333.ppd';
AFFile = '25417_AFpre-2022-08-23-164219.ppd';
NIfile = 'VRdata_25417_spont_FFC_20220823170411.mat';
power_FFC1 = 404;              % in µW; excitation power for the first channel (470 nm)
power_FFC2 = 243;              % in µW; excitation power for the second channel (405 nm)

% photometry = '25420_FFC-2022-08-23-155023.ppd';
% AFFile = '25420_AFpre-2022-08-23-154911.ppd';
% NIfile = 'VRdata_25420_spont_FFC_20220823161048.mat';
% power_FFC1 = 308;              % in µW; excitation power for the first channel (470 nm)
% power_FFC2 = 184;              % in µW; excitation power for the second channel (405 nm)

% photometry = '25421_FFC-2022-08-23-161754.ppd';
% AFFile = '25421_AFpre-2022-08-23-161606.ppd';
% NIfile = 'VRdata_25421_spont_FFC_20220823163816.mat';
% power_FFC1 = 245;              % in µW; excitation power for the first channel (470 nm)
% power_FFC2 = 187;              % in µW; excitation power for the second channel (405 nm)


% %% doric
% photometry = '25417_doric-2022-08-23-182537.ppd';
% AFFile = '25417_dAFpre-2022-08-23-182233.ppd';
% NIfile = 'VRdata_25417_spont_doric_20220823184613.mat';
% power_FFC1 = 409;              % in µW; excitation power for the first channel (470 nm)
% power_FFC2 = 204;              % in µW; excitation power for the second channel (405 nm)

% photometry = '25420_doric-2022-08-23-172805.ppd';
% AFFile = '25420_dAFpre-2022-08-23-172454.ppd';
% NIfile = 'VRdata_25420_spont_doric_20220823174905.mat';
% power_FFC1 = 300;              % in µW; excitation power for the first channel (470 nm)
% power_FFC2 = 184;              % in µW; excitation power for the second channel (405 nm)

% photometry = '25421_doric-2022-08-23-175644.ppd';
% AFFile = '25421_dAFpre-2022-08-23-175255.ppd';
% NIfile = 'VRdata_25421_spont_doric_20220823181930.mat';
% power_FFC1 = 253;              % in µW; excitation power for the first channel (470 nm)
% power_FFC2 = 187;              % in µW; excitation power for the second channel (405 nm)







%% define variables
SR = 30;                        % sampling rate (pupil)
belt_length = 2;                % length of running belt (meters)
SR_NI = 3000;                   % sampling rate (national instruments board)
fitorder = 2;                   % degree of polynomial to fit bleaching of photometry data
smoothwindow_photometry	= 100;	% time window to smooth photometry data by moving average, in ms
motion_threshold = 0.003; 
motion_frame = 20; 

conversion_factor = 0.76;       % at 550nm; factor to convert V in (given by doric lenses)


%% load data and calculate autofluorescence of FFC system
AFiber = import_ppd(path + AFFile);
AFiber_1 = mean( AFiber.analog_1);
AFiber_2 = mean( AFiber.analog_2);


%% load and process photometry data
d = import_ppd(path + photometry);

trig_idx   = find(d.digital_1(1:end-1) < 0.5 & d.digital_1(2:end) > 0.5)+1;     % find first and last trigger for data synchronization

d.analog_1 = d.analog_1(trig_idx(1):trig_idx(end))'; d.analog_1 = (d.analog_1-AFiber_1)./conversion_factor./power_FFC1; % synchronize data of channel 1 and convert it (emitted fluorescence / excitation power)
d.analog_2 = d.analog_2(trig_idx(1):trig_idx(end))'; d.analog_2 = (d.analog_2-AFiber_2)./conversion_factor./power_FFC2; % synchronize data of channel 2 and convert it (emitted fluorescence / excitation power)

d.analog_1_s = movmean(d.analog_1, d.sampling_rate./1000.*smoothwindow_photometry);   % smooth 470 trace by calculating a moving mean
d.analog_2_s = movmean(d.analog_2, d.sampling_rate./1000.*smoothwindow_photometry);   % smooth 405 trace by calculating a moving mean

[p_d1] = polyfit([1:length(d.analog_1_s)],d.analog_1,fitorder);                           % perform polynomial fit of 470 nm excited trace
y_d1 = polyval(p_d1,[1:length(d.analog_1_s)]);                                            % create fitted curve for 470 nm excited trace
d.analog_1_c = d.analog_1_s./y_d1;                                                        % divide 470 nm excited trace by polynomial fit to correct for bleaching

[p_d2] = polyfit([1:length(d.analog_2_s)],d.analog_2_s,fitorder);                           % perform polynomial fit of 405 nm excited trace
y_d2 = polyval(p_d2,[1:length(d.analog_2_s)]);                                            % create fitted curve for 405 nm excited trace
d.analog_2_c = d.analog_2_s./y_d2;                                                        % divide 405 nm excited trace by polynomial fit to correct for bleaching

d.dFoF = (d.analog_1_c-d.analog_2_c); % calculate delta F over F as the difference between the corrected 470 and 405 trace


figure('color', [1 1 1])
subplot(2, 1, 1)
plot([1:length(d.analog_1_s)]./d.sampling_rate./60, d.analog_1_s, 'b'); hold on;
plot([1:length(d.analog_2_s)]./d.sampling_rate./60, d.analog_2_s, 'm')

subplot(2, 1, 2)
plot([1:length(d.dFoF)]./d.sampling_rate./60, d.dFoF, 'g')

