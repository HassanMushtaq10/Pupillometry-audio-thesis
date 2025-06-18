
% === CONFIGURATION ===
folder1 = 'C:\Users\MushtaqHassa\Desktop\Thesis\EXP 3 Processed Data\chunks data\odd balls\Playlist 2\Sound_level_-12dB_29_to_34_sec';
folder2 = 'C:\Users\MushtaqHassa\Desktop\Thesis\EXP 3 Processed Data\chunks data\original\For Playlist 2\29 to 34 chunks';
outputDir = 'C:\Users\MushtaqHassa\Desktop\Thesis\Voilin Plot file\'; 
columnName = 'AvgPupilSize';
experimentNumber = 3;  % Set experiment number (1, 2, or 3)

% === LOAD FILES ===
files1 = dir(fullfile(folder1, '*.csv'));
files2 = dir(fullfile(folder2, '*.csv'));

n = min(length(files1), length(files2));
dataTable = [];

% Initialize condition placeholder
conditionLabelForFile = '';

for i = 1:n
    try
        % Read pupil data
        T1 = readtable(fullfile(folder1, files1(i).name));
        T2 = readtable(fullfile(folder2, files2(i).name));

        col1 = T1.(columnName);
        col2 = T2.(columnName);

        avgOdd = mean(col1, 'omitnan');
        avgBase = mean(col2, 'omitnan');
        deltaPupil = avgOdd - avgBase;

        % === METADATA FROM FILENAME ===
        filename = files1(i).name;

        % Extract condition (e.g., "+3 dB" or "-12 dB")
        conditionToken = regexp(filename, 'Sound_level_([-+]?\d+)dB', 'tokens');
        if isempty(conditionToken)
            warning('Condition not found in filename: %s', filename);
            continue;
        end
        condition = [conditionToken{1}{1}, ' dB'];

        if isempty(conditionLabelForFile)
            conditionLabelForFile = [conditionToken{1}{1}, 'dB'];
        end

        % === Extract participant number from different patterns ===
        participantNum = 1;  % default

        % Try "processed2" pattern
        match1 = regexp(filename, 'processed(\d+)', 'tokens');
        % Try "processed (2)" pattern
        match2 = regexp(filename, 'processed \((\d+)\)', 'tokens');

        if ~isempty(match1)
            participantNum = str2double(match1{1}{1});
        elseif ~isempty(match2)
            participantNum = str2double(match2{1}{1});
        else
            warning('Participant number not found in filename: %s. Defaulting to P01.', filename);
        end

        participant = ['P', sprintf('%02d', participantNum)];

        % === APPEND TO DATA TABLE ===
        dataTable = [dataTable; {participant, sprintf('Exp %d', experimentNumber), condition, deltaPupil}];

    catch ME
        warning('Skipping file %s: %s', files1(i).name, ME.message);
    end
end

% === EXPORT ===
output = cell2table(dataTable, 'VariableNames', {'Participant', 'Experiment', 'Condition', 'DeltaPupil'});

% Dynamic output file path

outputFileName = sprintf('DeltaPupil_P2_Exp%d_%s.csv', experimentNumber, conditionLabelForFile);
outputPath = fullfile(outputDir, outputFileName);

writetable(output, outputPath);
fprintf('✅ Exported DeltaPupil data to:\n%s\n', outputPath);
