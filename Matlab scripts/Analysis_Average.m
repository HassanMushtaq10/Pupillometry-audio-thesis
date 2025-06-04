% Set the folder path containing the CSV files
folderPath = 'C:\Users\MushtaqHassa\Desktop\Thesis\EXP 2 3 Processed Data\UnSync\Playlist 2\Sound_level_-12dB_29_to_34_sec'; 
outputFolder = fullfile(folderPath, 'processed average'); % Create a subfolder for output

% Create output folder if it doesn't exist
if ~exist(outputFolder, 'dir')
    mkdir(outputFolder);
end

% Get list of all CSV files in the folder
fileList = dir(fullfile(folderPath, '*.csv'));

% Check if any files found
if isempty(fileList)
    error('No CSV files found in the specified folder.');
end

% Loop through each file
for i = 1:length(fileList)
    filename = fileList(i).name;
    filepath = fullfile(folderPath, filename);

    fprintf('Processing file: %s\n', filename);

    % Read the CSV file into a table
    try
        data = readtable(filepath);
    catch ME
        warning('Could not read file: %s. Skipping.\nError: %s', filename, ME.message);
        continue;
    end

    % Normalize column names to make sure they're valid
    varNames = data.Properties.VariableNames;
    % Clean column names in case of weird formatting
    varNamesClean = strtrim(erase(varNames, '"'));
    data.Properties.VariableNames = varNamesClean;

    % Required column names
    requiredCols = {'Time', 'LeftPupilDiameter', 'RightPupilDiameter'};

    % Try to match cleaned versions of column names
    try
        % Rename columns to match expected names if needed
        colMap = containers.Map;

        for reqCol = requiredCols
            match = find(contains(varNamesClean, reqCol{1}, 'IgnoreCase', true), 1);
            if isempty(match)
                error('Required column "%s" not found in file: %s', reqCol{1}, filename);
            end
            colMap(reqCol{1}) = varNamesClean{match};
        end

        % Calculate average pupil size
        left = data.(colMap('LeftPupilDiameter'));
        right = data.(colMap('RightPupilDiameter'));
        data.AvgPupilSize = mean([left, right], 2, 'omitnan');

        % Write the new table to the output folder
        newFilePath = fullfile(outputFolder, filename);
        writetable(data, newFilePath);
        fprintf('Saved processed file to: %s\n', newFilePath);

    catch ME
        warning('Error processing %s: %s', filename, ME.message);
    end
end

disp('Processing complete.');
