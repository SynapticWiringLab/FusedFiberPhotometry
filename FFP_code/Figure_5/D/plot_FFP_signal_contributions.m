%% prepare workspace
clear all; close all; clc;
addpath('G:\Alex\manuscripts\FusedFiberPhotometry_CellMethRep\02_final_submission\code')


%% define data and load files (this data is taken from the recordings of system comparison, i.e. Figure 4a (spontaneous) and Figure 4b-f (which, in turn, is the data also underlying Figure 3D-F)
AF_fiber = {        'G:\Alex\manuscripts\FusedFiberPhotometry_CellMethRep\02_final_submission\data\Figure_4\A\25417_AFpre-2022-08-23-164219.ppd';
                    'G:\Alex\manuscripts\FusedFiberPhotometry_CellMethRep\02_final_submission\data\Figure_4\A\25420_AFpre-2022-08-23-154911.ppd';
                    'G:\Alex\manuscripts\FusedFiberPhotometry_CellMethRep\02_final_submission\data\Figure_4\A\25421_AFpre-2022-08-23-161606.ppd';
                    'G:\Alex\manuscripts\FusedFiberPhotometry_CellMethRep\02_final_submission\data\Figure_3\D-F\25417_AF-2022-08-18-110106.ppd';
                    'G:\Alex\manuscripts\FusedFiberPhotometry_CellMethRep\02_final_submission\data\Figure_3\D-F\25420_AF-2022-08-18-112833.ppd';
                    'G:\Alex\manuscripts\FusedFiberPhotometry_CellMethRep\02_final_submission\data\Figure_3\D-F\25421_AF-2022-08-18-120032.ppd';
                    'G:\Alex\manuscripts\FusedFiberPhotometry_CellMethRep\02_final_submission\data\Figure_3\D-F\24517_AF-2022-08-12-145308.ppd';
                    'G:\Alex\manuscripts\FusedFiberPhotometry_CellMethRep\02_final_submission\data\Figure_3\D-F\24520_AF-2022-08-12-151832.ppd';
                    'G:\Alex\manuscripts\FusedFiberPhotometry_CellMethRep\02_final_submission\data\Figure_3\D-F\24521_AF-2022-08-12-155202.ppd'};
                      
excitation_power_AF = [243, 308, 245 275 327 278 190 310 250 ; 404 184 187 207 221 194 135 181 156 ];  % excitation power when recording autofluorescence (in µW)



AF_implants = 'G:\Alex\manuscripts\FusedFiberPhotometry_CellMethRep\02_final_submission\data\Figure_5\D\implants\doric_lowAF-2022-03-25-153030.ppd';

TL_path     = 'G:\Alex\manuscripts\FusedFiberPhotometry_CellMethRep\02_final_submission\data\Figure_5\D\implants\thorlabs\';
doric_path  = 'G:\Alex\manuscripts\FusedFiberPhotometry_CellMethRep\02_final_submission\data\Figure_5\D\implants\doric_implants\';
RWD_path    = 'G:\Alex\manuscripts\FusedFiberPhotometry_CellMethRep\02_final_submission\data\Figure_5\D\implants\RWD_implants\';

excitation_power_implants470 = 800;
excitation_power_implants405  = 1000;


AF_fiber_tissue =   'G:\Alex\manuscripts\FusedFiberPhotometry_CellMethRep\02_final_submission\data\Figure_5\D\tissue\FFC_AF-2021-05-19-095757.ppd';

AF_livebrain = {    'G:\Alex\manuscripts\FusedFiberPhotometry_CellMethRep\02_final_submission\data\Figure_5\D\tissue\FFC_15232c-2021-05-19-102122.ppd';
                    'G:\Alex\manuscripts\FusedFiberPhotometry_CellMethRep\02_final_submission\data\Figure_5\D\tissue\FFC_15436c-2021-05-19-102513.ppd';
                    'G:\Alex\manuscripts\FusedFiberPhotometry_CellMethRep\02_final_submission\data\Figure_5\D\tissue\FFC_15242c-2021-05-19-102648.ppd'};
                
excitation_power_tissue = 100;    % excitation power when recording tissue fluorescence (in µW)               
                
                
GCaMP = {           'G:\Alex\manuscripts\FusedFiberPhotometry_CellMethRep\02_final_submission\data\Figure_4\A\25417_FFC-2022-08-23-164333.ppd';
                    'G:\Alex\manuscripts\FusedFiberPhotometry_CellMethRep\02_final_submission\data\Figure_4\A\25420_FFC-2022-08-23-155023.ppd';
                    'G:\Alex\manuscripts\FusedFiberPhotometry_CellMethRep\02_final_submission\data\Figure_4\A\25421_FFC-2022-08-23-161754.ppd';            
                    'G:\Alex\manuscripts\FusedFiberPhotometry_CellMethRep\02_final_submission\data\Figure_3\D-F\25417_FFC-2022-08-18-103713.ppd';
                    'G:\Alex\manuscripts\FusedFiberPhotometry_CellMethRep\02_final_submission\data\Figure_3\D-F\25420_FFC-2022-08-18-110558.ppd';
                    'G:\Alex\manuscripts\FusedFiberPhotometry_CellMethRep\02_final_submission\data\Figure_3\D-F\25421_FFC-2022-08-18-113249.ppd';
                    'G:\Alex\manuscripts\FusedFiberPhotometry_CellMethRep\02_final_submission\data\Figure_3\D-F\24517_FFC-2022-08-12-142846.ppd';
                    'G:\Alex\manuscripts\FusedFiberPhotometry_CellMethRep\02_final_submission\data\Figure_3\D-F\24520_FFC-2022-08-12-145452.ppd';
                    'G:\Alex\manuscripts\FusedFiberPhotometry_CellMethRep\02_final_submission\data\Figure_3\D-F\24521_FFC-2022-08-12-152109.ppd';};

AF_GCaMP = {        'G:\Alex\manuscripts\FusedFiberPhotometry_CellMethRep\02_final_submission\data\Figure_4\A\25417_AFpre-2022-08-23-164219.ppd';
                    'G:\Alex\manuscripts\FusedFiberPhotometry_CellMethRep\02_final_submission\data\Figure_4\A\25420_AFpre-2022-08-23-154911.ppd';
                    'G:\Alex\manuscripts\FusedFiberPhotometry_CellMethRep\02_final_submission\data\Figure_4\A\25421_AFpre-2022-08-23-161606.ppd';
                    'G:\Alex\manuscripts\FusedFiberPhotometry_CellMethRep\02_final_submission\data\Figure_3\D-F\25417_AF-2022-08-18-110106.ppd';
                    'G:\Alex\manuscripts\FusedFiberPhotometry_CellMethRep\02_final_submission\data\Figure_3\D-F\25420_AF-2022-08-18-112833.ppd';
                    'G:\Alex\manuscripts\FusedFiberPhotometry_CellMethRep\02_final_submission\data\Figure_3\D-F\25421_AF-2022-08-18-120032.ppd';
                    'G:\Alex\manuscripts\FusedFiberPhotometry_CellMethRep\02_final_submission\data\Figure_3\D-F\24517_AF-2022-08-12-145308.ppd';
                    'G:\Alex\manuscripts\FusedFiberPhotometry_CellMethRep\02_final_submission\data\Figure_3\D-F\24520_AF-2022-08-12-151832.ppd';
                    'G:\Alex\manuscripts\FusedFiberPhotometry_CellMethRep\02_final_submission\data\Figure_3\D-F\24521_AF-2022-08-12-155202.ppd'};

excitation_power_GCaMP = [243, 308, 245 275 327 278 190 310 250 ; 404 184 187 207 221 194 135 181 156 ];  % excitation power when recording autofluorescence (in µW)


%% define variables
t_window = 10;                  % time window to take data from (seconds)         
conversion_factor = 0.76;       % at 550nm; factor to convert V in (given by doric lenses)




%% caculate fiber fluorescence of the system

for fileIdx = 1:length(AF_fiber)                    % for each file recording fiber autofluorescence...
    data = import_ppd([AF_fiber{fileIdx}]);         % ...load the data...
    AF_fiber_470(fileIdx) = median(data.analog_1(1: data.sampling_rate*t_window))./conversion_factor./excitation_power_AF(1, fileIdx);                       %... calculate the mean signal when excited at 470 nm...
    AF_fiber_405(fileIdx) = median(data.analog_2(1: data.sampling_rate*t_window))./conversion_factor./excitation_power_AF(2, fileIdx);                       %... and when excited at 405 nm
end


%% caculate fiber fluorescence of different implants

data = import_ppd(AF_implants);     
AF470_implants = median(data.analog_1(1: data.sampling_rate*t_window))./conversion_factor./excitation_power_implants470; 
AF405_implants = median(data.analog_2(1: data.sampling_rate*t_window))./conversion_factor./excitation_power_implants405; 

TL_files = dir(fullfile(TL_path,'*.ppd'));
for i_TL = 1:size(TL_files, 1)
    data =  import_ppd([TL_path '\' TL_files(i_TL).name]);
    AFTL(1, i_TL) = median(data.analog_1(1:data.sampling_rate*t_window))./conversion_factor./excitation_power_implants470-AF470_implants;
    AFTL(2, i_TL) = median(data.analog_2(1:data.sampling_rate*t_window))./conversion_factor./excitation_power_implants405-AF405_implants;
end

doric_files = dir(fullfile(doric_path,'*.ppd'));
for i_doric = 1:size(doric_files, 1)
    data =  import_ppd([doric_path '\' doric_files(i_doric).name]);
    AFdoric(1, i_doric) = median(data.analog_1(1:data.sampling_rate*t_window))./conversion_factor./excitation_power_implants470-AF470_implants;
    AFdoric(2, i_doric) = median(data.analog_2(1:data.sampling_rate*t_window))./conversion_factor./excitation_power_implants405-AF405_implants;
end

RWD_files = dir(fullfile(RWD_path,'*.ppd'));
for i_RWD = 1:size(RWD_files, 1)
    data =  import_ppd([RWD_path '\' RWD_files(i_RWD).name]);
    AFRWD(1, i_RWD) = median(data.analog_1(1:data.sampling_rate*t_window))./conversion_factor./excitation_power_implants470-AF470_implants;
    AFRWD(2, i_RWD) = median(data.analog_2(1:data.sampling_rate*t_window))./conversion_factor./excitation_power_implants405-AF405_implants;
end



%% caculate fluorescence of tissue (fixed and alive)

data = import_ppd([AF_fiber_tissue]);
AF_fiber_tissue_470 =  median(data.analog_1(1: data.sampling_rate*t_window))./conversion_factor./excitation_power_tissue; 
AF_fiber_tissue_405 = median(data.analog_2(1: data.sampling_rate*t_window))./conversion_factor./excitation_power_tissue;  


for fileIdx = 1:length(AF_livebrain)                % for each file recording tissue autofluorescence in a living brain...
    data = import_ppd([AF_livebrain{fileIdx}]);     % ...load the data...
    AF_livebrain_470(fileIdx) = median(data.analog_1(1: data.sampling_rate*t_window))./conversion_factor./excitation_power_tissue-AF_fiber_tissue_470;      %... calculate the mean signal when excited at 470 nm...
    AF_livebrain_405(fileIdx) = median(data.analog_2(1: data.sampling_rate*t_window))./conversion_factor./excitation_power_tissue-AF_fiber_tissue_405;      %... and when excited at 405 nm
end



%% caculate flurescence of GCaMP

for fileIdx = 1:length(GCaMP)             % for each file recording GCaMP...
   
    data = import_ppd([AF_GCaMP{fileIdx}]);
    cur_AF_470 =  median(data.analog_1(1: data.sampling_rate*t_window))./excitation_power_GCaMP(1, fileIdx); 
    cur_AF_405 = median(data.analog_2(1: data.sampling_rate*t_window))./excitation_power_GCaMP(2, fileIdx);

    data = import_ppd([GCaMP{fileIdx}]);  % ...load the data...
    GcAMP_470 = data.analog_1./conversion_factor./excitation_power_GCaMP(1, fileIdx)-cur_AF_470;      % normalize signal to excitation power and subtract fiber autofluorescence when exciting with 470 nm
    GcAMP_405 = data.analog_2./conversion_factor./excitation_power_GCaMP(2, fileIdx)-cur_AF_405;      % normalize signal to excitation power and subtract fiber autofluorescence when exciting with 405 nm
    
    median470(fileIdx) = median(GcAMP_470);         % calculate the first percentile when exciting with 470 nm
    median405(fileIdx) = median(GcAMP_405);        % calculate the first percentile when exciting with 405 nm

end






%% plot data
f1 = figure('color', [1 1 1]); hold on;     % initiate figure
ax1 = subplot(1, 2, 1); hold on;            % initiate first subplot for excitation with 405 nm
bar(1, mean(AF_fiber_405),'w');             % bar plot of fiber autofluorescence                
bar(2, mean(AFTL(2, :)),'w');               % bar plot of fiber autofluorescence                
bar(3, mean(AFdoric(2, :)),'w');           	% bar plot of fiber autofluorescence                
bar(4, mean(AFRWD(2, :)),'w');              % bar plot of fiber autofluorescence                
bar(5, mean(AF_livebrain_405),'w');         % bar plot tissue autofluorescence (in vivo)
bar(6, mean(median405),'w');             	% bar plot of indicator fluorescence (presumably baseline)


plot(0.8:0.4/(length(AF_fiber_405)-1):1.2, AF_fiber_405, 'ko', 'Color', [130 0 200]./255, 'MarkerFaceColor', [130 0 200]./255);   % plot individual data points of tissue autofluorescence (fixed)
errorbar(1, mean(AF_fiber_405), std(AF_fiber_405), 'color', [130 0 200]./255, 'LineWidth', 2);                                    % plot mean/SD of tissue autofluorescence (fixed) 
plot(1.8:0.4/(length(AFTL(2, :))-1):2.2, AFTL(2, :), 'ko', 'Color', [130 0 200]./255, 'MarkerFaceColor', [130 0 200]./255);   % plot individual data points of tissue autofluorescence (fixed)
errorbar(2, mean(AFTL(2, :)), std(AFTL(2, :)), 'color', [130 0 200]./255, 'LineWidth', 2);                                    % plot mean/SD of tissue autofluorescence (fixed) 
plot(2.8:0.4/(length(AFdoric(2, :))-1):3.2, AFdoric(2, :), 'ko', 'Color', [130 0 200]./255, 'MarkerFaceColor', [130 0 200]./255);   % plot individual data points of tissue autofluorescence (fixed)
errorbar(3, mean(AFdoric(2, :)), std(AFdoric(2, :)), 'color', [130 0 200]./255, 'LineWidth', 2);                                    % plot mean/SD of tissue autofluorescence (fixed) 
plot(3.8:0.4/(length(AFRWD(2, :))-1):4.2, AFRWD(2, :), 'ko', 'Color', [130 0 200]./255, 'MarkerFaceColor', [130 0 200]./255);   % plot individual data points of tissue autofluorescence (fixed)
errorbar(4, mean(AFRWD(2, :)), std(AFRWD(2, :)), 'color', [130 0 200]./255, 'LineWidth', 2);                                    % plot mean/SD of tissue autofluorescence (fixed) 
plot(4.8:0.4/(length(AF_livebrain_405)-1):5.2, AF_livebrain_405, 'ko', 'Color', [130 0 200]./255, 'MarkerFaceColor', [130 0 200]./255);     % plot individual data points of tissue autofluorescence (in vivo)
errorbar(5, mean(AF_livebrain_405), std(AF_livebrain_405), 'color', [130 0 200]./255, 'LineWidth', 2);                                      % plot mean/SD of tissue autofluorescence (in vivo)
plot(5.8:0.4/(length(median405)-1):6.2, median405, 'ko', 'Color', [130 0 200]./255, 'MarkerFaceColor', [130 0 200]./255);                     % plot individual data points of indicator fluorescence (baseline)
errorbar(6, mean(median405), std(median405), 'color', [130 0 200]./255, 'LineWidth', 2);                                                      % plot mean/SD of indicator fluorescence (baseline)
box on; axis square; xlim([0 7]); ylabel('fluorescence [nW]'); set(gca, 'XTick', 1:7, 'XTickLabel', {'fiber', 'TL', 'doric', 'RWD', 'brain', 'indicator'});   % adjust plot appearance
ylim([0 0.015])


ax2 = subplot(1, 2, 2); hold on;            % initiate second subplot for excitation with 470 nm
bar(1, mean(AF_fiber_470),'w');             % bar plot of fiber autofluorescence     
bar(2, mean(AFTL(1, :)),'w');               % bar plot of fiber autofluorescence                
bar(3, mean(AFdoric(1, :)),'w');           	% bar plot of fiber autofluorescence                
bar(4, mean(AFRWD(1, :)),'w');              % bar plot of fiber autofluorescence   
bar(5, mean(AF_livebrain_470),'w');         % bar plot tissue autofluorescence (in vivo)
bar(6, mean(median470),'w');                % bar plot of indicator fluorescence (presumably baseline)

plot(0.8:0.4/(length(AF_fiber_470)-1):1.2, AF_fiber_470, 'ko', 'Color', [0 0 200]./255, 'MarkerFaceColor', [0 0 200]./255);   % plot individual data points of tissue autofluorescence (fixed)
errorbar(1, mean(AF_fiber_470), std(AF_fiber_470), 'color', [0 0 200]./255, 'LineWidth', 2);                                    % plot mean/SD of tissue autofluorescence (fixed) 
plot(1.8:0.4/(length(AFTL(1, :))-1):2.2, AFTL(1, :), 'ko', 'Color', [0 0 200]./255, 'MarkerFaceColor', [0 0 200]./255);   % plot individual data points of tissue autofluorescence (fixed)
errorbar(2, mean(AFTL(1, :)), std(AFTL(1, :)), 'color', [0 0 200]./255, 'LineWidth', 2);                                    % plot mean/SD of tissue autofluorescence (fixed) 
plot(2.8:0.4/(length(AFdoric(1, :))-1):3.2, AFdoric(1, :), 'ko', 'Color', [0 0 200]./255, 'MarkerFaceColor', [0 0 200]./255);   % plot individual data points of tissue autofluorescence (fixed)
errorbar(3, mean(AFdoric(1, :)), std(AFdoric(1, :)), 'color', [0 0 200]./255, 'LineWidth', 2);                                    % plot mean/SD of tissue autofluorescence (fixed) 
plot(3.8:0.4/(length(AFRWD(1, :))-1):4.2, AFRWD(1, :), 'ko', 'Color', [0 0 200]./255, 'MarkerFaceColor', [0 0 200]./255);   % plot individual data points of tissue autofluorescence (fixed)
errorbar(4, mean(AFRWD(1, :)), std(AFRWD(1, :)), 'color', [0 0 200]./255, 'LineWidth', 2);                                    % plot mean/SD of tissue autofluorescence (fixed) 
plot(4.8:0.4/(length(AF_livebrain_470)-1):5.2, AF_livebrain_470, 'ko', 'Color', [0 0 200]./255, 'MarkerFaceColor', [0 0 200]./255);     % plot individual data points of tissue autofluorescence (in vivo)
errorbar(5, mean(AF_livebrain_470), std(AF_livebrain_470), 'color', [0 0 200]./255, 'LineWidth', 2);                                      % plot mean/SD of tissue autofluorescence (in vivo)
plot(5.8:0.4/(length(median470)-1):6.2, median470, 'ko', 'Color', [0 0 200]./255, 'MarkerFaceColor', [0 0 200]./255);                     % plot individual data points of indicator fluorescence (baseline)
errorbar(6, mean(median470), std(median470), 'color', [0 0 200]./255, 'LineWidth', 2);                                                      % plot mean/SD of indicator fluorescence (baseline)
box on; axis square; xlim([0 7]); ylabel('fluorescence [nW]'); set(gca, 'XTick', 1:6, 'XTickLabel', {'fiber', 'TL', 'doric', 'RWD', 'brain', 'indicator'});   % adjust plot appearance
ylim([0 0.015])

