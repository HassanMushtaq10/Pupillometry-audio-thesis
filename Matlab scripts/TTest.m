
% === CONFIGURATION ===
folder1 = 'C:\Users\MushtaqHassa\Desktop\Thesis\EXP 3 Processed Data\chunks data\odd balls\Playlist 2\Sound_level_-12dB_29_to_34_sec';
folder2 = 'C:\Users\MushtaqHassa\Desktop\Thesis\EXP 3 Processed Data\chunks data\original\For Playlist 2\29 to 34 chunks';
columnName = 'AvgPupilSize';

% === LOAD FILES ===
files1 = dir(fullfile(folder1, '*.csv'));
files2 = dir(fullfile(folder2, '*.csv'));

n = min(length(files1), length(files2));
avgOdd = zeros(n, 1);
avgBase = zeros(n, 1);
peakOdd = zeros(n, 1);

for i = 1:n
    try
        T1 = readtable(fullfile(folder1, files1(i).name));
        T2 = readtable(fullfile(folder2, files2(i).name));

        col1 = T1.(columnName);
        col2 = T2.(columnName);

        avgOdd(i) = mean(col1, 'omitnan');
        avgBase(i) = mean(col2, 'omitnan');
        peakOdd(i) = max(col1, [], 'omitnan');
    catch ME
        warning('Skipping participant %d: %s', i, ME.message);
        avgOdd(i) = NaN;
        avgBase(i) = NaN;
        peakOdd(i) = NaN;
    end
end

% === FILTER VALID ENTRIES ===
validIdx = ~isnan(avgOdd) & ~isnan(avgBase);
avgOdd = avgOdd(validIdx);
avgBase = avgBase(validIdx);
peakOdd = peakOdd(validIdx);
n = length(avgOdd);

% === DIFFERENCE CALCULATION ===
d = avgOdd - avgBase;
d_bar = mean(d);
sd = std(d, 1);  % population std
SE = sd / sqrt(n);
t_stat = d_bar / SE;
df = n - 1;

% === CRITICAL t-value at 95% CI ===
t_table = [6.314, 2.920, 2.353, 2.132, 2.015, 1.943, 1.895, 1.860, ...
           1.833, 1.812, 1.796, 1.782, 1.771, 1.761, 1.753, 1.746, ...
           1.740, 1.734, 1.729, 1.725, 1.721, 1.717, 1.714, 1.711, 1.708];
df_index = min(df, length(t_table));
t_crit = t_table(df_index);

% === Approximate p-value (two-tailed)
x = df / (df + t_stat^2);
p_val = betainc(x, df / 2, 0.5);
p_val = 2 * min(p_val, 1 - p_val);

% === CONFIDENCE INTERVAL
CI = [d_bar - t_crit * SE, d_bar + t_crit * SE];

% === COHEN'S D CALCULATION ===
cohens_d = d_bar / std(d, 1);  % use population std for within-subject d

% === OUTPUT RESULTS ===
fprintf('\n=== Toolbox-Free Paired t-Test with Effect Size ===\n');
fprintf('Participants analyzed: %d\n', n);
fprintf('Mean Oddball: %.3f mm\n', mean(avgOdd));
fprintf('Mean Baseline: %.3f mm\n', mean(avgBase));
fprintf('Mean Difference: %.3f mm\n', d_bar);
fprintf('Standard Deviation of Differences: %.3f mm\n', sd);
fprintf('Cohen''s d: %.3f\n', cohens_d);
fprintf('t-statistic: %.3f\n', t_stat);
fprintf('Approx. 95%% Confidence Interval: [%.3f, %.3f]\n', CI(1), CI(2));
fprintf('Approx. p-value: %.4f\n', p_val);
if abs(t_stat) > t_crit
    fprintf('Result: SIGNIFICANT difference at p < 0.05\n');
else
    fprintf('Result: No significant difference at p < 0.05\n');
end








