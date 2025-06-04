
% Define input and output folders
inputFolder = 'C:\Users\MushtaqHassa\Desktop\Thesis\EXP 1 Processed Data\Playlist 2\Sound_level_-3dB_5_to_10_sec\Sound_level_-3dB_5_to_10_sec'; 
outputFolder  = 'C:\Users\MushtaqHassa\Desktop\Thesis\EXP 1 Processed Data\chunks data\Playlist 2\odd balls\Sound_level_-3dB_5_to_10_sec'; 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% For exp 1


% startRow = 239;    % 5  to 10
% endRow = 482;

% startRow = 726;    % 15  to 20
% endRow = 969;

% startRow = 386;    % 8  to 13
% endRow = 630;

% startRow = 438;    % 9  to 14
% endRow = 681;
% 
% startRow = 482;    % 10  to 15
% endRow = 726;
% 
% 
% startRow = 1256;    % 26  to 31
% endRow = 1500;



% For Playlist 2

startRow = 239;    % 5  to 10
endRow = 482;


% startRow = 1212;    % 25  to 30
% endRow = 1455;

% startRow = 482;    % 10  to 15
% endRow = 726;
% 
% startRow = 726;    % 15  to 20
% endRow = 969;
% 
 % startRow = 143;    % 3  to 8
 % endRow = 386;

% startRow = 1403;    % 29  to 34
% endRow = 1647;



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5


% startRow = 322;    % 5  to 10
% endRow = 642;

% startRow = 513;    % 8  to 13
% endRow = 834;

% startRow = 577;    % 9  to 14
% endRow = 898;
% 
% startRow = 641;    % 10  to 15
% endRow = 962;
% 
% startRow = 961;    % 15  to 20
% endRow = 1282;
% 
% startRow = 1665;    % 26  to 31
% endRow = 1986;

% For Playlist 2

% startRow = 322;    % 5  to 10
% endRow = 642;

% startRow = 1601;    % 25  to 30
% endRow = 1922;

 % startRow = 193;    % 3  to 8
 % endRow = 514;

% startRow = 641;    % 10  to 15
% endRow = 962;
% 
% startRow = 961;    % 15  to 20
% endRow = 1282;
% 
% startRow = 1857;    % 29  to 34
% endRow = 2178;


% Create output folder if it doesn't exist
if ~exist(outputFolder, 'dir')
    mkdir(outputFolder);
end

% Get list of all CSV files
csvFiles = dir(fullfile(inputFolder, '*.csv'));

% Process each file
for k = 1:length(csvFiles)
    filename = csvFiles(k).name;
    filepath = fullfile(inputFolder, filename);

    % Read table with headers
    data = readtable(filepath);

    % Extract chunk (ensure indices are within bounds)
    chunk = data(startRow:min(endRow, height(data)), :);

    % Save chunk to the output folder with the same filename
    outputFile = fullfile(outputFolder, filename);
    writetable(chunk, outputFile);
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%555
%script for plotting

% Define folders
folder1 = 'C:\Users\MushtaqHassa\Desktop\Thesis\EXP 1 Processed Data\chunks data\Playlist 2\Original\5 to 10 sec chunks';
folder2 = 'C:\Users\MushtaqHassa\Desktop\Thesis\EXP 1 Processed Data\chunks data\Playlist 2\odd balls\Sound_level_-3dB_5_to_10_sec';



% Get file lists
files1 = dir(fullfile(folder1, '*.csv'));
files2 = dir(fullfile(folder2, '*.csv'));

% Initialize for folder 1
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

% Initialize for folder 2
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
xlabel('Time');
ylabel('Average Pupil Size');
title('Comparison of Mean Pupil Size Over Time');
legend('Original', '-3db');
grid on;


