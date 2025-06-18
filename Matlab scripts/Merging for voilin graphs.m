%%%%%%%%%%%% Merging into one file &%%%%%%%%%%%%%%%%55
% === CONFIGURATION ===
inputFolder = 'C:\Users\MushtaqHassa\Desktop\Thesis\Voilin Plot file\Playlist 2';  % <-- update this
outputFile = 'C:\Users\MushtaqHassa\Desktop\Thesis\Voilin Plot file\Merged_DeltaPupil_Playlist 2.csv';  % <-- update this

% === LOAD FILES ===
files = dir(fullfile(inputFolder, '*.csv'));
mergedData = [];

for i = 1:length(files)
    try
        % Read current file
        filePath = fullfile(inputFolder, files(i).name);
        T = readtable(filePath);

        % Check for required columns
        if all(ismember({'Participant', 'Experiment', 'Condition', 'DeltaPupil'}, T.Properties.VariableNames))
            mergedData = [mergedData; T];  % Append
        else
            warning('Skipping %s: Missing required columns.', files(i).name);
        end

    catch ME
        warning('Error reading %s: %s', files(i).name, ME.message);
    end
end

% === EXPORT MERGED DATA ===
if ~isempty(mergedData)
    writetable(mergedData, outputFile);
    fprintf('✅ Merged %d files and saved to:\n%s\n', length(files), outputFile);
else
    warning('No valid data found to merge.');
end

