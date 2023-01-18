%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% A flexible and versatile system for multi-color fiber photometry and optogenetic manipulation
% Andrey Formozov, Alexander Dieter, J. Simon Wiegert
% code: Dieter, A, 2022 
% reviewed: Formozov, A, 2023
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% prepare workspace
clear all; close all; clc;

% add "FFP_code" into path 
filePath = matlab.desktop.editor.getActiveFilename; % file path to the current script
location = regexp(filePath,'FFP_code','split'); % "location of the "FFP_code" folder"
addpath(location{1}+"FFP_code\");
% or add "FFP_code" into path manually by uncommenting and specifying the path:
% addpath('path_to_scripts\FFP_code')

%% define and load data files
path = data_location + '\FFP_data\Figure_3\B\'; % data path

FP470 = readmatrix(path+'\'+'470.csv');                                       % spectrometer data for 470 nm excitation
FP470_opto585 = readmatrix(path+'\'+'470_550.csv');                           % spectrometer data for 470 nm excitation with simultaneous opto-stimulation @ 550 nm

FP470 = FP470(32:end,:)
FP470_opto585 = FP470_opto585(32:end,:) 

%% generate figure
f0 = figure('color', [1 1 1 ]); hold on;
plot(FP470(:, 1), FP470(:, 2)./max(max(FP470_opto585(32:end, 2)),max(FP470(32:end, 2))).*100, 'color', [0, 169, 255]./256); 
plot(FP470_opto585(:, 1), FP470_opto585(:, 2)./max(max(FP470_opto585(32:end, 2)),max(FP470(32:end, 2))).*100, 'color', [255, 207, 0]./256); 
xlabel('wavelength [nm]'); ylabel('transmission [%]')
xlim([400 600]); ylim([0 100]); 

