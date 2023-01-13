%% prepare workspace
clear all; close all; clc;
addpath('G:\Alex\manuscripts\FusedFiberPhotometry_CellMethRep\02_final_submission\code')

%% define  data files
FP_file =   'G:\Alex\manuscripts\FusedFiberPhotometry_CellMethRep\02_final_submission\data\Figure_6\F\WT_opto-2021-11-09-171730.ppd'; 
NI_file =   'G:\Alex\manuscripts\FusedFiberPhotometry_CellMethRep\02_final_submission\data\Figure_6\F\VRdata_WT_opto_20211109172657.mat';
    

%% define variables
SR_NI = 3000;           % sampling rate (national instruments board)
fitorder = 5;           % degree of polynomial to fit bleaching of photometry data
twindow = 10;            % time window after stimulus to be averaged (in seconds)
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
Laser_onset = find(LaserStim(1:end-1) < 3 & LaserStim(2:end) > 3)+1;                                % detect onset of optogenetic stimulation


%% identify evoked responses by averaging data in response to different stimuli
for idx_trial = 1:length(Laser_onset)                                                                                                   % for each trial (i.e. onset of optogentic stimulation)...
    d.dFoF_rel_Stim(idx_trial, :) = d.dFoF(Laser_onset(idx_trial)-d.sampling_rate:Laser_onset(idx_trial)+(twindow.*d.sampling_rate));   % ...crop data of the defined timewindow, with a pre-stimulus baseline period of 1 second
end
d.dFoF_rel_Stim_norm = d.dFoF_rel_Stim-repmat(d.dFoF_rel_Stim(:, d.sampling_rate), 1, size(d.dFoF_rel_Stim, 2));                        % normalize data to be zero at stimulus onset

ctrl_idx = randi([round(twindow/3*d.sampling_rate) length(d.dFoF)-(twindow*d.sampling_rate)],1,length(Laser_onset));                    % generate random indices as "onsets" for control condition
for i_ctrl = 1:length(ctrl_idx)                                                                                                         % for each control trial (i.e. onset of control condition)...
    d.dFoF_ctrl(i_ctrl, :) = d.dFoF(ctrl_idx(i_ctrl)-d.sampling_rate:ctrl_idx(i_ctrl)+(twindow.*d.sampling_rate));                        % ...crop data of the defined timewindow, with a pre-stimulus baseline period of 1 second
end
d.dFoF_ctrl_norm = d.dFoF_ctrl-repmat(d.dFoF_ctrl(:, d.sampling_rate), 1, size(d.dFoF_ctrl, 2));




%% create figure
f1 = figure('color', [1 1 1]);  % create figure

subplot(1, 2, 1);               % create first subplot
imagesc([1:length(d.dFoF_rel_Stim_norm)]./d.sampling_rate-1, 1:length(Laser_onset),  d.dFoF_rel_Stim_norm);     % create plot (heat map of individual trials)
colorbar; colormap gray; caxis([-0.003 0.003]); xlabel('time [s]'); ylabel('trial');                            % adjust plot appearance

subplot(1, 2, 2);              	% create second subplot
c.color_area = [50, 50, 50]./255; c.color_line =  [50, 50, 50]./255; c.x_axis = [1:length(d.dFoF_rel_Stim_norm)]./d.sampling_rate-1; c.error = 'sem'; c.handle = gcf; c.alpha = 0.5; c.line_width = 2;  % define plot appearance
plot_areaerrorbar(d.dFoF_rel_Stim_norm, c); hold on;                            % plot stimulus-locked response
c.color_area = [200, 200, 200]./255; c.color_line =  [200, 200, 200]./255;      % define plot appearance for control trials
plot_areaerrorbar(d.dFoF_ctrl_norm, c); hold on;                                     % plot control trials
xlim([-1 twindow]); ylim([-0.005 0.005]); xlabel('time [s]'); ylabel('dFoF')    % adjust plot appearance

