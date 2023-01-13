clear all; clc; 

x = 1; 
contributions = [0.35 41.3 1.3 4.4  52.5]; % data from supplementary table 5

figure('color', [1 1 1])
b = bar(x,contributions,"stacked");
ylim([0 100])