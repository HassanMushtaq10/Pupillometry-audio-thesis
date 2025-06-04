% Script for plotting and saving average pupil size comparison

% Define data folders
folder1 = 'C:\Users\MushtaqHassa\Desktop\Thesis\EXP 3 Processed Data\chunks data\original\For Playlist 2\29 to 34 chunks';
folder2 = 'C:\Users\MushtaqHassa\Desktop\Thesis\EXP 3 Processed Data\chunks data\odd balls\Playlist 2\Sound_level_-12dB_29_to_34_sec';

% Define save folder for the plot
saveFolder = 'C:\Users\MushtaqHassa\Desktop\Thesis\EXP 3 Processed Data\UnSync\Playlist 2\Mean chunk plots';
if ~exist(saveFolder, 'dir')
    mkdir(saveFolder);
end


% Get file lists
files1 = dir(fullfile(folder1, '*.csv'));
files2 = dir(fullfile(folder2, '*.csv'));

% Initialize for folder 1 (Original)
allAvgPupil1 = [];
time1 = [];

for i = 1:length(files1)
    filePath = fullfile(folder1, files1(i).name);
    data = readtable(filePath);
    if all(ismember({'Time', 'AvgPupilSize'}, data.Properties.VariableNames))
        if isempty(time1)
            time1 = data.Time;
        end
        allAvgPupil1 = [allAvgPupil1, data.AvgPupilSize];
    else
        warning(['Missing columns in file: ', files1(i).name]);
    end
end

avgPupil1 = mean(allAvgPupil1, 2, 'omitnan');

% Initialize for folder 2 (Oddball)
allAvgPupil2 = [];
time2 = [];

for i = 1:length(files2)
    filePath = fullfile(folder2, files2(i).name);
    data = readtable(filePath);
    if all(ismember({'Time', 'AvgPupilSize'}, data.Properties.VariableNames))
        if isempty(time2)
            time2 = data.Time;
        end
        allAvgPupil2 = [allAvgPupil2, data.AvgPupilSize];
    else
        warning(['Missing columns in file: ', files2(i).name]);
    end
end

avgPupil2 = mean(allAvgPupil2, 2, 'omitnan');

% Plotting
figure;
plot(time1, avgPupil1, 'b', 'LineWidth', 2); hold on;
plot(time2, avgPupil2, 'r', 'LineWidth', 2);
xlabel('Time (s)');
ylabel('Average Pupil Size');
title('Mean Pupil Size Over Time: Original vs. Oddball');
legend('Original', '-12db', 'Location', 'best');
grid on;

% Extract last part of folder2 name for filename
[~, folder2Name] = fileparts(folder2);
saveFileName = [folder2Name, '.png'];

% Save the figure
saveas(gcf, fullfile(saveFolder, saveFileName));




