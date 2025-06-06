% 
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%% AFTER BASELINE %%%%%%%%%%%%%%%%%%%%%%%%%%% CORRECTION %%%%%%%%%
% 
% 
% % Define the directory where the CSV files are located
% directory = 'C:\Users\MushtaqHassa\Desktop\Thesis\PreProcessed_Data\Playlist 1\Sound_level_12dB_26_to_31_sec';
% Output_directory = 'C:\Users\MushtaqHassa\Desktop\Thesis\PreProcessed_Data\Playlist 1\Sound_level_12dB_26_to_31_sec';
% 
% % Get a list of all the CSV files in the directory
% files = dir(fullfile(directory, '*.csv'));
% 
% % Create a figure to hold the plots
% figure;
% 
% % Loop through each CSV file
% for i = 1:length(files)
% 
%     % Read the CSV file as a table
%     data_table = readtable(fullfile(directory, files(i).name));
% 
%     % Extract the first, second and third columns and convert to double
%     time = data_table{:, 1};
%     left_pupil_diameter = data_table{:, 2};
%     right_pupil_diameter = data_table{:, 3};
% 
%     % Baseline correction
%     baseline_start = 1;
%     baseline_end = 1800;  % adjust this value to select the baseline period
%     left_baseline_mean = mean(left_pupil_diameter(baseline_start:baseline_end));
%     right_baseline_mean = mean(right_pupil_diameter(baseline_start:baseline_end));
%     left_pupil_diameter_corrected = left_pupil_diameter - left_baseline_mean;
%     right_pupil_diameter_corrected = right_pupil_diameter - right_baseline_mean;
% 
%     % Create subplots for left and right eye
%     subplot(2,1,1);
%     hold on;
%     plot(time, left_pupil_diameter_corrected, 'DisplayName', files(i).name);
%     title('Left Eye');
%     xlabel('Time');
%     ylabel('Pupil Diameter (mm)');
% 
%     subplot(2,1,2);
%     hold on;
%     plot(time, right_pupil_diameter_corrected, 'DisplayName', files(i).name);
%     title('Right Eye');
%     xlabel('Time');
%     ylabel('Pupil Diameter (mm)');
% end
% 
% % % Show legend
% % legend1 = legend(subplot(2,1,1), 'show');
% % set(legend1, 'Position', [0.1 0.9 0.1 0.1]);
% % legend2 = legend(subplot(2,1,2), 'show');
% % set(legend2, 'Position', [0.1 0.9 0.1 0.1]);
% 
% %Highlight the area where x values are between 5 and 10 with consistent opacity
% highlight_start = 20;
% highlight_end = 25;
% for i = 1:2
%     subplot(2,1,i);
%     hold on;
%     x = [highlight_start highlight_end highlight_end highlight_start];
%     y = [min([left_pupil_diameter_corrected; right_pupil_diameter_corrected])*0.8 min([left_pupil_diameter_corrected; right_pupil_diameter_corrected])*0.8 max([left_pupil_diameter_corrected; right_pupil_diameter_corrected])*1.5 max([left_pupil_diameter_corrected; right_pupil_diameter_corrected])*1.5];
%     h = fill(x, y, [1 1 0.5], 'EdgeColor', 'none', 'FaceAlpha', 1);
%     uistack(h, 'bottom');
% end
% 
% % Save the figure
% saveas(gcf, fullfile(Output_directory, 'Sound_level_12dB_26_to_31_sec.png'));



% Directory containing CSV files with AvgPupilSize
directory = 'C:\Users\MushtaqHassa\Desktop\Thesis\EXP 2 Processed Data\Sync\Playlist 1\Original\Original\updated';
Output_directory = 'C:\Users\MushtaqHassa\Desktop\Thesis\EXP 2 Processed Data\Sync\Playlist 1\Average Plots';  


% Get the name of the folder to use in PNG file name
[~, folderName] = fileparts(directory);

% Get all CSV files in the directory
files = dir(fullfile(directory, '*.csv'));

% Create figure
figure;
hold on;

% Loop through each file and plot baseline-corrected AvgPupilSize
for i = 1:length(files)
    % Read file
    data_table = readtable(fullfile(directory, files(i).name));

    % Identify column names
    colNames = data_table.Properties.VariableNames;
    timeCol = colNames{contains(colNames, 'Time', 'IgnoreCase', true)};
    avgCol = colNames{contains(colNames, 'AvgPupilSize', 'IgnoreCase', true)};
    
    if isempty(timeCol) || isempty(avgCol)
        warning('Skipping %s: required columns not found.', files(i).name);
        continue;
    end

    % Extract data
    time = data_table.(timeCol);
    avgPupil = data_table.(avgCol);

    % Apply baseline correction using samples 1 to 1800
    baseline_start = 1;
    baseline_end = min(1800, length(avgPupil));  % Protect against short trials
    baseline_mean = mean(avgPupil(baseline_start:baseline_end), 'omitnan');
    avgPupil_corrected = avgPupil - baseline_mean;

    % Plot
    plot(time, avgPupil_corrected, 'DisplayName', files(i).name);
end

% Label the plot
title('Baseline-Corrected Average Pupil Size Over Time');
xlabel('Time (s)');
ylabel('Corrected Avg Pupil Diameter (mm)');
%legend('show');

% Highlight region between 20s and 25s
highlight_start = 29;
highlight_end = 34;
yLimits = ylim;
xHighlight = [highlight_start highlight_end highlight_end highlight_start];
yHighlight = [yLimits(1) yLimits(1) yLimits(2) yLimits(2)];
h = fill(xHighlight, yHighlight, [1 1 0.5], 'EdgeColor', 'none', 'FaceAlpha', 0.3);
uistack(h, 'bottom');

% Save figure using folder name
pngFileName = fullfile(Output_directory, [folderName, '.png']);
saveas(gcf, pngFileName);
fprintf('Saved baseline-corrected figure as: %s\n', pngFileName);
