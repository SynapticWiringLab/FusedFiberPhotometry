%% prepare workspace
clear all; close all; clc;

filePath = matlab.desktop.editor.getActiveFilename; % file path to the current script
location = regexp(filePath,'FFP_code','split'); % "location of the "FFP_code" folder"
addpath(location{1}+"FFP_code\");
% or add "FFP_code" into path manually by uncommenting and specifying the path:
% addpath('path_to_scripts\FFP_code')

%% define  data files (choose one of the three animals by (un)commenting)
FP_files =   {  data_location + '\FFP_data\Figure_6\D_E\15242_wt-opto-2021-10-05-141540.ppd';
                data_location + '\FFP_data\Figure_6\D_E\15242_wt-opto-2021-10-05-153628.ppd'};
NI_files =   {  data_location + '\FFP_data\Figure_6\D_E\VRdata_15242_wt-opto_20211005143510.mat';
                data_location + '\FFP_data\Figure_6\D_E\VRdata_15242_wt-opto_20211005155311.mat'};
            
% FP_files =   {  data_location + '\FFP_data\Figure_6\D_E\15252_wt-opto-2021-10-05-145749.ppd';
%                 data_location + '\FFP_data\Figure_6\D_E\15252_wt-opto-2021-10-05-162440.ppd'};
% NI_files =   {  data_location + '\FFP_data\Figure_6\D_E\VRdata_15252_wt-opto_20211005151446.mat';
%                 data_location + '\FFP_data\Figure_6\D_E\VRdata_15252_wt-opto_20211005164148.mat'};

% FP_files =   {  data_location + '\FFP_data\Figure_6\D_E\15436_wt-opto-2021-10-05-143739.ppd';
%                 data_location + '\FFP_data\Figure_6\D_E\15436_wt-opto-2021-10-05-160550.ppd'};
% NI_files =   {  data_location + '\FFP_data\Figure_6\D_E\VRdata_15436_wt-opto_20211005145523.mat';
%                 data_location + '\FFP_data\Figure_6\D_E\VRdata_15436_wt-opto_20211005162237.mat'};






%% define variables
SR_NI = 3000;           % sampling rate (national instruments board)
fitorder = 2;           % degree of polynomial to fit bleaching of photometry data
twindow = 10;            % time window after stimulus to be averaged (in seconds)
lp_cutoff = 10;         % cut-off frequency of low-pass filter
Fzero_perc = 10;        % percentile of data trace to estimate baseline fluorescence


dFoF_rel_Stim_norm_all = []; dFoF_ctrl_all = []; % initiate variables to collect stimulus-locked data

%% load and process photometry data
for iFile = 1:size(FP_files, 1) % for all files
    
    d = import_ppd(FP_files{iFile});
    
    trig_idx   = find(d.digital_1(1:end-1) < 0.5 & d.digital_1(2:end) > 0.5)+1;         % find first and last trigger for data synchronization
    d.analog_1 = d.analog_1(trig_idx(1):trig_idx(end)+1)';                              % synchronize data of channel 1
    d.analog_1 = movmedian(d.analog_1, 3);                                              % moving median filter of window size 3, to remove single-sample artefacts of on-/offsets of optogentic stimulation
    
    [p_d1] = polyfit([1:length(d.analog_1)],d.analog_1,fitorder); y_d1 = polyval(p_d1,[1:length(d.analog_1)]); d.analog_1_c = d.analog_1./y_d1;     % perform polynomial fit of channel 1 and divide signal by this fit to remove bleaching
    
    d.d1_f = lowpass(d.analog_1_c,lp_cutoff,d.sampling_rate);  	% low-pass filter channel 1
    F0 = prctile(d.d1_f, Fzero_perc);                           % calculate F-zero
    d.dFoF = (d.d1_f-F0)./F0;                                   % calculate delta F over F

    %% load and process NI data
    NI_data = load(NI_files{iFile});
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
    
    dFoF_rel_Stim_norm_all    = vertcat(dFoF_rel_Stim_norm_all, d.dFoF_rel_Stim_norm);  % collect data of multiple files in this variable
    dFoF_ctrl_all             = vertcat(dFoF_ctrl_all, d.dFoF_ctrl_norm);               % collect data of multiple files in this variable

end


%% create figure
f1 = figure('color', [1 1 1]);  % create figure

subplot(1, 2, 1);               % create first subplot
imagesc([1:length(dFoF_rel_Stim_norm_all)]./d.sampling_rate-1, 1:size(dFoF_rel_Stim_norm_all, 1),  dFoF_rel_Stim_norm_all);     % create plot (heat map of individual trials)
colorbar; colormap gray; caxis([-0.01 0.01]); xlabel('time [s]'); ylabel('trial');                                  % adjust plot appearance

subplot(1, 2, 2);              	% create second subplot
c.color_area = [50, 50, 50]./255; c.color_line =  [50, 50, 50]./255; c.x_axis = [1:length(dFoF_rel_Stim_norm_all)]./d.sampling_rate-1; c.error = 'sem'; c.handle = gcf; c.alpha = 0.5; c.line_width = 2;  % define plot appearance
plot_areaerrorbar(dFoF_rel_Stim_norm_all, c); hold on;                          % plot stimulus-locked response
c.color_area = [200, 200, 200]./255; c.color_line =  [200, 200, 200]./255;      % define plot appearance for control trials
plot_areaerrorbar(dFoF_ctrl_all, c); hold on;                                   % plot control trials
xlim([-1 twindow]); ylim([-0.005 0.005]); xlabel('time [s]'); ylabel('dFoF') 	% adjust plot appearance

