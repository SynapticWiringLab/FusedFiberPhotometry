
clear all; %close all; clc;

R_non_modif = 4.7
R_0R47 = 0.47*4.7/(0.47+4.7) % overall resistance when extra 0.47 resistor is added 

trace_no_modif = "G:\Alex\manuscripts\FusedFiberPhotometry_CellMethRep\02_final_submission\data\Figure_S5\oscilloscope\no_modifications_setting100mA_01.csv"
trace_0R47 = "G:\Alex\manuscripts\FusedFiberPhotometry_CellMethRep\02_final_submission\data\Figure_S5\oscilloscope\0R47_setting100mA_10.csv"
trace_0R47_6800uF = "G:\Alex\manuscripts\FusedFiberPhotometry_CellMethRep\02_final_submission\data\Figure_S5\oscilloscope\0R47_6800uF_setting100mA_01.csv"
 
data_trace_no_modif = readtable(trace_no_modif)
data_trace_0R47 = readtable(trace_0R47)
data_trace_0R47_6800uF = readtable(trace_0R47_6800uF)

data_trace_no_modif.current=1000*data_trace_no_modif.ChannelA/R_non_modif
data_trace_0R47.current= data_trace_0R47.ChannelA/R_0R47 %% x 0.001 V to mV convert
data_trace_0R47_6800uF.current=1000*data_trace_0R47_6800uF.ChannelA/R_0R47

figure('color', [1 1 1]);

    subplot(1, 3, 1);  title({'Current, 470 nm channel, ','Modifications: pyboard diode removed'}); hold on;
    alpha(.1);
    plot(data_trace_no_modif.Time,  data_trace_no_modif.current, 'k-')
    plot(data_trace_no_modif.Time ,  data_trace_0R47.current, 'b-')
    plot(data_trace_no_modif.Time ,  data_trace_0R47_6800uF.current, 'g-')
    plot([-4,6],[1200,1200],'k--');
    xlabel('Time, [ms]');
    ylabel('Current measured, mA');
    ylim([-50, 1400])
    xlim([-4, 6])
    legend('pyPhotometry (no modifications)', 'pyPhotometry(0R47)','pyPhotometry(0R47+6800uF)', 'thorlabs (max)');
    hold off;

pyPhotometry_modifications = "G:\Alex\manuscripts\FusedFiberPhotometry_CellMethRep\02_final_submission\data\Figure_S5\oscilloscope\data_comparison.csv"

data = readtable(pyPhotometry_modifications)

data.no_modif_mA_=data.no_modif_mV_/R_non_modif
data.x0R47_mA_= data.x0R47_mV_/R_0R47 
data.x0R47And6800uF_mA_=data.x0R47And6800uF_mV_/R_0R47

    subplot(1, 3, 2);  title({'Current, 470 nm channel, ','Modifications: pyboard diode removed'}); hold on;
    alpha(.1);
    plot(data.currentSetting_mA_ ,  data.no_modif_mA_, 'ko-')
    plot(data.currentSetting_mA_ ,  data.x0R47_mA_, 'bo-')
    plot(data.currentSetting_mA_ ,  data.x0R47And6800uF_mA_, 'go-')
    plot([0,100],[1200,1200],'k--');
    xlabel('Current setting, mA');
    ylabel('Current measured, mA');
    ylim([0.0 1400])
    legend('pyPhotometry (no modifications)', 'pyPhotometry(0R47)','pyPhotometry(0R47+6800uF)', 'thorlabs (max)');
    hold off;
    
   
%% load fiber autofluorescence as a reference signal, noise measurements 

FFC_thorlabs = {'G:\Alex\manuscripts\FusedFiberPhotometry_CellMethRep\02_final_submission\data\Figure_S5\final_throlabs_AF\AF_1-2022-10-20-160202.ppd';
      'G:\Alex\manuscripts\FusedFiberPhotometry_CellMethRep\02_final_submission\data\Figure_S5\final_throlabs_AF\AF_2-2022-10-20-160243.ppd';
      'G:\Alex\manuscripts\FusedFiberPhotometry_CellMethRep\02_final_submission\data\Figure_S5\final_throlabs_AF\AF_3-2022-10-20-160308.ppd';
      'G:\Alex\manuscripts\FusedFiberPhotometry_CellMethRep\02_final_submission\data\Figure_S5\final_throlabs_AF\AF_4-2022-10-20-160331.ppd';
      'G:\Alex\manuscripts\FusedFiberPhotometry_CellMethRep\02_final_submission\data\Figure_S5\final_throlabs_AF\AF_5-2022-10-20-160358.ppd';
      'G:\Alex\manuscripts\FusedFiberPhotometry_CellMethRep\02_final_submission\data\Figure_S5\final_throlabs_AF\AF_7-2022-10-20-160450.ppd';
      'G:\Alex\manuscripts\FusedFiberPhotometry_CellMethRep\02_final_submission\data\Figure_S5\final_throlabs_AF\AF_8-2022-10-20-160514.ppd';
      'G:\Alex\manuscripts\FusedFiberPhotometry_CellMethRep\02_final_submission\data\Figure_S5\final_throlabs_AF\AF_9-2022-10-20-160542.ppd';
      'G:\Alex\manuscripts\FusedFiberPhotometry_CellMethRep\02_final_submission\data\Figure_S5\final_throlabs_AF\AF_10-2022-10-20-160608.ppd';
        };
     
 FFC_pyboard_0R47_6800uF = {'G:\Alex\manuscripts\FusedFiberPhotometry_CellMethRep\02_final_submission\data\Figure_S5\final_0R47_6800uF_resolution\AF_10-2022-10-20-144519.ppd';
        'G:\Alex\manuscripts\FusedFiberPhotometry_CellMethRep\02_final_submission\data\Figure_S5\final_0R47_6800uF_resolution\AF_20-2022-10-20-144542.ppd';
        'G:\Alex\manuscripts\FusedFiberPhotometry_CellMethRep\02_final_submission\data\Figure_S5\final_0R47_6800uF_resolution\AF_30-2022-10-20-144612.ppd';
        'G:\Alex\manuscripts\FusedFiberPhotometry_CellMethRep\02_final_submission\data\Figure_S5\final_0R47_6800uF_resolution\AF_40-2022-10-20-144634.ppd';
        'G:\Alex\manuscripts\FusedFiberPhotometry_CellMethRep\02_final_submission\data\Figure_S5\final_0R47_6800uF_resolution\AF_50-2022-10-20-144658.ppd';
        'G:\Alex\manuscripts\FusedFiberPhotometry_CellMethRep\02_final_submission\data\Figure_S5\final_0R47_6800uF_resolution\AF_60-2022-10-20-144723.ppd';
        'G:\Alex\manuscripts\FusedFiberPhotometry_CellMethRep\02_final_submission\data\Figure_S5\final_0R47_6800uF_resolution\AF_70-2022-10-20-144748.ppd';
        'G:\Alex\manuscripts\FusedFiberPhotometry_CellMethRep\02_final_submission\data\Figure_S5\final_0R47_6800uF_resolution\AF_80-2022-10-20-144812.ppd';
        'G:\Alex\manuscripts\FusedFiberPhotometry_CellMethRep\02_final_submission\data\Figure_S5\final_0R47_6800uF_resolution\AF_90-2022-10-20-144838.ppd';
        'G:\Alex\manuscripts\FusedFiberPhotometry_CellMethRep\02_final_submission\data\Figure_S5\final_0R47_6800uF_resolution\AF_100-2022-10-20-144900.ppd';
         };
     

conversion_factor = 0.76; %0.76V/nW (at 550nm)
excitation_power = 50; % in µW
recording_duration = 0.15; % in minutes
frequencies = logspace(log10(0.1),log10(65),5000) ;
pwelchwindow = 30;
fitorder = 12; 

for fileIdx = 1:length(FFC_thorlabs) 
     data = import_ppd([FFC_thorlabs{fileIdx}]);
    [p_d1] = polyfit([1:length(data.analog_2)],transpose(data.analog_2),fitorder);                           % perform polynomial fit of 470 nm excited trace
    y_d1 = polyval(p_d1,[1:length(data.analog_2)]);                                            % create fitted curve for 470 nm excited trace
    data.analog_2_c = transpose(data.analog_2)-y_d1; 
     
    FFC_thorlabs_mean470(fileIdx) = mean(data.analog_2);   
    %FFC_thorlabs_mean405(fileIdx) = mean(data.analog_1); % inverted in the
    FFC_thorlabs_std470(fileIdx) = std(data.analog_2_c);   
    %FFC_thorlabs_std405(fileIdx) = std(data.analog_1); 
end

for fileIdx = 1:length(FFC_pyboard_0R47_6800uF) 

    data = import_ppd([FFC_pyboard_0R47_6800uF{fileIdx}]);
    [p_d1] = polyfit([1:length(data.analog_1)],transpose(data.analog_1),fitorder);                           % perform polynomial fit of 470 nm excited trace
    y_d1 = polyval(p_d1,[1:length(data.analog_1)]);                                            % create fitted curve for 470 nm excited trace
    data.analog_1_c = transpose(data.analog_1)-y_d1;                                                        % divide 470 nm excited trace by polynomial fit to correct for bleaching
    FFC_pyboard_0R47_mean470(fileIdx) = mean(data.analog_1);   
    FFC_pyboard_0R47_std470(fileIdx) = std(data.analog_1_c); 
end
    
    subplot(1, 3, 3);  title({'Standard deviation vs mean', 'Modifications: 0R47, extra C6800uF,', ' pyboard diode removed'}); hold on;
    alpha(.5)
    plot( FFC_pyboard_0R47_mean470, FFC_pyboard_0R47_std470, 'mo')
    lsline;
    plot(FFC_thorlabs_mean470,  FFC_thorlabs_std470, 'k.')
    lsline;
    xlabel('Reference signal (autofluor.), V');
    ylabel('Reference signal standard deviation, V');
    hold off;
    
