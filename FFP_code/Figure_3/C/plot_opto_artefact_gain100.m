%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% A flexible and versatile system for multi-color fiber photometry and optogenetic manipulation
% Andrey Formozov, Alexander Dieter, J. Simon Wiegert
% code: Dieter, A, 2022 
% reviewed: Formozov, A, 2023
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% prepare workspace
clear all; close all; clc;
% add "FFP_code" into path 
filePath = matlab.desktop.editor.getActiveFilename; % file path to the current script
location = regexp(filePath,'FFP_code','split'); % "location of the "FFP_code" folder"
addpath(location{1}+"FFP_code\");
% or add "FFP_code" into path manually by uncommenting and specifying the path:
% addpath('path_to_scripts\FFP_code')

%% define  data files
FP_file = data_location + '\FFP_data\Figure_3\C\ctrl_200uW-2021-05-10-115658.ppd';
NI_file = data_location + '\FFP_data\Figure_3\C\VRdata_ctrl_100__20210510120059.mat';

%% define variables
SR_NI = 3000;           % sampling rate (national instruments board)
fitorder = 2;           % degree of polynomial to fit bleaching of photometry data
twindow = 5;            % time window after stimulus to be averaged (in seconds)
lp_cutoff = 10;         % cut-off frequency of low-pass filter


%% load and process photometry data
d = import_ppd(FP_file);

trig_idx   = find(d.digital_1(1:end-1) < 0.5 & d.digital_1(2:end) > 0.5)+1;         % find first and last trigger for data synchronization
d.analog_1 = d.analog_1(trig_idx(1):trig_idx(end)+1)';                              % synchronize data of channel 1 
d.analog_2 = d.analog_2(trig_idx(1):trig_idx(end)+1)';                              % synchronize data of channel 1 

[p_d1] = polyfit([1:length(d.analog_1)],d.analog_1,fitorder); y_d1 = polyval(p_d1,[1:length(d.analog_1)]); d.analog_1_c = d.analog_1./y_d1;     % perform polynomial fit of channel 1 and divide signal by this fit to remove bleaching
[p_d2] = polyfit([1:length(d.analog_2)],d.analog_2,fitorder); y_d2 = polyval(p_d2,[1:length(d.analog_2)]); d.analog_2_c = d.analog_2./y_d2;     % perform polynomial fit of channel 2 and divide signal by this fit to remove bleaching

d.d1_f = lowpass(d.analog_1_c,lp_cutoff,d.sampling_rate);       % low-pass filter channel 1
d.d2_f = lowpass(d.analog_2_c,lp_cutoff,d.sampling_rate);       % low-pass filter channel 2
dFoF = (d.d1_f-d.d2_f)./d.d2_f;                                 % calculate delta F over F


%% load and process NI data
NI_data = load(NI_file);
NI_trig_idx   = find(NI_data.data.values(2, 1:end-1) < 3 & NI_data.data.values(2, 2:end) > 3)+1;    % find first and last trigger for data synchronization
LaserStim = NI_data.data.values(8, NI_trig_idx(1):NI_trig_idx(end));                                % extract synchronized data of optogenetic stimulation
LaserStim = dwnsmp(LaserStim, SR_NI, d.sampling_rate);                                              % re-sample to match the sampling rate of photometry data
Laser_onset = find(LaserStim(1:end-1) < 3 & LaserStim(2:end) > 3)+1;                                % detect onset of optogenetic stimulation


%% identify evoked responses by averaging data in response to different stimuli
for idx_trial = 1:length(Laser_onset)                                                                                                   % for each trial (i.e. onset of optogentic stimulation)...
    d.dFoF_rel_Stim(idx_trial, :) = dFoF(Laser_onset(idx_trial)-d.sampling_rate:Laser_onset(idx_trial)+(twindow.*d.sampling_rate));     % ...crop data of the defined timewindow, with a pre-stimulus baseline period of 1 second
end
d.dFoF_rel_Stim_norm = d.dFoF_rel_Stim-repmat(d.dFoF_rel_Stim(:, d.sampling_rate), 1, size(d.dFoF_rel_Stim, 2));                        % normalize data to be zero at stimulus onset


%% create figure
f1 = figure('color', [1 1 1]);
c.color_area = [51, 204, 51]./255; c.color_line =  [51, 204, 51]./255; c.x_axis = [1:length(d.dFoF_rel_Stim)]./d.sampling_rate-1; c.error = 'std'; c.handle     = gcf; c.alpha      = 0.5; c.line_width = 2; % define plotting properties for "plot_areaerrorbar"-function 
plot_areaerrorbar(d.dFoF_rel_Stim, c); % create actual plot
xlim([-1 twindow]); % align time axix
    
 
