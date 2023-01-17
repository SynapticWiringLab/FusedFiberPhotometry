%% prepare workspace
clear all; close all; clc;

filePath = matlab.desktop.editor.getActiveFilename; % file path to the current script
location = regexp(filePath,'FFP_code','split'); % "location of the "FFP_code" folder"
addpath(location{1}+"FFP_code\");
% or add "FFP_code" into path manually by uncommenting and specifying the path:
% addpath('path_to_scripts\FFP_code')

%% define data files
Intensities =       data_location + '\FFP_data\Figure_S8\bleaching_intensities.xlsx';
pre_bleach_data =   data_location + '\FFP_data\Figure_S8\data_pre_bleach';
post_bleach_data =  data_location + '\FFP_data\Figure_S8\data_12h_bleach';


%% define variables
t_window = 5;                   % time window to take data from (seconds)         
conversion_factor = 0.76;       % at 550nm; factor to convert V in (given by doric lenses)

%% read in excel sheet and sort stimulation intensities
data = xlsread(Intensities); 
int_405 = data(:, 2); int_405 = int_405(~isnan(int_405)); 
int_470 = data(:, 3); int_470 = int_470(~isnan(int_470)); 
int_550 = data(:, 4); int_550 = int_550(~isnan(int_550));
clear data; 


%% browse through pre-bleaching data and sort it
pre_list = dir(fullfile(pre_bleach_data)); pre_list = pre_list(3:end);                          % assemble a list of files containing fiber autofluorescence data before bleaching
pre_data_405 = []; pre_data_470 = []; pre_data_550 = [];                                        % initiate variables to collect pre-bleach data

for fileIdx = 1:length(pre_list)                                                                % for each file
    
    cur_file = pre_list(fileIdx).name;                                                          % get the filename
    dummy = strsplit(cur_file, '-'); dummy = dummy{1}; dummy = strsplit(dummy, '_');            % get the excitation wavelength
    
    data = import_ppd(pre_bleach_data+'\'+cur_file);                                          % load data
    mean_intensity = mean(data.analog_1(1: data.sampling_rate*t_window));                       % calculate average fiber autofluorescence
    
    if dummy{1} == '405'
        pre_data_405 = vertcat(pre_data_405, [str2num(dummy{2}) mean_intensity]);               % sort data according to excitation wavelength
    elseif dummy{1} == '470'
        pre_data_470 = vertcat(pre_data_470, [str2num(dummy{2}) mean_intensity]);    
    elseif dummy{1} == '550'
        pre_data_550 = vertcat(pre_data_550, [str2num(dummy{2}) mean_intensity]); 
    end

end

[~, idx] = sort(pre_data_405(:, 1)); pre_data_405 = pre_data_405(idx, 2)./conversion_factor;    % sort data according to excitation power (405 nm)
[~, idx] = sort(pre_data_470(:, 1)); pre_data_470 = pre_data_470(idx, 2)./conversion_factor;    % sort data according to excitation power (470 nm)
[~, idx] = sort(pre_data_550(:, 1)); pre_data_550 = pre_data_550(idx, 2)./conversion_factor;    % sort data according to excitation power (550 nm)
    




%% browse through post-bleaching data and sort it
post_list = dir(fullfile(post_bleach_data)); post_list = post_list(3:end);                          % assemble a list of files containing fiber autofluorescence data after bleaching
post_data_405 = []; post_data_470 = []; post_data_550 = [];                                        % initiate variables to collect post-bleach data

for fileIdx = 1:length(post_list)                                                                % for each file
    
    cur_file = post_list(fileIdx).name;                                                          % get the filename
    dummy = strsplit(cur_file, '-'); dummy = dummy{1}; dummy = strsplit(dummy, '_');            % get the excitation wavelength
    
    data = import_ppd(post_bleach_data+'\'+cur_file);                                          % load data
    mean_intensity = mean(data.analog_1(1: data.sampling_rate*t_window));                       % calculate average fiber autofluorescence
    
    if dummy{1} == '405'
        post_data_405 = vertcat(post_data_405, [str2num(dummy{2}) mean_intensity]);               % sort data according to excitation wavelength
    elseif dummy{1} == '470'
        post_data_470 = vertcat(post_data_470, [str2num(dummy{2}) mean_intensity]);    
    elseif dummy{1} == '550'
        post_data_550 = vertcat(post_data_550, [str2num(dummy{2}) mean_intensity]); 
    end

end

[~, idx] = sort(post_data_405(:, 1)); post_data_405 = post_data_405(idx, 2)./conversion_factor;    % sort data according to excitation power (405 nm)
[~, idx] = sort(post_data_470(:, 1)); post_data_470 = post_data_470(idx, 2)./conversion_factor;    % sort data according to excitation power (470 nm)
[~, idx] = sort(post_data_550(:, 1)); post_data_550 = post_data_550(idx, 2)./conversion_factor;    % sort data according to excitation power (550 nm)
    

%% create figure
f1 = figure('color', [1 1 1]); hold on;                             % initiate figure
plot(int_405,pre_data_405, 'c-', 'color', [130, 0, 200]./255)       % plot fiber autofluorescence when excited with 405 nm before bleaching
plot(int_470,pre_data_470, 'b-', 'color', [	0, 169, 255]./255)      % plot fiber autofluorescence when excited with 470 nm before bleaching
plot(int_550,pre_data_550, 'r-', 'color', [163, 255, 0]./255)       % plot fiber autofluorescence when excited with 550 nm before bleaching

plot(int_405,post_data_405, 'c--', 'color', [130, 0, 200]./255)     % plot fiber autofluorescence when excited with 405 nm after bleaching
plot(int_470,post_data_470, 'b--', 'color', [	0, 169, 255]./255)  % plot fiber autofluorescence when excited with 470 nm after bleaching
plot(int_550,post_data_550, 'r--', 'color', [163, 255, 0]./255)     % plot fiber autofluorescence when excited with 550 nm after bleaching

ylabel('Fluorescence [nW]'); xlabel('Intensity at brain end [µW]'); % label axes
xlim([0 100]); ylim([0 5]); box on; axis square;                    % adjust axes appearance

