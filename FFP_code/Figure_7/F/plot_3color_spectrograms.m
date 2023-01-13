%% prepare workspace
clear all; close all; clc;
addpath('G:\Alex\manuscripts\FusedFiberPhotometry_CellMethRep\02_final_submission\code')

%% read in data files

path = 'G:\Alex\manuscripts\FusedFiberPhotometry_CellMethRep\02_final_submission\data\Figure_7\F';

ex490 = readmatrix([path '\' '490ex.csv']);                 % spectrogram of excited alexa488
ex490black = readmatrix([path '\' '490ex_black.csv']);      % spectrogram of autofluorescence when exciting at 490 nm
alexa488 = readmatrix([path '\' 'Alexa488.txt']);           % spectral properties of alexa488 (from FPbase)

ex550 = readmatrix([path '\' '550ex.csv']);               	% spectrogram of excited alexa546
ex550black = readmatrix([path '\' '550ex_black.csv']);     	% spectrogram of autofluorescence when exciting at 550 nm
alexa546 = readmatrix([path '\' 'Alexa546.txt']);           % spectral properties of alexa546 (from FPbase)

ex650 = readmatrix([path '\' '650ex.csv']);                 % spectrogram of excited alexa647
ex650black = readmatrix([path '\' '650ex_black.csv']);      % spectrogram of autofluorescence when exciting at 650 nm
alexa647 = readmatrix([path '\' 'Alexa647.txt']);           % spectral properties of alexa647 (from FPbase)
    

%% generate figure
figure('color', [1 1 1 ]);  % initiate figure

subplot(3, 1, 1);           % initiate first subplot (alexa488)
plot(ex490(:, 1)./10^9, smooth(ex490(:, 2), 20)./max(smooth(ex490(:, 2)-ex490black(:, 2), 20)), 'color', [0.5 0.5 0.5]); hold on;                   % plot recorded spectrogram of alexa488 (smoothed)
plot(ex490black(:, 1)./10^9, smooth(ex490black(:, 2), 20)./max(smooth(ex490(:, 2)-ex490black(:, 2), 20)), 'k--', 'color', [0.5 0.5 0.5]);           % plot smoothed autofluorescence
plot(ex490(:, 1)./10^9, smooth(ex490(:, 2)-ex490black(:, 2), 20)./max(smooth(ex490(:, 2)-ex490black(:, 2), 20)), 'color', [58, 255, 0]./256);       % plot recorded spectrogram of alexa488 minus autofluorescence (i.e. fluorophore contribution only)
[~, maxloc] = max(smooth(ex490(:, 2)-ex490black(:, 2), 20)./max(smooth(ex490(:, 2)-ex490black(:, 2), 20))); peak490 = ex490(maxloc, 1)./10^9;       % determine the peak of the recorded fluorophore spectrogram
[~, minloc] = min(abs(alexa488(:, 1) - peak490));                                                                                                   % figure out the position of the FPbase spectrogram closest to this peak
plot(alexa488(:, 1), alexa488(:, 2)./alexa488(minloc, 2), 'color', [0.7 0.7 0.7])                                                                   % plot the FP-base spectrogram normalized to this peak, to align the spectrograms on the y-axis
xlim([400 750]); xlabel('wavelength [nm]'); ylabel('fluorescence [norm]')                                                                           % ajust figure properties

subplot(3, 1, 2);           % initiate second subplot (alexa546)
plot(ex550(:, 1)./10^9, smooth(ex550(:, 2), 20)./max(smooth(ex550(:, 2)-ex550black(:, 2), 20)), 'color', [0.5 0.5 0.5]); hold on;                   % plot recorded spectrogram of alexa546 (smoothed)
plot(ex550black(:, 1)./10^9, smooth(ex550black(:, 2), 20)./max(smooth(ex550(:, 2)-ex550black(:, 2), 20)), 'k--', 'color', [0.5 0.5 0.5]);           % plot smoothed autofluorescence
plot(ex550(:, 1)./10^9, smooth(ex550(:, 2)-ex550black(:, 2), 20)./max(smooth(ex550(:, 2)-ex550black(:, 2), 20)), 'color', [255, 166, 0]./256);      % plot recorded spectrogram of alexa546 minus autofluorescence (i.e. fluorophore contribution only)
[~, maxloc] = max(smooth(ex550(:, 2)-ex550black(:, 2), 20)./max(smooth(ex550(:, 2)-ex550black(:, 2), 20))); peak550 = ex550(maxloc, 1)./10^9;       % determine the peak of the recorded fluorophore spectrogram
[~, minloc] = min(abs(alexa546(:, 1) - peak550));                                                                                                   % figure out the position of the FPbase spectrogram closest to this peak
plot(alexa546(:, 1), alexa546(:, 2)./alexa546(minloc, 2), 'color', [0.7 0.7 0.7])                                                                   % plot the FP-base spectrogram normalized to this peak, to align the spectrograms on the y-axis
xlim([400 750]); xlabel('wavelength [nm]'); ylabel('fluorescence [norm]')                                                                           % ajust figure properties

subplot(3, 1, 3);           % initiate third subplot (alexa647)
plot(ex650(:, 1)./10^9, smooth(ex650(:, 2), 20)./max(smooth(ex650(:, 2)-ex650black(:, 2), 20)), 'color', [0.5 0.5 0.5]); hold on;                   % plot recorded spectrogram of alexa647 (smoothed)
plot(ex650black(:, 1)./10^9, smooth(ex650black(:, 2), 20)./max(smooth(ex650(:, 2)-ex650black(:, 2), 20)), 'k--', 'color', [0.5 0.5 0.5]);           % plot smoothed autofluorescence
plot(ex650(:, 1)./10^9, smooth(ex650(:, 2)-ex650black(:, 2), 20)./max(smooth(ex650(:, 2)-ex650black(:, 2), 20)), 'color', [255, 0, 0]./256);        % plot recorded spectrogram of alexa647 minus autofluorescence (i.e. fluorophore contribution only)
[~, maxloc] = max(smooth(ex650(:, 2)-ex650black(:, 2), 20)./max(smooth(ex650(:, 2)-ex650black(:, 2), 20))); peak650 = ex650(maxloc, 1)./10^9;       % determine the peak of the recorded fluorophore spectrogram
[~, minloc] = min(abs(alexa647(:, 1) - peak650));                                                                                                   % figure out the position of the FPbase spectrogram closest to this peak
plot(alexa647(:, 1), alexa647(:, 2)./alexa647(minloc, 2), 'color', [0.7 0.7 0.7])                                                                   % plot the FP-base spectrogram normalized to this peak, to align the spectrograms on the y-axis
xlim([400 750]); xlabel('wavelength [nm]'); ylabel('fluorescence [norm]')                                                                           % ajust figure properties

