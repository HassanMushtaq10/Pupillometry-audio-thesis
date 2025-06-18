% === LOAD MERGED CSV ===
inputFile = 'C:\Users\MushtaqHassa\Desktop\Thesis\Voilin Plot file\Merged_DeltaPupil_Playlist 1.csv';  % <-- Change to your actual path
data = readtable(inputFile);

% === CREATE COMBINED GROUP LABEL ===
data.Group = strcat(data.Experiment, ' - ', data.Condition);

% === CONVERT GROUP TO CATEGORICAL (for boxchart) ===
groupLabels = categorical(data.Group);

% === PLOT GROUPED BOXPLOT ===
figure('Color', 'w');
boxchart(groupLabels, data.DeltaPupil);
title('Distribution of \DeltaPupil Across Conditions and Experiments');
xlabel('Condition (Experiment and dB Level)');
ylabel('\DeltaPupil (Oddball - Baseline)');
grid on;
xtickangle(45);
yline(0, '--k', 'Zero Line', 'LabelHorizontalAlignment', 'left');

% Optional: Adjust axis limits
ylim auto;
