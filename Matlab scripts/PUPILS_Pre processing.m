% %  =================================== %
% %  PUPILS Pre-processing Pipeline v1.0 %
% %  =================================== %
% 
% % This script Performs PUPILS preprocessing

close all
addpath('C:\Users\MushtaqHassa\Desktop\Thesis\Final Test data\Final Test\onSync\Pupil Data\Participant 15\ahsan 2');
folder_path = 'C:\Users\MushtaqHassa\Desktop\Thesis\Final Test data\Final Test\onSync\Pupil Data\Participant 15\ahsan 2';
files = dir(fullfile(folder_path, '*.csv'));
% variable1_data = cell(21, 2);
% variable2_data = cell(21, 2);
% variable3_data = cell(21, 2);
% variable4_data = cell(21, 2);
% table_variables = cell(21, 2);

% Loop through the files
for l = 1:length(files)

     data_name = files(l).name;

     if strcmp(data_name, '.') || strcmp(data_name, '..') || strcmp(data_name, 'overview_blink_loss_velocity.csv') || strcmp(data_name, 'overview_blink_loss_velocity_constant2.csv') || strcmp(data_name, 'overview_blink_loss_velocity_constant5.csv')
        continue;
     end
     test=importdata([data_name]);
     test=test.data;

     % Initialize a matrix to store the time
     t = zeros(size(test, 1), 1);

     % Loop through the eyes (left and right)
     for n = 1:2

        if n==1 %Links
            clear data
        data(:,1)=test(:,7);
        data(:,2)=test(:,15);
        data(:,3)=test(:,16);
        data(:,4)=test(:,1); 
        fg_name=[data_name,'_L'];
        end

        if n==2%Rechts
            clear data
        data(:,1)=test(:,14);
        data(:,2)=test(:,15);
        data(:,3)=test(:,16);
        data(:,4)=test(:,8); 
        fg_name=[data_name,'_R'];
        end

        for i = 1 : (length(data))
            if data(i,2)>95
                data(i,:)=[];
            end
            if i == length(data)
                break
            end
        end

        for i=1:length(data)
            data(i,1)=i;
        end


        options = struct;
        options.fs = 64;                 % sampling frequency (Hz)
        options.blink_rule = 'vel';       % Rule for blink detection 'std' / 'vel'
        options.pre_blink_t   = 50;      % region to interpolate before blink (ms)
        options.post_blink_t  = 150;      % region to interpolate after blink (ms)
        options.xy_units = 'mm';          % xy coordinate units 'px' / 'mm' / 'cm'
        options.vel_threshold =  2;      % velocity threshold for saccade detection
        %options.blink_v_threshold = 5;
        options.min_sacc_duration = 20;   % minimum saccade duration (ms)
        options.interpolate_saccades = 0; % Specify whether saccadic distortions should be interpolated 1-yes 0-noB
        options.pre_sacc_t   = 50;        % Region to interpolate before saccade (ms)
        options.post_sacc_t  = 100;       % Region to interpolate after saccade (ms)
        options.low_pass_fc   = 10;       % Low-pass filter cut-off frequency (Hz)
        options.screen_distance= 1200;           % Screen distance in mm
        options.dpi = 150;                  % pixels/inches


        [proc_data proc_info] = processPupilData(data, options);


% Data visualization

        info_blinks = sprintf('blink loss: %.2f %%', proc_info.percentage_blinks );
        info_sacc = sprintf('saccadic movements: %.2f %%',proc_info.percentage_saccades);
        info_interp = sprintf('Interpolated data: %.2f %%',proc_info.percentage_interpolated);

        cols = [110 87 115;
                212 93 121;
                234 144 133;
                233 226 208;
                112 108 97]./255;

            fs = options.fs;

        N = length(proc_data);
        T = N/fs;
        t = 0:(1/fs):T-(1/fs); % Define time vector



        figure('Name',fg_name,'Position', [100 100 1000 600])


        subplot(2,1,1)

        plot(t, proc_data(:, 4), 'k')
        ylims = get(gca, 'YLim');
        axis([t(1) t(end) ylims(1) ylims(2)])

        title('Original pupil traze')
        xlabel('t(s)')
        ylabel('Pupil diameter (\mum)')


        subplot(2,1,2)

        plot(t, proc_data(:, size(proc_data, 2)), 'color', cols(2, :), 'linewidth', 1)
        ylims = get(gca, 'YLim');
        axis([t(1) t(end) ylims(1) ylims(2)])

        text(5, 1500, info_interp)

        title('Processed pupil traze')

        xlabel('time (s)');
        ylabel('Pupil Diameter (\mum)');
%         pupil_data_processed(:,n) = proc_data(:, size(proc_data, 2));
%         original_data(:,n) = data(:,4);
        %close all

        variable1_data{1, n} = data_name;
%        variable2_data{1, n} = proc_info.v_thresh;
        variable3_data{1, n} = info_blinks;
        variable4_data{1, n} = info_interp;

%         var1_str = cellfun(@join, variable1_data(l, n), 'UniformOutput', false);
%         var3_str = cellfun(@join, variable3_data(l, n), 'UniformOutput', false);
%         var4_str = cellfun(@join, variable4_data(l, n), 'UniformOutput', false);

        % Store the processed pupil data in the matrix
        if n == 1
            pupil_data_processed_left = proc_data(:, size(proc_data, 2));
            time_data = t;
        elseif n == 2
            pupil_data_processed_right = proc_data(:, size(proc_data, 2));
        end
     end

     % Open file for writing
     fid = fopen(fullfile(folder_path, [data_name '_processed15.csv']), 'w');

     % Write header row
     fprintf(fid, 'Time,Left Pupil Diameter,Right Pupil Diameter\n');

     % Write data rows
     for i = 1:size(pupil_data_processed_left, 1)
         fprintf(fid, '%f,%f,%f\n', time_data(i), pupil_data_processed_left(i), pupil_data_processed_right(i));
     end

     % Close file
     fclose(fid);
end