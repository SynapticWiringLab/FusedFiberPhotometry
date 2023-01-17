%% prepare workspace
clear all; clc;

filePath = matlab.desktop.editor.getActiveFilename; % file path to the current script
location = regexp(filePath,'FFP_code','split'); % "location of the "FFP_code" folder"
addpath(location{1}+"FFP_code\");
% or add "FFP_code" into path manually by uncommenting and specifying the path:
% addpath('path_to_scripts\FFP_code')

%% read in and sort data files
refFile = data_location + '\FFP_data\Figure_S1\B_C\reference_20220818.xlsx';
CoupFile = data_location + '\FFP_data\Figure_S1\B_C\coupler_excitation_20220818.xlsx';

[~, ~, data] = xlsread(refFile);                    % read in reference fiber data
wavelengths = cell2mat(data(1, 2:17));              % extract wavelengths 
ref_power = cell2mat(data(2:11, 2:17))./1000;       % extract transmission data of reference fiber (simple ferrule-to-FC, 400 µm, 0.5 NA), convert to mW
ref_power = ref_power(1:5, :);

[~, ~, data] = xlsread(CoupFile);                   % read in coupler data
coup_power = cell2mat(data(2:11, 2:17))./1000;  	% extract transmission data of coupler, convert to mW
coup_power = coup_power(1:5, :);

%% create figure
plotcol = [ 102     0       102; % define RGB-code for different plot colors (wavelength-dependent)
            111     0       119;
            130     0       200;
            35      0       255;
            0       123     255;
            0       169     255;
            0       255     255;
            0       255     146;
            74      255     0;
            163     255     0;
            255     255     0;
            255     207     0;
            255     57      0;
            255     0       0;
            181     0       0;
            119     0       0];


        
f1 = figure('color', [1 1 1]);                                                                                          % initiate figure
ax1 = subplot(2, 1, 1);                                                                                                       % initiate subplot 1
for i_wavelength = 1:size(ref_power, 2)                                                                                  % for each wavelength...
    p_coup(i_wavelength, :) =  polyfit(ref_power(:, i_wavelength),coup_power(:, i_wavelength), 1);                	% ...and fit linear regression on this data data
    plot(ref_power(:, i_wavelength), coup_power(:, i_wavelength), 'ko', 'MarkerSize', 5, 'color', plotcol(i_wavelength, :)./255); hold on;     % ...plot coupler power as a function of reference power...    
    lsline 
end
xlabel('reference transmission [mW]'); ylabel('coupler transmission [mW]'); axis square;     % adjust axes




[p_coeff_coup,p_structure_coup] = polyfit(wavelengths,p_coup(:, 1)'.*100,2);  	% quadratic fit of power ratios
y_fit_coup = polyval(p_coeff_coup,wavelengths, p_structure_coup);               % generate y-values of fitted function


subplot(2, 1, 2);                                                                                               % initiate subplot 2
for i_wavelength = 1:size(p_coup, 1)                                                                            % for each wavelength...
    plot(wavelengths(i_wavelength), p_coup(i_wavelength, 1).*100, 'ko', 'color', plotcol(i_wavelength, :)./255, 'MarkerFaceColor', plotcol(i_wavelength, :)./255); hold on;      % ...plot the power ratio
end
plot(wavelengths, y_fit_coup, 'k--');                                                                % add fitted curve to the plot   
xlabel('wavelength [nm]'); ylabel('transmission [%]'); axis square; ylim([0 15]); xlim([300 800])    % adjust plot appearance


 
