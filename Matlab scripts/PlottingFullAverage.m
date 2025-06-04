% % Script for plotting and saving average pupil size comparison
% % For exp 2
% 
% % Define data folders
% folder1 = 'C:\Users\MushtaqHassa\Desktop\Thesis\EXP 2 Processed Data\Sync\Playlist 1\Original\Original\updated';
% folder2 = 'C:\Users\MushtaqHassa\Desktop\Thesis\EXP 3 Processed Data\UnSync\Playlist 1\Sound_level_3dB_5_to_10_sec\Sound_level_3dB_5_to_10_sec';
% 
% % Define save folder
% saveFolder = 'C:\Users\MushtaqHassa\Desktop\Thesis\EXP 3 Processed Data\UnSync\Playlist 1\Mean full plots';
% if ~exist(saveFolder, 'dir')
%     mkdir(saveFolder);
% end
% 
% % Get file lists
% files1 = dir(fullfile(folder1, '*.csv'));
% files2 = dir(fullfile(folder2, '*.csv'));
% 
% % Process folder 1 (Original)
% allAvgPupil1 = {};
% minLength1 = inf;
% time = [];
% 
% for i = 1:length(files1)
%     filePath = fullfile(folder1, files1(i).name);
%     data = readtable(filePath);
%     if all(ismember({'Time', 'AvgPupilSize'}, data.Properties.VariableNames))
%         if isempty(time)
%             time = data.Time;
%         end
%         allAvgPupil1{end+1} = data.AvgPupilSize;
%         minLength1 = min(minLength1, length(data.AvgPupilSize));
%     end
% end
% 
% % Truncate and convert to matrix
% allAvgPupil1Mat = zeros(minLength1, numel(allAvgPupil1));
% for i = 1:numel(allAvgPupil1)
%     allAvgPupil1Mat(:, i) = allAvgPupil1{i}(1:minLength1);
% end
% avgPupil1 = mean(allAvgPupil1Mat, 2, 'omitnan');
% time = time(1:minLength1);
% 
% % Process folder 2 (Oddball)
% allAvgPupil2 = {};
% minLength2 = inf;
% 
% for i = 1:length(files2)
%     filePath = fullfile(folder2, files2(i).name);
%     data = readtable(filePath);
%     if ismember('AvgPupilSize', data.Properties.VariableNames)
%         allAvgPupil2{end+1} = data.AvgPupilSize;
%         minLength2 = min(minLength2, length(data.AvgPupilSize));
%     end
% end
% 
% % Truncate and convert to matrix
% minCommonLength = min(minLength1, minLength2);
% allAvgPupil1Mat = allAvgPupil1Mat(1:minCommonLength, :);
% time = time(1:minCommonLength);
% 
% allAvgPupil2Mat = zeros(minCommonLength, numel(allAvgPupil2));
% for i = 1:numel(allAvgPupil2)
%     allAvgPupil2Mat(:, i) = allAvgPupil2{i}(1:minCommonLength);
% end
% avgPupil2 = mean(allAvgPupil2Mat, 2, 'omitnan');
% 
% % --- Extract folder info for labels and highlighting ---
% [~, folder2Name] = fileparts(folder2);
% 
% % Extract dB label
% dBmatch = regexp(folder2Name, 'Sound_level_([-\d]+dB)', 'tokens');
% if ~isempty(dBmatch)
%     dBlabel = dBmatch{1}{1}; % e.g., '3dB' or '-3dB'
% else
%     dBlabel = 'Oddball'; % fallback
% end
% 
% % Extract highlight range
% timeMatch = regexp(folder2Name, '(\d+)_to_(\d+)_sec', 'tokens');
% if ~isempty(timeMatch)
%     t1 = str2double(timeMatch{1}{1});
%     t2 = str2double(timeMatch{1}{2});
% else
%     t1 = NaN; t2 = NaN;
% end
% 
% % --- Plotting ---
% figure;
% hold on;
% 
% % Highlight region
% if ~isnan(t1) && ~isnan(t2)
%     yLimits = [min([avgPupil1; avgPupil2]), max([avgPupil1; avgPupil2])];
%     fill([t1 t2 t2 t1], [yLimits(1) yLimits(1) yLimits(2) yLimits(2)], ...
%         [0.9 0.9 0.9], 'EdgeColor', 'none', 'FaceAlpha', 0.5);
%     legendLabels = {'Highlight Region'};
% else
%     legendLabels = {};
% end
% 
% % Plot curves
% p1 = plot(time, avgPupil1, 'b', 'LineWidth', 2);
% p2 = plot(time, avgPupil2, 'r', 'LineWidth', 2);
% xlabel('Time (s)');
% ylabel('Average Pupil Size');
% title('Mean Pupil Size Over Time: Original vs. Oddball');
% 
% % Create full legend
% legendLabels = [legendLabels, {'Original', ['Oddball (' dBlabel ')']}];
% legend(legendLabels, 'Location', 'best');
% 
% grid on;
% 
% % Save the figure
% saveFileName = [folder2Name, '.png'];
% saveas(gcf, fullfile(saveFolder, saveFileName));





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%For Exp 3

% Script for plotting and saving average pupil size comparison
% For EXP 2 vs EXP 3 (UnSync)

% Define data folders
folder1 = 'C:\Users\MushtaqHassa\Desktop\Thesis\EXP 2 Processed Data\Sync\Playlist 1\Original\Original\updated';
folder2 = 'C:\Users\MushtaqHassa\Desktop\Thesis\EXP 3 Processed Data\UnSync\Playlist 2\Sound_level_-12dB_29_to_34_sec\Sound_level_-12dB_29_to_34_sec\Sound_level_-12dB_29_to_34_sec';

% Define save folder
saveFolder = 'C:\Users\MushtaqHassa\Desktop\Thesis\EXP 3 Processed Data\UnSync\Playlist 2\Mean full plots';
if ~exist(saveFolder, 'dir')
    mkdir(saveFolder);
end

% Get file lists
files1 = dir(fullfile(folder1, '*.csv'));
files2 = dir(fullfile(folder2, '*.csv'));

% Process folder 1 (Original)
allAvgPupil1 = {};
minLength1 = inf;
time = [];

for i = 1:length(files1)
    filePath = fullfile(folder1, files1(i).name);
    data = readtable(filePath);
    if all(ismember({'Time', 'AvgPupilSize'}, data.Properties.VariableNames))
        if isempty(time)
            time = data.Time;
        end
        allAvgPupil1{end+1} = data.AvgPupilSize;
        minLength1 = min(minLength1, length(data.AvgPupilSize));
    end
end

% Truncate and convert to matrix
allAvgPupil1Mat = zeros(minLength1, numel(allAvgPupil1));
for i = 1:numel(allAvgPupil1)
    allAvgPupil1Mat(:, i) = allAvgPupil1{i}(1:minLength1);
end
avgPupil1 = mean(allAvgPupil1Mat, 2, 'omitnan');
time = time(1:minLength1);

% Process folder 2 (Oddball)
allAvgPupil2 = {};
minLength2 = inf;

for i = 1:length(files2)
    filePath = fullfile(folder2, files2(i).name);
    data = readtable(filePath);
    if ismember('AvgPupilSize', data.Properties.VariableNames)
        allAvgPupil2{end+1} = data.AvgPupilSize;
        minLength2 = min(minLength2, length(data.AvgPupilSize));
    end
end

% Truncate and convert to matrix
minCommonLength = min(minLength1, minLength2);
allAvgPupil1Mat = allAvgPupil1Mat(1:minCommonLength, :);
time = time(1:minCommonLength);

allAvgPupil2Mat = zeros(minCommonLength, numel(allAvgPupil2));
for i = 1:numel(allAvgPupil2)
    allAvgPupil2Mat(:, i) = allAvgPupil2{i}(1:minCommonLength);
end
avgPupil2 = mean(allAvgPupil2Mat, 2, 'omitnan');

% --- FIX: Ensure vectors are all same length ---
avgPupil1 = avgPupil1(1:minCommonLength);
avgPupil2 = avgPupil2(1:minCommonLength);

% --- Extract folder info for labels and highlighting ---
[~, folder2Name] = fileparts(folder2);

% Extract dB label
dBmatch = regexp(folder2Name, 'Sound_level_([-\d]+dB)', 'tokens');
if ~isempty(dBmatch)
    dBlabel = dBmatch{1}{1}; % e.g., '3dB' or '-3dB'
else
    dBlabel = 'Oddball'; % fallback
end

% Extract highlight range
timeMatch = regexp(folder2Name, '(\d+)_to_(\d+)_sec', 'tokens');
if ~isempty(timeMatch)
    t1 = str2double(timeMatch{1}{1});
    t2 = str2double(timeMatch{1}{2});
else
    t1 = NaN; t2 = NaN;
end

% --- Plotting ---
figure;
hold on;

% Highlight region
if ~isnan(t1) && ~isnan(t2)
    yLimits = [min([avgPupil1; avgPupil2]), max([avgPupil1; avgPupil2])];
    fill([t1 t2 t2 t1], [yLimits(1) yLimits(1) yLimits(2) yLimits(2)], ...
        [0.9 0.9 0.9], 'EdgeColor', 'none', 'FaceAlpha', 0.5);
    legendLabels = {'Highlight Region'};
else
    legendLabels = {};
end

% Plot curves
plot(time, avgPupil1, 'b', 'LineWidth', 2);
plot(time, avgPupil2, 'r', 'LineWidth', 2);
xlabel('Time (s)');
ylabel('Average Pupil Size');
title('Mean Pupil Size Over Time: Original vs. Oddball');

% Dynamic legend
legendLabels = [legendLabels, {'Original', ['Oddball (' dBlabel ')']}];
legend(legendLabels, 'Location', 'best');
grid on;

% Save the figure
saveFileName = [folder2Name, '.png'];
saveas(gcf, fullfile(saveFolder, saveFileName));
