%% prepare workspace
clear all; clc;

filePath = matlab.desktop.editor.getActiveFilename; % file path to the current script
location = regexp(filePath,'FFP_code','split'); % "location of the "FFP_code" folder"
addpath(location{1}+"FFP_code\");
% or add "FFP_code" into path manually by uncommenting and specifying the path:
% addpath('path_to_scripts\FFP_code')

%% define data files
WT_NIRFilt =        {data_location + '\FFP_data\Figure_S6\B_C\15242_NIR-2021-10-05-141540.ppd';    % WT animals, implanted and recorded with 6505 nm at 433 µW
                     data_location + '\FFP_data\Figure_S6\B_C\15252_NIR-2021-10-05-145749.ppd';
                     data_location + '\FFP_data\Figure_S6\B_C\15436_NIR-2021-10-05-143739.ppd'};

NIRGeco_session1 =   {data_location + '\FFP_data\Figure_S6\B_C\DAT92-2021-10-05-151721.ppd';        % NIR-GECO2-animals, implanted and recorded with 650 nm at 433 µW
                     data_location + '\FFP_data\Figure_S6\B_C\DAT93-2021-10-05-164351.ppd'};

NIRGeco_session2 =  {data_location + '\FFP_data\Figure_S6\B_C\DAT11_l-2021-07-06-142159.ppd';       % NIR-GECO2-animals, implanted and recorded with 650 nm at 660 µW
                     data_location + '\FFP_data\Figure_S6\B_C\DAT11_r-2021-07-06-132722.ppd';
                     data_location + '\FFP_data\Figure_S6\B_C\DAT12_l-2021-07-06-135546.ppd';
                     data_location + '\FFP_data\Figure_S6\B_C\DAT12_r-2021-07-06-130217.ppd'}; 
     
     
     
%% define variables
ex1_session1 = 433; % excitation power in µW during first session (for 650 nm)
ex1_session2 = 660; % excitation power in µW during second session (for 650 nm)

fitorder = 2;       % degree of polynomial to fit bleaching of photometry data


%% load and process data of wildtype animals in session 1
for idx_file = 1:size(WT_NIRFilt, 1)
    data = import_ppd(WT_NIRFilt{idx_file});                    % import data
    data.analog_1 = data.analog_1'./ex1_session1;            	% normalize fluorescence of channel 1 to excitation power   
    wtNIRFilt.median_1(idx_file) = median(data.analog_1);       % calculate median fluorescence of channel 1
    [p_1,S_1] = polyfit([1:length(data.analog_1)], data.analog_1, fitorder); y_1 = polyval(p_1,[1:length(data.analog_1)], S_1); % perform polynomial fit of channel 1 to estimate bleaching  
    wtNIRFilt.bleach_1(idx_file) = ((max(y_1)-min(y_1))./wtNIRFilt.median_1(idx_file))./(length(y_1)./data.sampling_rate);      % calculate bleaching of channel 1 as the decay in signal of the polynomial fit (in %) normalized to the recording length
end


%% load and process data of NIR-GECO2 animals in session 1
for idx_file = 1:size(NIRGeco_session1, 1)
    data = import_ppd(NIRGeco_session1{idx_file});              % import data
    data.analog_1 = data.analog_1'./ex1_session1;               % normalize fluorescence of channel 1 to excitation power   
    GECO.median_1(idx_file) = median(data.analog_1);            % calculate median fluorescence of channel 1
    [p_1,S_1] = polyfit([1:length(data.analog_1)], data.analog_1, fitorder); y_1 = polyval(p_1,[1:length(data.analog_1)], S_1); % perform polynomial fit of channel 1 to estimate bleaching 
    GECO.bleach_1(idx_file) = ((max(y_1)-min(y_1))./GECO.median_1(idx_file))./(length(y_1)./data.sampling_rate);                % calculate bleaching of channel 1 as the decay in signal of the polynomial fit (in %) normalized to the recording length
end

%% load and process data of NIR-GECO2 animals in session 2
for idx_file = 1:size(NIRGeco_session2, 1) 
    data = import_ppd(NIRGeco_session2{idx_file});              % import data
    data.analog_1 = data.analog_1'./ex1_session2;               % normalize fluorescence of channel 1 to excitation power
    GECO.median_1(idx_file+2) = median(data.analog_1);        	% calculate median fluorescence of channel 1 
    [p_1,S_1] = polyfit([1:length(data.analog_1)], data.analog_1, fitorder); y_1 = polyval(p_1,[1:length(data.analog_1)], S_1); % perform polynomial fit of channel 1 to estimate bleaching 
    GECO.bleach_1(idx_file+2) = ((max(y_1)-min(y_1))./GECO.median_1(idx_file))./(length(y_1)./data.sampling_rate);              % calculate bleaching of channel 1 as the decay in signal of the polynomial fit (in %) normalized to the recording length
end


%% create figure

f0 = figure('color', [1 1 1]);                                                                                                  % initiate figure
subplot(1, 2, 1); title('median fluorescence [rel/µW]'); hold on;                                                               % initiate first subplot to plot absolute fluorescence
plot(1, wtNIRFilt.median_1, 'r.', 'color', [161, 0, 0]./255);                                                                   % plot individual data points for wildtype animals                    
errorbar(1, mean(wtNIRFilt.median_1), std(wtNIRFilt.median_1), 'ko', 'color', [161, 0, 0]./255);                                % plot mean/STD for wildtype animals
plot(2, GECO.median_1, 'r.', 'color', [161, 0, 0]./255, 'MarkerFaceColor', [161, 0, 0]./255);                                   % plot individual data points for NIR-GECO2 animals    
errorbar(2, mean(GECO.median_1), std(GECO.median_1), 'ko', 'color', [161, 0, 0]./255, 'MarkerFaceColor', [161, 0, 0]./255);     % plot mean/STD for NIR-GECO2 animals
ylabel('fluorescence [nW/µW]'); xlim([0.5 2.5]); ylim([0 0.004]); set(gca, 'XTick', [1 2], 'XTickLabel', {'WT', 'NIR-GECO2'});  % adjust and label axes

subplot(1, 2, 2); title('bleaching [%/s]'); hold on;                                                                            % initiate second subplot to plot bleaching
plot(1, wtNIRFilt.bleach_1.*100, 'r.', 'color', [161, 0, 0]./255);                                                              % plot individual data points for wildtype animals
errorbar(1, mean(wtNIRFilt.bleach_1.*100), std(wtNIRFilt.bleach_1.*100), 'ko', 'color', [161, 0, 0]./255);                      % plot mean/STD for wildtype animals
plot(2, GECO.bleach_1.*100, 'r.', 'color', [161, 0, 0]./255, 'MarkerFaceColor', [161, 0, 0]./255);                              % plot individual data points for NIR-GECO2 animals 
errorbar(2, mean(GECO.bleach_1.*100), std(GECO.bleach_1.*100), 'ko', 'color', [161, 0, 0]./255, 'MarkerFaceColor', [161, 0, 0]./255);     % plot mean/STD for NIR-GECO2 animals
ylabel('bleaching [%/s]'); xlim([0.5 2.5]); ylim([0 0.02]); set(gca, 'XTick', [1 2], 'XTickLabel', {'WT', 'NIR-GECO2'});        % adjust and label axes


[h, p] = ttest2(GECO.median_1, wtNIRFilt.median_1,'Vartype','unequal');     % perform two-sample t-test for samples with unequal variance to probe difference between fluorescence in WT and NIR-GECO2 animals
[h, p] = ttest2(GECO.bleach_1, wtNIRFilt.bleach_1,'Vartype','unequal');   	% perform two-sample t-test for samples with unequal variance to probe difference between bleaching in WT and NIR-GECO2 animals
