clear all; clc; close all; 

data_files = {   'G:\Alex\manuscripts\FusedFiberPhotometry_CellMethRep\02_final_submission\data\Figure_5\B_C\coup_1_3-2022-04-21-154651.ppd';     
                    'G:\Alex\manuscripts\FusedFiberPhotometry_CellMethRep\02_final_submission\data\Figure_5\B_C\coup_2_6-2022-04-21-154628.ppd'; 
                    'G:\Alex\manuscripts\FusedFiberPhotometry_CellMethRep\02_final_submission\data\Figure_5\B_C\coup_3_9-2022-04-21-154607.ppd'; 
                    'G:\Alex\manuscripts\FusedFiberPhotometry_CellMethRep\02_final_submission\data\Figure_5\B_C\coup_4_12-2022-04-21-154539.ppd'; 
                 	'G:\Alex\manuscripts\FusedFiberPhotometry_CellMethRep\02_final_submission\data\Figure_5\B_C\coup_5_15-2022-04-21-154519.ppd'; 
                    'G:\Alex\manuscripts\FusedFiberPhotometry_CellMethRep\02_final_submission\data\Figure_5\B_C\coup_6_18-2022-04-21-154439.ppd'; 
                    'G:\Alex\manuscripts\FusedFiberPhotometry_CellMethRep\02_final_submission\data\Figure_5\B_C\coup_7_21-2022-04-21-154418.ppd'; 
                	'G:\Alex\manuscripts\FusedFiberPhotometry_CellMethRep\02_final_submission\data\Figure_5\B_C\coup_8_24-2022-04-21-154359.ppd'; 
                    'G:\Alex\manuscripts\FusedFiberPhotometry_CellMethRep\02_final_submission\data\Figure_5\B_C\coup_9_27-2022-04-21-154334.ppd';
                    'G:\Alex\manuscripts\FusedFiberPhotometry_CellMethRep\02_final_submission\data\Figure_5\B_C\coup_10_30-2022-04-21-154308.ppd';  
                    
                    'G:\Alex\manuscripts\FusedFiberPhotometry_CellMethRep\02_final_submission\data\Figure_5\B_C\coup_1_1-2022-04-21-160347.ppd';     
                    'G:\Alex\manuscripts\FusedFiberPhotometry_CellMethRep\02_final_submission\data\Figure_5\B_C\coup_2_2-2022-04-21-160330.ppd'; 
                    'G:\Alex\manuscripts\FusedFiberPhotometry_CellMethRep\02_final_submission\data\Figure_5\B_C\coup_3_3-2022-04-21-160311.ppd'; 
                    'G:\Alex\manuscripts\FusedFiberPhotometry_CellMethRep\02_final_submission\data\Figure_5\B_C\coup_4_4-2022-04-21-160249.ppd'; 
                 	'G:\Alex\manuscripts\FusedFiberPhotometry_CellMethRep\02_final_submission\data\Figure_5\B_C\coup_5_5-2022-04-21-160229.ppd'; 
                    'G:\Alex\manuscripts\FusedFiberPhotometry_CellMethRep\02_final_submission\data\Figure_5\B_C\coup_6_6-2022-04-21-160208.ppd'; 
                    'G:\Alex\manuscripts\FusedFiberPhotometry_CellMethRep\02_final_submission\data\Figure_5\B_C\coup_7_7-2022-04-21-160149.ppd'; 
                	'G:\Alex\manuscripts\FusedFiberPhotometry_CellMethRep\02_final_submission\data\Figure_5\B_C\coup_8_8-2022-04-21-160128.ppd'; 
                    'G:\Alex\manuscripts\FusedFiberPhotometry_CellMethRep\02_final_submission\data\Figure_5\B_C\coup_9_9-2022-04-21-160106.ppd';
                    'G:\Alex\manuscripts\FusedFiberPhotometry_CellMethRep\02_final_submission\data\Figure_5\B_C\coup_10_10-2022-04-21-160043.ppd'};
         
            

t_window = 10;


for idx_file = 1:size(data_files, 1)
    
    cur_data = import_ppd(data_files{idx_file});
    
    cur_470 = cur_data.analog_1(1:t_window.*cur_data.sampling_rate)';
    cur_405 = cur_data.analog_2(1:t_window.*cur_data.sampling_rate)';
         
    
    coupler.mean_470(idx_file)	= mean(cur_470);
    coupler.noise_470(idx_file)	= std(cur_470);
    coupler.mean_405(idx_file)	= mean(cur_405);
    coupler.noise_405(idx_file)	= std(cur_405);  
end





figure('color', [1 1 1]);
ax1 = subplot(1, 2, 1);  title('signal vs noise'); hold on;
plot(coupler.mean_470, coupler.noise_470, 'bo'); axis square
plot(coupler.mean_405, coupler.noise_405, 'co'); axis square
lsline; 
xlabel('fiber fluorescence'); ylabel('STD fiber fluorescence')


coefficients470 = polyfit(coupler.mean_470, coupler.noise_470, 1);
coefficients405 = polyfit(coupler.mean_405, coupler.noise_405, 1);


ax2 = subplot(1, 2, 2); title('signal/noise'); hold on;
plot(coupler.mean_470, coupler.mean_470./coupler.noise_470, 'bo'); axis square
plot(coupler.mean_405, coupler.mean_405./coupler.noise_405, 'co'); axis square
xlabel('fiber fluorescence'); ylabel('fiber fluorescence/STD fiber fluorescence')
