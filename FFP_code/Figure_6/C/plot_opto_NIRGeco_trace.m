%% prepare workspace
clear all; close all; clc;

filePath = matlab.desktop.editor.getActiveFilename; % file path to the current script
location = regexp(filePath,'FFP_code','split'); % "location of the "FFP_code" folder"
addpath(location{1}+"FFP_code\");
% or add "FFP_code" into path manually by uncommenting and specifying the path:
% addpath('path_to_scripts\FFP_code')

%% define  data files
FP_file =   data_location + '\FFP_data\Figure_6\C\DAT93opto-2021-09-29-191433.ppd';
NI_file =   data_location + '\FFP_data\Figure_6\C\VRdata_DAT93_FFC_opto_20210929193117.mat';

%% define variables
SR_NI = 3000;           % sampling rate (national instruments board)
fitorder = 5;           % degree of polynomial to fit bleaching of photometry data
twindow = 5;            % time window after stimulus to be averaged (in seconds)
lp_cutoff = 10;         % cut-off frequency of low-pass filter
Fzero_perc = 10;        % percentile of data trace to estimate baseline fluorescence

%% load and process photometry data
d = import_ppd(FP_file);

trig_idx   = find(d.digital_1(1:end-1) < 0.5 & d.digital_1(2:end) > 0.5)+1;         % find first and last trigger for data synchronization
d.analog_1 = d.analog_1(trig_idx(1):trig_idx(end)+1)';                              % synchronize data of channel 1 
d.analog_1 = movmedian(d.analog_1, 3);                                              % moving median filter of window size 3, to remove single-sample artefacts of on-/offsets of optogentic stimulation

[p_d1] = polyfit([1:length(d.analog_1)],d.analog_1,fitorder); y_d1 = polyval(p_d1,[1:length(d.analog_1)]); d.analog_1_c = d.analog_1./y_d1;     % perform polynomial fit of channel 1 and divide signal by this fit to remove bleaching

d.d1_f = lowpass(d.analog_1_c,lp_cutoff,d.sampling_rate);  	% low-pass filter channel 1
F0 = prctile(d.d1_f, Fzero_perc);                           % calculate F-zero
d.dFoF = (d.d1_f-F0)./F0;                                   % calculate delta F over F


%% load and process NI data
NI_data = load(NI_file);
NI_trig_idx   = find(NI_data.data.values(2, 1:end-1) < 3 & NI_data.data.values(2, 2:end) > 3)+1;    % find first and last trigger for data synchronization
LaserStim = NI_data.data.values(7, NI_trig_idx(1):NI_trig_idx(end));                                % extract synchronized data of optogenetic stimulation
LaserStim = dwnsmp(LaserStim, SR_NI, d.sampling_rate);                                              % re-sample to match the sampling rate of photometry data


%% create figure
f1 = figure('color', [1 1 1]);                                                                              % initiate figure
plot([1:length(d.dFoF)]./d.sampling_rate, d.dFoF, 'color', [51, 204, 51]./255); hold on;                    % plot dFoF
plot([1:length(LaserStim)]./d.sampling_rate, rescale(LaserStim,0, 0.01), 'color', [255, 153, 51]./255);     % plot optogentic stimulation
ylim([-0.01 0.01]); xlabel('time [s]'); ylabel('dFoF');                                    % limit and label axes        
xlim([200 380]); % (optional to set time window to look at)