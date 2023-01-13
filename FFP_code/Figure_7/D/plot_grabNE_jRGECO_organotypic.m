%% prepare workspace
clear all; close all; clc;
addpath('G:\Alex\manuscripts\FusedFiberPhotometry_CellMethRep\02_final_submission\code')

%% define data files
FP_file = 'G:\Alex\manuscripts\FusedFiberPhotometry_CellMethRep\02_final_submission\data\Figure_7\D\slice3-2021-11-19-170052.ppd'; % 1 drop of bicuculline after 1:30 min, 1 drop of norepinephrine after 3:00 min


%% define variables
lp_cutoff = 10;         % cut-off frequency of low-pass filter
Fzero_perc = 10;        % percentile of data trace to estimate baseline fluorescence

%% load and process photometry data
d = import_ppd([FP_file]);

d.d1_f = lowpass(d.analog_1,lp_cutoff,d.sampling_rate);  	% low-pass filter channel 1
F0_1 = prctile(d.d1_f, Fzero_perc);                        	% calculate F-zero for channel 1
d.dFoF_1 = (d.d1_f-F0_1)./F0_1;                             % calculate delta F over F channel 1

d.d2_f = lowpass(d.analog_2,lp_cutoff,d.sampling_rate);  	% low-pass filter channel 2
F0_2 = prctile(d.d2_f, Fzero_perc);                        	% calculate F-zero for channel 2
d.dFoF_2 = (d.d2_f-F0_2)./F0_2;                             % calculate delta F over F channel 2



%% create figure
figure('color', [1 1 1]); hold on;                                  % initiate figure
plot([1:length(d.d1_f)]./d.sampling_rate, d.d1_f, 'g');             % plot dFoF for green channel (grabNE)
plot([1:length(d.d2_f)]./d.sampling_rate, d.d2_f, 'r');             % plot dFoF for red channel (jRGECO1a)    

plot([90 90], [0 2.5], 'k--');                                      % plot dashed line indicating applicaiton of bicuculline
plot([180 180], [0 2.5], 'k:');                                     % plot dotted line indicating application of norepinephrine   

xlim([1 241]); ylim([0 2.5]); xlabel('time [s]'); ylabel('dFoF');   % adjust plot appearance


