%% prepare workspace
clear all; close all; clc;

filePath = matlab.desktop.editor.getActiveFilename; % file path to the current script
location = regexp(filePath,'FFP_code','split'); % "location of the "FFP_code" folder"
addpath(location{1}+"FFP_code\");
% or add "FFP_code" into path manually by uncommenting and specifying the path:
% addpath('path_to_scripts\FFP_code')

%% define data files
data = import_ppd_4channel(data_location + '\FFP_data\Figure_7\G\ABtest_4BP-2021-03-19-174356.ppd');

data490 = data.analog_2_ca-median(data.analog_2_ca);      % subtract median fluorescence from channel 2 (green)
data550 = data.analog_2_iso-median(data.analog_2_iso);    % subtract median fluorescence from channel 3 (red)
data650 = data.analog_1_iso-median(data.analog_1_iso);    % subtract median fluorescence from channel 4 (far-red)    


%% create figure
figure('color', [1 1 1]);                               % initiate figure
ax1 = subplot(3, 3, 1); title('alexa 488'); hold on;    % initiate first subplot (alexa488)
plot([0:130]./data.sampling_rate, smooth(data490(2435:2565)), 'color', [41, 163, 41]./256, 'LineWidth', 1.5);   % plot green channel for alexa488
ylabel('green channel');
ax2 = subplot(3, 3, 4);  hold on;    
plot([0:130]./data.sampling_rate, smooth(data550(2435:2565)), 'color', [255, 0, 102]./256, 'LineWidth', 1.5);   % plot red channel for alexa488
ylabel('red channel');
ax3 = subplot(3, 3, 7);  hold on;
plot([0:130]./data.sampling_rate, smooth(data650(2435:2565)), 'color', [102, 0, 0]./256, 'LineWidth', 1.5);     % plot far-red channel for alexa488
ylabel('far-red channel');

ax4 = subplot(3, 3, 2); title('alexa 546'); hold on;    % initiate second subplot (alexa546)
plot([0:130]./data.sampling_rate, smooth(data490(3645:3775)), 'color', [41, 163, 41]./256, 'LineWidth', 1.5);   % plot green channel for alexa546 
ylabel('green channel');
ax5 = subplot(3, 3, 5);  hold on;  
plot([0:130]./data.sampling_rate, smooth(data550(3645:3775)), 'color', [255, 0, 102]./256, 'LineWidth', 1.5);   % plot red channel for alexa546
ylabel('red channel');
ax6 = subplot(3, 3, 8);  hold on;  
plot([0:130]./data.sampling_rate, smooth(data650(3645:3775)), 'color', [102, 0, 0]./256, 'LineWidth', 1.5);     % plot far-red channel for alexa546
ylabel('far-red channel');

ax7 = subplot(3, 3, 3); title('alexa 647'); hold on;    % initiate third subplot (alexa647)
plot([0:130]./data.sampling_rate, smooth(data490(5135:5265)), 'color', [41, 163, 41]./256, 'LineWidth', 1.5);   % plot green channel for alexa647
ylabel('green channel');
ax8 = subplot(3, 3, 6);  hold on; 
plot([0:130]./data.sampling_rate, smooth(data550(5135:5265)), 'color', [255, 0, 102]./256, 'LineWidth', 1.5);   % plot red channel for alexa647
ylabel('red channel');
ax9 = subplot(3, 3, 9);  hold on; 
plot([0:130]./data.sampling_rate, smooth(data650(5135:5265)), 'color', [102, 0, 0]./256, 'LineWidth', 1.5);     % plot far-red channel for alexa647
ylabel('far-red channel');

xlim([0 4]); ylim([0 1]); linkaxes([ax1, ax2, ax3, ax4, ax5, ax6, ax7, ax8, ax9]);    % adjust axes limits


