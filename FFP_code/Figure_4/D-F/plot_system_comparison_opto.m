%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% A flexible and versatile system for multi-color fiber photometry and optogenetic manipulation
% Andrey Formozov, Alexander Dieter, J. Simon Wiegert
% code: Dieter, A, 2022 
% reviewed: Formozov, A, 2023
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all; close all; clc;


%% put in data (from metadata file)
FFC_470 = [ 0.416	 0.192	 0.167];
FFC_405 = [-0.091	-0.044	-0.046];

doric_470 = [0.453	 0.220	 0.180];
doric_405 = [-0.104	-0.048	-0.048];

% create figure
f1 = figure('color', [1 1 1]); 

subplot(1, 3, 1); hold on;
plot([0.8:0.4./(length(FFC_470)-1):1.2], FFC_470, 'bo', 'color', [51, 133, 255]./255)
plot([1.8:0.4./(length(doric_470)-1):2.2], doric_470, 'ko')
for idx = 1:length(doric_470)
    plot([1 2], [FFC_470(idx) doric_470(idx) ], 'k-', 'color', [0.8, 0.8, 0.8])
end
errorbar(1, mean(FFC_470), std(FFC_470), 'bo', 'LineWidth', 2, 'color', [51, 133, 255]./255)
errorbar(2, mean(doric_470), std(doric_470), 'ko', 'LineWidth', 2)
xlim([0.5 2.5]); ylim([0 0.5]); set(gca, 'XTick', [1, 2], 'XTickLabel', {'FFC', 'CPS'})
ylabel('signal relative to stimulus onset (V)')

subplot(1, 3, 2); hold on;
plot([0.8:0.4./(length(FFC_405)-1):1.2], -FFC_405, 'bo', 'color', [115, 0, 230]./255)
plot([1.8:0.4./(length(doric_405)-1):2.2], -doric_405, 'ko')
for idx = 1:length(doric_405)
    plot([1 2], [-FFC_405(idx) -doric_405(idx) ], 'k-', 'color', [0.8, 0.8, 0.8])
end
errorbar(1, mean(-FFC_405), std(-FFC_405), 'bo', 'LineWidth', 2, 'color', [115, 0, 230]./255)
errorbar(2, mean(-doric_405), std(-doric_405), 'ko', 'LineWidth', 2)
xlim([0.5 2.5]); ylim([0 0.12]); set(gca, 'XTick', [1, 2], 'XTickLabel', {'FFC', 'CPS'})
ylabel('signal relative to stimulus onset (-V)')


subplot(1, 3, 3); hold on;

plot([0.8:0.4./(length(doric_470)-1):1.2], FFC_470./doric_470, 'ko', 'color', [51, 133, 255]./255); 
errorbar(1, mean(FFC_470./doric_470), std(FFC_470./doric_470), 'ko-', 'LineWidth', 2, 'color', [51, 133, 255]./255)

plot([1.8:0.4./(length(doric_405)-1):2.2], FFC_405./doric_405, 'ko', 'color', [115, 0, 230]./255); 
errorbar(2, mean(FFC_405./doric_405), std(FFC_405./doric_405), 'ko-', 'LineWidth', 2, 'color', [115, 0, 230]./255)

plot([0.3 2.7], [1 1], 'k--')
xlim([0.3 2.7]); ylim([0 1])
set(gca, 'XTick', [1, 2], 'XTickLabel', {'FFC', 'doric'});
ylabel('FFC/CPS')

