%% prepare workspace
clear all;  clc; close all;
addpath('G:\Alex\manuscripts\FusedFiberPhotometry_CellMethRep\02_final_submission\code')

%% define  data files - dataset 1: doric first, then FFC
% Fused Fiber System
FP_file =   'G:\Alex\manuscripts\FusedFiberPhotometry_CellMethRep\02_final_submission\data\Figure_3\D-F\24517_FFC-2022-08-12-142846.ppd';
NI_file =   'G:\Alex\manuscripts\FusedFiberPhotometry_CellMethRep\02_final_submission\data\Figure_3\D-F\VRdata_24517_FFC_20220812145012.mat';
AF =        'G:\Alex\manuscripts\FusedFiberPhotometry_CellMethRep\02_final_submission\data\Figure_3\D-F\24517_AF-2022-08-12-145308.ppd';

% FP_file =   'G:\Alex\manuscripts\FusedFiberPhotometry_CellMethRep\02_final_submission\data\Figure_3\D-F\24520_FFC-2022-08-12-145452.ppd';
% NI_file =   'G:\Alex\manuscripts\FusedFiberPhotometry_CellMethRep\02_final_submission\data\Figure_3\D-F\VRdata_24520_FFC_20220812151613.mat';
% AF =        'G:\Alex\manuscripts\FusedFiberPhotometry_CellMethRep\02_final_submission\data\Figure_3\D-F\24520_AF-2022-08-12-151832.ppd';

% FP_file =   'G:\Alex\manuscripts\FusedFiberPhotometry_CellMethRep\02_final_submission\data\Figure_3\D-F\24521_FFC-2022-08-12-152109.ppd';
% NI_file =   'G:\Alex\manuscripts\FusedFiberPhotometry_CellMethRep\02_final_submission\data\Figure_3\D-F\VRdata_24521_FFC_20220812154238.mat';
% AF =        'G:\Alex\manuscripts\FusedFiberPhotometry_CellMethRep\02_final_submission\data\Figure_3\D-F\24521_AF-2022-08-12-155202.ppd';

% doric system
% FP_file =   'G:\Alex\manuscripts\FusedFiberPhotometry_CellMethRep\02_final_submission\data\Figure_3\D-F\24517_doric-2022-08-12-125729.ppd';
% NI_file =   'G:\Alex\manuscripts\FusedFiberPhotometry_CellMethRep\02_final_submission\data\Figure_3\D-F\VRdata_24517_doric_20220812131854.mat';
% AF =        'G:\Alex\manuscripts\FusedFiberPhotometry_CellMethRep\02_final_submission\data\Figure_3\D-F\24517_dAF-2022-08-12-131922.ppd';

% FP_file =   'G:\Alex\manuscripts\FusedFiberPhotometry_CellMethRep\02_final_submission\data\Figure_3\D-F\24520_doric-2022-08-12-132204.ppd';
% NI_file =   'G:\Alex\manuscripts\FusedFiberPhotometry_CellMethRep\02_final_submission\data\Figure_3\D-F\VRdata_24520_doric_20220812134434.mat';
% AF =        'G:\Alex\manuscripts\FusedFiberPhotometry_CellMethRep\02_final_submission\data\Figure_3\D-F\24520_dAF-2022-08-12-134539.ppd';

% FP_file =   'G:\Alex\manuscripts\FusedFiberPhotometry_CellMethRep\02_final_submission\data\Figure_3\D-F\24521_doric-2022-08-12-134832.ppd';
% NI_file =   'G:\Alex\manuscripts\FusedFiberPhotometry_CellMethRep\02_final_submission\data\Figure_3\D-F\VRdata_24521_doric_20220812140952.mat';
% AF =        'G:\Alex\manuscripts\FusedFiberPhotometry_CellMethRep\02_final_submission\data\Figure_3\D-F\24521_dAF-2022-08-12-141032.ppd';



% define data files - dataset 2: FFC first, then doric
% Fused Fiber System
% FP_file =   'G:\Alex\manuscripts\FusedFiberPhotometry_CellMethRep\02_final_submission\data\Figure_3\D-F\25417_FFC-2022-08-18-103713.ppd';
% NI_file =   'G:\Alex\manuscripts\FusedFiberPhotometry_CellMethRep\02_final_submission\data\Figure_3\D-F\VRdata_25417_FFC_opto_20220818105935.mat';
% AF =        'G:\Alex\manuscripts\FusedFiberPhotometry_CellMethRep\02_final_submission\data\Figure_3\D-F\25417_AF-2022-08-18-110106.ppd';

% FP_file =   'G:\Alex\manuscripts\FusedFiberPhotometry_CellMethRep\02_final_submission\data\Figure_3\D-F\25420_FFC-2022-08-18-110558.ppd';
% NI_file =   'G:\Alex\manuscripts\FusedFiberPhotometry_CellMethRep\02_final_submission\data\Figure_3\D-F\VRdata_25420_FFC_opto_20220818112738.mat';
% AF =        'G:\Alex\manuscripts\FusedFiberPhotometry_CellMethRep\02_final_submission\data\Figure_3\D-F\25420_AF-2022-08-18-112833.ppd';

% FP_file =   'G:\Alex\manuscripts\FusedFiberPhotometry_CellMethRep\02_final_submission\data\Figure_3\D-F\25421_FFC-2022-08-18-113249.ppd';
% NI_file =   'G:\Alex\manuscripts\FusedFiberPhotometry_CellMethRep\02_final_submission\data\Figure_3\D-F\VRdata_25421_FFC_opto_20220818115928.mat';
% AF =        'G:\Alex\manuscripts\FusedFiberPhotometry_CellMethRep\02_final_submission\data\Figure_3\D-F\25421_AF-2022-08-18-120032.ppd';

% doric system
% FP_file =   'G:\Alex\manuscripts\FusedFiberPhotometry_CellMethRep\02_final_submission\data\Figure_3\D-F\25417_doric-2022-08-18-133407.ppd';
% NI_file =   'G:\Alex\manuscripts\FusedFiberPhotometry_CellMethRep\02_final_submission\data\Figure_3\D-F\VRdata_25417_doric_opto_20220818135631.mat';
% AF =        'G:\Alex\manuscripts\FusedFiberPhotometry_CellMethRep\02_final_submission\data\Figure_3\D-F\25417_dAF-2022-08-18-132935.ppd';

% FP_file =   'G:\Alex\manuscripts\FusedFiberPhotometry_CellMethRep\02_final_submission\data\Figure_3\D-F\25420_doric-2022-08-18-140208.ppd';
% NI_file =   'G:\Alex\manuscripts\FusedFiberPhotometry_CellMethRep\02_final_submission\data\Figure_3\D-F\VRdata_25420_doric_opto_20220818142359.mat';
% AF =        'G:\Alex\manuscripts\FusedFiberPhotometry_CellMethRep\02_final_submission\data\Figure_3\D-F\25420_dAF-2022-08-18-135948.ppd';

% FP_file =   'G:\Alex\manuscripts\FusedFiberPhotometry_CellMethRep\02_final_submission\data\Figure_3\D-F\25421_doric-2022-08-18-142945.ppd';
% NI_file =   'G:\Alex\manuscripts\FusedFiberPhotometry_CellMethRep\02_final_submission\data\Figure_3\D-F\VRdata_25421_doric_opto_20220818145111.mat';
% AF =        'G:\Alex\manuscripts\FusedFiberPhotometry_CellMethRep\02_final_submission\data\Figure_3\D-F\25421_dAF-2022-08-18-142831.ppd';




AFdata = import_ppd(AF);
AFdata.AF470 = median(AFdata.analog_1);
AFdata.AF405 = median(AFdata.analog_2);


%% define variables
SR_NI = 3000;                   % sampling rate (national instruments board)
fitorder = 1;                   % degree of polynomial to fit bleaching of photometry data
twindow = 2;                    % time window after stimulus to be averaged (in seconds)
smoothwindow_photometry	= 100;	% time window to smooth photometry data by moving average, in ms
stimdur = 0.2;                  % stimulus duration in ms


%% load and process photometry data
d = import_ppd(FP_file);

trig_idx   = find(d.digital_1(1:end-1) < 0.5 & d.digital_1(2:end) > 0.5)+1;         % find first and last trigger for data synchronization
d.analog_1 = d.analog_1(trig_idx(1):trig_idx(end)+1)';                              % synchronize data of channel 1 
d.analog_2 = d.analog_2(trig_idx(1):trig_idx(end)+1)';                              % synchronize data of channel 2 
d.analog_1 = d.analog_1-AFdata.AF470;                                               % subtract AF from channel 1 
d.analog_2 = d.analog_2-AFdata.AF405;                                               % subtract AF from channel 2 
d.analog_1 = movmedian(d.analog_1 , 3);                                             % remove 1 sample stimulation artefact in channel 1
d.analog_2 = movmedian(d.analog_2 , 3);                                             % remove 1 sample stimulation artefact in channel 2

d.analog_1_s = movmean(d.analog_1, d.sampling_rate./1000.*smoothwindow_photometry);   % smooth 470 trace by calculating a moving mean
d.analog_2_s = movmean(d.analog_2, d.sampling_rate./1000.*smoothwindow_photometry);   % smooth 405 trace by calculating a moving mean


[p_d1] = polyfit([1:length(d.analog_1_s)],d.analog_1_s,fitorder); y_d1 = polyval(p_d1,[1:length(d.analog_1_s)]); d.analog_1_c = d.analog_1_s./y_d1;     % perform polynomial fit of channel 1 and divide signal by this fit to remove bleaching
[p_d2] = polyfit([1:length(d.analog_2_s)],d.analog_2_s,fitorder); y_d2 = polyval(p_d2,[1:length(d.analog_2_s)]); d.analog_2_c = d.analog_2_s./y_d2;     % perform polynomial fit of channel 2 and divide signal by this fit to remove bleaching

d.dFoF = (d.analog_1_c-d.analog_2_c); % calculate delta F over F as the difference between the corrected 470 and 405 trace


%% load and process NI data
NI_data = load(NI_file);
NI_trig_idx   = find(NI_data.data.values(2, 1:end-1) < 3 & NI_data.data.values(2, 2:end) > 3)+1;    % find first and last trigger for data synchronization
LaserStim = NI_data.data.values(7, NI_trig_idx(1):NI_trig_idx(end));                                % extract synchronized data of optogenetic stimulation
LaserStim = dwnsmp(LaserStim, SR_NI, d.sampling_rate);                                              % re-sample to match the sampling rate of photometry data
LaserStim = rescale(LaserStim, 0, 1);                                                               % re-scale laser stimulus between 0 and 1
Laser_onset = find(LaserStim(1:end-1) < 0.7 & LaserStim(2:end) > 0.7)+1;                            % detect onset of optogenetic stimulation


%% identify evoked responses by averaging data in response to different stimuli
for idx_trial = 1:length(Laser_onset)                                                                                                                   % for each trial (i.e. onset of optogentic stimulation)...    
    d.d470_rel_Stim(idx_trial, :)           = d.analog_1_s(Laser_onset(idx_trial)-d.sampling_rate:Laser_onset(idx_trial)+(twindow.*d.sampling_rate));   % ...crop data of the defined timewindow, with a pre-stimulus baseline period of 1 second
    d.d405_rel_Stim(idx_trial, :)           = d.analog_2_s(Laser_onset(idx_trial)-d.sampling_rate:Laser_onset(idx_trial)+(twindow.*d.sampling_rate));
    d.dFoF_rel_Stim(idx_trial, :)           = d.dFoF      (Laser_onset(idx_trial)-d.sampling_rate:Laser_onset(idx_trial)+(twindow.*d.sampling_rate));     
end

d.d470_rel_Stim_norm = d.d470_rel_Stim-repmat(median(d.d470_rel_Stim(:, 1:d.sampling_rate), 2), 1, size(d.d470_rel_Stim, 2));
d.d405_rel_Stim_norm = d.d405_rel_Stim-repmat(median(d.d405_rel_Stim(:, 1:d.sampling_rate), 2), 1, size(d.d405_rel_Stim, 2));
d.dFoF_rel_Stim_norm = d.dFoF_rel_Stim-repmat(median(d.dFoF_rel_Stim(:, 1:d.sampling_rate), 2), 1, size(d.dFoF_rel_Stim, 2));                        % normalize data to be zero at stimulus onset


%% create figure
f1 = figure('color', [1 1 1]);
subplot(3, 3, 1:3); hold on;
plot([1:length(LaserStim)]./d.sampling_rate, rescale(LaserStim,min([d.analog_1_c, d.analog_2_c]),max([d.analog_1_c, d.analog_2_c])), 'color', [255, 153, 51]./255); hold on; 
plot([1:length(d.analog_1_c)]./d.sampling_rate, d.analog_1_c, 'color', [51, 133, 255]./255);
plot([1:length(d.analog_2_c)]./d.sampling_rate, d.analog_2_c, 'color', [115, 0, 230]./255);
xlim([0 length(d.dFoF)./d.sampling_rate]);


subplot(3, 3, 4:6);
plot([1:length(LaserStim)]./d.sampling_rate, rescale(LaserStim,min(d.dFoF),max(d.dFoF)), 'color', [255, 153, 51]./255); hold on; 
plot([1:length(d.dFoF)]./d.sampling_rate, d.dFoF, 'color', [51, 204, 51]./255);
xlim([0 length(d.dFoF)./d.sampling_rate]);

    
ax1 = subplot(3, 3, 7);
c.color_area = [51, 133, 255]./255; c.color_line =  [51, 133, 255]./255; c.x_axis = [1:length(d.dFoF_rel_Stim)]./d.sampling_rate-1; c.error = 'std'; c.handle     = gcf; c.alpha      = 0.5; c.line_width = 2; % define plotting properties for "plot_areaerrorbar"-function 
plot_areaerrorbar(d.d470_rel_Stim, c); % create actual plot
xlim([-1 twindow]); % align time axix

ax2 = subplot(3, 3, 8);
c.color_area = [115, 0, 230]./255; c.color_line =  [115, 0, 230]./255; c.x_axis = [1:length(d.dFoF_rel_Stim)]./d.sampling_rate-1; c.error = 'std'; c.handle     = gcf; c.alpha      = 0.5; c.line_width = 2; % define plotting properties for "plot_areaerrorbar"-function 
plot_areaerrorbar(d.d405_rel_Stim, c); % create actual plot
xlim([-1 twindow]); % align time axix

ax3 = subplot(3, 3, 9);
c.color_area = [51, 204, 51]./255; c.color_line =  [51, 204, 51]./255; c.x_axis = [1:length(d.dFoF_rel_Stim)]./d.sampling_rate-1; c.error = 'std'; c.handle     = gcf; c.alpha      = 0.5; c.line_width = 2; % define plotting properties for "plot_areaerrorbar"-function 
plot_areaerrorbar(d.dFoF_rel_Stim, c); % create actual plot
xlim([-1 twindow]); % align time axix
linkaxes([ax1, ax2, ax3], 'x'); 


mean470     = mean(d.d470_rel_Stim_norm); resp470 = max(mean470)
mean405     = mean(d.d405_rel_Stim_norm); resp405 = min(mean405)

