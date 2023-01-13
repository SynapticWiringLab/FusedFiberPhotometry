%% prepare workspace
clear all; close all; clc;
addpath('G:\Alex\manuscripts\FusedFiberPhotometry_CellMethRep\02_final_submission\code')

%% define and load data files
path = 'G:\Alex\manuscripts\FusedFiberPhotometry_CellMethRep\02_final_submission\data\Figure_3\B'; % data path

FP470 = readmatrix([path '\' '470.csv']);                                       % spectrometer data for 470 nm excitation
FP470_opto585 = readmatrix([path '\' '470_550.csv']);                           % spectrometer data for 470 nm excitation with simultaneous opto-stimulation @ 550 nm


%% generate figure
f0 = figure('color', [1 1 1 ]); hold on;
plot(FP470(:, 1), FP470(:, 2)./max([max((max(FP470(32:end, 2)))) max((max(FP470_opto585(32:end, 2))))]).*100, 'color', [0, 169, 255]./256); 
plot(FP470_opto585(:, 1), FP470_opto585(:, 2)./max([max((max(FP470(32:end, 2)))) max((max(FP470_opto585(32:end, 2))))]).*100, 'color', [255, 207, 0]./256); 
xlabel('wavelength [nm]'); ylabel('transmission [%]')
xlim([400 600]); ylim([0 100]); 

