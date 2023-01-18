%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% A flexible and versatile system for multi-color fiber photometry and optogenetic manipulation
% Andrey Formozov, Alexander Dieter, J. Simon Wiegert
% code: Dieter, A, 2022 
% reviewed: Formozov, A, 2023
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all; clc; 

x = 1; 
contributions = [0.77 9.5  2.7 9.5  78.2]; % data from supplementary table 5

figure('color', [1 1 1])
b = bar(x,contributions,"stacked");
ylim([0 100])
