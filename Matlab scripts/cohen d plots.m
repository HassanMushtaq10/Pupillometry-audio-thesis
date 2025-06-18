

%%%%%%%%%%%%%%%%%%%%%%% Ploting cohen d effect size %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Define Cohen's d values (rows = sound levels, columns = Exp-Trial combos)
cohen_d = [
    -0.512, -0.505,  0.285, -0.075, -0.542, -0.032;  % +3 dB
    -0.510, -0.546,  0.207, -0.892, -0.838, -0.654;  % +8 dB
    -0.701, -0.707,  0.574,  0.035,  0.450,  0.013;  % +12 dB
    -0.680, -0.196,  0.283, -0.168, -0.655, -0.195;  % -3 dB
    -0.730, -0.127,  0.303, -0.369, -0.543, -0.467;  % -8 dB
    -0.524, -0.026,  0.497,  0.495, -1.213,  0.400   % -12 dB
];

% Labels for X-axis
sound_levels = {'+3 dB', '+8 dB', '+12 dB', '-3 dB', '-8 dB', '-12 dB'};

% Create grouped bar chart
figure;
bar_handle = bar(cohen_d, 'grouped');
grid on;
ylim([-1.4, 1.0]);
ylabel("Cohen's d");
xlabel("Sound Level");
title("Cohen’s d per Trial and Experiment");

% X-tick labels
set(gca, 'XTickLabel', sound_levels, 'FontSize', 10);

% Legend
legend({'Exp 1 - Trial 1', 'Exp 1 - Trial 2', ...
        'Exp 2 - Trial 1', 'Exp 2 - Trial 2', ...
        'Exp 3 - Trial 1', 'Exp 3 - Trial 2'}, ...
        'Location', 'northwest');


hold on;
yline(0, 'k--');
yline(0.2, ':k', 'Small');
yline(0.5, ':k', 'Medium');
yline(0.8, ':k', 'Large');
yline(-0.2, ':k');
yline(-0.5, ':k');
yline(-0.8, ':k');
hold off;



