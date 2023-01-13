%% prepare workspace
clear all; clc; close all;
addpath('G:\Alex\manuscripts\FusedFiberPhotometry_CellMethRep\02_final_submission\code')


%% define data files
path = 'G:\Alex\manuscripts\FusedFiberPhotometry_CellMethRep\02_final_submission\data\Figure_2\E-F\';

pupil = '751_GecoOnly_550_405_15-47-31_ds_DLC_tracking.mat';
photometry = '751_550_405-2021-08-03-154730.ppd';
AFFile = 'AF_550_405-2021-08-03-160035.ppd';
NIfile = 'VRdata_gad751_550_405_20210803155914.mat';

power_FFC1 = 78;            % in µW; excitation power for first channel (550 nm)
power_FFC2 = 64;            % in µW; excitation power for second channel (405 nm)


%% define variables
SR = 30;                        % sampling rate (pupil)
belt_length = 2;                % length of running belt (meters)
SR_NI = 3000;                   % sampling rate (national instruments board)
fitorder = 2;                   % degree of polynomial to fit bleaching of photometry data
smoothwindow_photometry	= 100;	% time window to smooth photometry data by moving average, in ms
corr_window = 180;              % length of window for correlations (in seconds)

conversion_factor = 0.76;       % at 550nm; factor to convert V in (given by doric lenses)


%% load data and calculate autofluorescence of FFC system
AFiber = import_ppd([path, AFFile]);
AFiber_1 = mean( AFiber.analog_1);
AFiber_2 = mean( AFiber.analog_2);


%% load and process photometry data
d = import_ppd([path, photometry]);

trig_idx   = find(d.digital_1(1:end-1) < 0.5 & d.digital_1(2:end) > 0.5)+1;     % find first and last trigger for data synchronization

d.analog_1 = d.analog_1(trig_idx(1):trig_idx(end))'; d.analog_1 = (d.analog_1-AFiber_1)./conversion_factor./power_FFC1; % synchronize data of channel 1 and convert it (emitted fluorescence / excitation power)
d.analog_2 = d.analog_2(trig_idx(1):trig_idx(end))'; d.analog_2 = (d.analog_2-AFiber_2)./conversion_factor./power_FFC2; % synchronize data of channel 2 and convert it (emitted fluorescence / excitation power)
d.analog_1_s = movmean(d.analog_1, d.sampling_rate./1000.*smoothwindow_photometry);   % smooth 470 trace by calculating a moving mean
d.analog_2_s = movmean(d.analog_2, d.sampling_rate./1000.*smoothwindow_photometry);   % smooth 405 trace by calculating a moving mean


[p_d1] = polyfit([1:length(d.analog_1_s)],d.analog_1,fitorder);                           % perform polynomial fit of 470 nm excited trace
y_d1 = polyval(p_d1,[1:length(d.analog_1_s)]);                                            % create fitted curve for 470 nm excited trace
d.analog_1_c = d.analog_1_s./y_d1;                                                        % divide 470 nm excited trace by polynomial fit to correct for bleaching

[p_d2] = polyfit([1:length(d.analog_2_s)],d.analog_2_s,fitorder);                           % perform polynomial fit of 405 nm excited trace
y_d2 = polyval(p_d2,[1:length(d.analog_2_s)]);                                            % create fitted curve for 405 nm excited trace
d.analog_2_c = d.analog_2_s./y_d2;                                                        % divide 405 nm excited trace by polynomial fit to correct for bleaching

d.dFoF = (d.analog_1_c-d.analog_2_c); % calculate delta F over F as the difference between the corrected 470 and 405 trace




%% load and process pupil data
pupildata = load([path, pupil]);
pupildata.d.pupil_diameter = movmedian(pupildata.d.pupil_diameter, 10);   % moving median filter data in order to reduce blinking artefacts
pupil_diameter = re_sample(pupildata.d.pupil_diameter,d.sampling_rate,SR); % re-sample pupil data to match the sampling rate of photometry data

%% load and process locomotion data
NI_data = load([path NIfile]);

NI_trig_idx   = find(NI_data.data.values(2, 1:end-1) < 3 & NI_data.data.values(2, 2:end) > 3)+1;            % find first and last trigger for data synchronization
NI_trig_idx = [NI_trig_idx'; NI_trig_idx(end)+round(mean(diff(NI_trig_idx)))];                              % add one inter-trigger-interval (as the trigger defines only the onset of these intervals)
position = NI_data.data.values(3, NI_trig_idx(1):NI_trig_idx(end));                                         % extract synchronized position data 

position = movmedian(position, SR_NI./2); position_ds = dwnsmp(position,SR_NI, d.sampling_rate);            % smooth position data with moving median filter and re-sample to match the sampling rate of photometry data
round_start   = find(diff(position_ds(1:end-1)) > -1 & diff(position_ds(2:end)) < -1);                      % identify the start of each new round on the running belt

cum_position_fullrounds = [];                                                                               % initiate variables to collect cumulative position data only of full rounds
for idx_round = 1:length(round_start)-1                                                                     % for each round...
    cur_round = position_ds(round_start(idx_round)+3:round_start(idx_round+1));                             % ...extract position data of current round...
    cur_round_norm = (cur_round-min(cur_round))./max((cur_round-min(cur_round))).*belt_length;              % ...normalize data of current round  
    cum_position_fullrounds = horzcat(cum_position_fullrounds, cur_round_norm+(idx_round-1)*belt_length);   % add cumulative position to a single variable
end

speed = diff(cum_position_fullrounds)./(1/d.sampling_rate); % calculate the speed of the mouse from the travel distance
speed = movmedian(speed, d.sampling_rate./2);   % smooth speed data with moving median filter to eliminate sharp artefacts originating from unprecise alignment of inividual rounds
speed = [speed(1) speed]; % add one more sampling point (for initial speed), as calculating the speed (i.e. tavelled distance between two sampling points) from the position vector shortens this vector by 1


%% align signals
d.analog_1_s = d.analog_1_s(round_start(1):round_start(1)+length(speed));               % crop photometry signal (channel 1) to match the running speed (i.e. only to be considered during full rounds on the treadmill)
d.analog_2_s = d.analog_2_s(round_start(1):round_start(1)+length(speed));               % crop photometry signal (channel 2) to match the running speed (i.e. only to be considered during full rounds on the treadmill)
d.dFoF = d.dFoF(round_start(1):round_start(1)+length(speed));                           % crop dFoF to match the running speed (i.e. only to be considered during full rounds on the treadmill)
pupil_diameter = pupil_diameter(round_start(1):round_start(1)+length(speed));           % crop pupil size to match the running speed (i.e. only to be considered during full rounds on the treadmill)


%% adjust length of signals to the minimum lenght
minlength = min([length(d.dFoF) length(pupil_diameter) length(speed)]);         % get minimum length of signals (as they might differ by a few sampling points)
d.dFoF          = d.dFoF(1:minlength);                                          % crop photometry trace to this length
pupil_diameter  = pupil_diameter(1:minlength);                                  % crop pupil trace to this length
speed           = speed(1:minlength);                                           % crop speed trace to this length



%% calculate correlations between different signal 

[r_calcium_pupil, p_calcium_pupil] =  corrcoef(d.dFoF, pupil_diameter);         % calculate correlations between calcium traces and pupil diameter
[r_calcium_speed, p_calcium_speed] =  corrcoef(d.dFoF, speed);                  % calculate correlations between calcium traces and running speed
[r_pupil_speed, p_pupil_speed] =  corrcoef(pupil_diameter, speed);              % calculate correlations between pupil diameter and running speed

% assign correlation coefficients to correlation matrix for plotting
cor_matrix_r = [1, 0, 0; 0, 1, 0; 0, 0, 1];
cor_matrix_r(3, 2) = r_calcium_pupil(2);
cor_matrix_r(3, 1) = r_calcium_speed(2);
cor_matrix_r(2, 1) = r_pupil_speed(2); 


     
    
%% create figure
xwin = [0 2]; % define time window for raw traces

figure('color', [1 1 1]); hold on;

ax1 = subplot(5, 3, 1:2); % plot raw data from channel 1
plot([1:length(d.analog_1_s)]./d.sampling_rate/60, d.analog_1_s-median(d.analog_1_s)); 

ax2 = subplot(5, 3, 4:5); % plot raw data from channel 2
plot([1:length(d.analog_2_s)]./d.sampling_rate/60, d.analog_2_s-median(d.analog_2_s)); 

linkaxes([ax1, ax2]);  % link y axes

ax3 = subplot(5, 3, 7:8); % plot delta F/F
plot([1:length(d.dFoF)]./d.sampling_rate/60, d.dFoF); 

ax4 = subplot(5, 3, 10:11);  % plot pupil size
plot([1:length(pupil_diameter)]./d.sampling_rate/60, pupil_diameter);

ax5 = subplot(5, 3, 13:14);  % plot running speed
plot([1:length(speed)]./d.sampling_rate/60, speed*100); ylim([-0.5 10])

linkaxes([ax1, ax2, ax3, ax4, ax5], 'x'); xlim([xwin(1) xwin(2)]); % link and limit x axes

subplot(3, 3, 3) % plot corrleation matrix
imagesc(cor_matrix_r); colorbar; axis square;
set(gca, 'XTick', [1:3], 'XTickLabel', {'run', 'pupil', 'photometry'}, 'YTick', [1:3], 'YTickLabel', {'run', 'pupil', 'photometry'})
colormap(magma(100))


