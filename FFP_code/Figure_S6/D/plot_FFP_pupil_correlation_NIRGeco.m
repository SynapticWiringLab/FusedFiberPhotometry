%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% A flexible and versatile system for multi-color fiber photometry and optogenetic manipulation
% Andrey Formozov, Alexander Dieter, J. Simon Wiegert
% code: Dieter, A, 2022 
% reviewed: Formozov, A, 2023
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% prepare workspace
clear all; close all; clc;

filePath = matlab.desktop.editor.getActiveFilename; % file path to the current script
location = regexp(filePath,'FFP_code','split'); % "location of the "FFP_code" folder"
addpath(location{1}+"FFP_code\");
% or add "FFP_code" into path manually by uncommenting and specifying the path:
% addpath('path_to_scripts\FFP_code')


%% define data files
path =data_location + '\FFP_data\Figure_S6\D\';

pupil = 'video0090 13-02-15_ds_DLC_tracking.mat';
photometry = 'DAT12_r-2021-07-06-130217.ppd';
AFFile = 'AF-2021-07-06-104103.ppd';
NIfile = 'VRdata_DAT12_r_405_650_20210706132332.mat';



%% define variables
SR = 30;            % sampling rate (pupil)
belt_length = 2;    % length of running belt (meters)
SR_NI = 3000;       % sampling rate (national instruments board)
fitorder = 2;       % degree of polynomial to fit bleaching of photometry data
lp_cutoff = 10;     % cut-off frequency of low-pass filter
corr_window = 10;   % length of window for correlations (in seconds)
Fzero_perc = 10;  	% percentile of data trace to estimate baseline fluorescence

conversion_factor = 0.76;   % at 550nm; factor to convert V in (given by doric lenses)
power_FFC1 = 660;            % in µW; excitation power for first channel (650 nm)


%% load data and calculate autofluorescence of FFC system
AFiber = import_ppd(path + AFFile);
AFiber_1 = mean( AFiber.analog_1);


%% load and process photometry data
d = import_ppd(path + photometry);

trig_idx   = find(d.digital_1(1:end-1) < 0.5 & d.digital_1(2:end) > 0.5)+1;     % find first and last trigger for data synchronization
trig_idx = [trig_idx; trig_idx(end)+round(mean(diff(trig_idx)))];               % add one inter-trigger-interval (as the trigger defines only the onset of these intervals)

d.analog_1 = d.analog_1(trig_idx(1):trig_idx(end))'; d.analog_1 = (d.analog_1-AFiber_1)./conversion_factor./power_FFC1;                         % synchronize data of channel 1 and convert it (emitted fluorescence / excitation power)
[p_d1] = polyfit([1:length(d.analog_1)],d.analog_1,fitorder); y_d1 = polyval(p_d1,[1:length(d.analog_1)]); d.analog_1_c = d.analog_1./y_d1;     % perform polynomial fit of channel 1 and divide signal by this fit to remove bleaching

d.d1_f = lowpass(d.analog_1_c,lp_cutoff,d.sampling_rate);  	% low-pass filter channel 1
F0 = prctile(d.d1_f, Fzero_perc);                           % calculate F-zero
d.dFoF = (d.d1_f-F0)./F0;                                   % calculate delta F over F


%% load and process pupil data
pupildata = load(path + pupil);
pupildata.d.pupil_diameter = movmedian(pupildata.d.pupil_diameter, 10);   % moving median filter data in order to reduce blinking artefacts
pupil_diameter = resample(pupildata.d.pupil_diameter,d.sampling_rate,SR); % re-sample pupil data to match the sampling rate of photometry data
pupil_diameter = lowpass(pupil_diameter,lp_cutoff,d.sampling_rate);       % low-pass filter pupil data  



%% load and process locomotion data
NI_data = load(path + NIfile);

NI_trig_idx   = find(NI_data.data.values(2, 1:end-1) < 3 & NI_data.data.values(2, 2:end) > 3)+1;    % find first and last trigger for data synchronization
NI_trig_idx = [NI_trig_idx'; NI_trig_idx(end)+round(mean(diff(NI_trig_idx)))];                      % add one inter-trigger-interval (as the trigger defines only the onset of these intervals)
position = NI_data.data.values(3, NI_trig_idx(1):NI_trig_idx(end));                                 % extract synchronized position data 

position = movmedian(position, SR_NI./2); position_ds = dwnsmp(position,SR_NI, d.sampling_rate);    % smooth position data with moving median filter and re-sample to match the sampling rate of photometry data
position_ds = (position_ds - min(position_ds))./max( position_ds - min(position_ds)).*belt_length;
round_start   = find(diff(position_ds(1:end-1)) > -1 & diff(position_ds(2:end)) < -1);              % identify the start of each new round on the running belt

position_ds = position_ds(round_start+3:end);           % in this specific example, the mouse did not run a full round. Hence, we take the start of the first round as the point for synchronization
speed = diff(position_ds)./(1/d.sampling_rate);         % calculate the speed of the mouse from the travel distance
speed = movmedian(speed, d.sampling_rate./2);          	% smooth speed data with moving median filter to eliminate sharp artefacts originating from unprecise alignment of inividual rounds
speed = [speed(1) speed];                              	% add one more sampling point (for initial speed), as calculating the speed (i.e. tavelled distance between two sampling points) from the position vector shortens this vector by 1


%% align signals
d.analog_1 = d.analog_1(round_start(1):round_start(1)+length(speed));               % crop photometry signal (channel 1) to match the running speed (i.e. only to be considered during full rounds on the treadmill)
d.dFoF = d.dFoF(round_start(1):round_start(1)+length(speed));                       % crop dFoF to match the running speed (i.e. only to be considered during full rounds on the treadmill)
pupil_diameter = pupil_diameter(round_start(1):round_start(1)+length(speed));       % crop pupil size to match the running speed (i.e. only to be considered during full rounds on the treadmill)



%% calculate correlations between different signal 

no_chunks = floor(length(d.dFoF)./d.sampling_rate./corr_window); % caclulate the number of data chunks (of the duration of the time specified time window)

for idx_chunk = 1:no_chunks % ... for each chunk
    
    cur_dFoF =      d.dFoF((idx_chunk-1)*d.sampling_rate*corr_window+1:idx_chunk*d.sampling_rate*corr_window);          % ...get the photometry data
    cur_speed =     speed((idx_chunk-1)*d.sampling_rate*corr_window+1:idx_chunk*d.sampling_rate*corr_window);           % ...the locomotion data
    cur_pupil =     pupil_diameter((idx_chunk-1)*d.sampling_rate*corr_window+1:idx_chunk*d.sampling_rate*corr_window);  % ...and the pupil data
    
    [r, p] =  corrcoef(cur_dFoF, cur_pupil);    r_calcium_pupil(idx_chunk) = r(2); p_calcium_pupil(idx_chunk) = p(2);   % calculate correlations between photometry and pupil size... 
    [r, p] =  corrcoef(cur_dFoF, cur_speed);    r_calcium_speed(idx_chunk) = r(2); p_calcium_speed(idx_chunk) = p(2);   % ... photometry and running speed...
    [r, p] =  corrcoef(cur_pupil, cur_speed);   r_pupil_speed(idx_chunk)= r(2);    p_pupil_speed(idx_chunk) = p(2);     % ... and pupil size and running speed.
     
end

%% create figure
xwin = [1 3]; % define time window for raw traces

figure('color', [1 1 1]); hold on;

ax1 = subplot(4, 1, 1); % plot raw data from channel 1
plot([1:length(d.analog_1)]./d.sampling_rate/60, d.analog_1); 

ax2 = subplot(4, 1, 2); % plot delta F/F
plot([1:length(d.dFoF)]./d.sampling_rate/60, d.dFoF); 

ax3 = subplot(4, 1, 3);  % plot pupil size
plot([1:length(pupil_diameter)]./d.sampling_rate/60, pupil_diameter);

ax4 = subplot(4, 1, 4);  % plot running speed
plot([1:length(speed)]./d.sampling_rate/60, speed*100); ylim([-5 5])

linkaxes([ax1, ax2, ax3, ax4], 'x'); xlim([xwin(1) xwin(2)]); % link and limit x axes
