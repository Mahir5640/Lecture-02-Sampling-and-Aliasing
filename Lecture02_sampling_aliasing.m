%% Lecture02_sampling_aliasing.m
% Condition Monitoring System: Sampling and Aliasing Investigation
% Generates continuous and sampled signals, exports high-resolution PNGs.

clear; clc; close all;

%% Common Parameters
f_signal = 10;          % Signal frequency: 10 Hz
duration = 1.0;         % Signal duration: 1 second
f_cont = 10000;         % High-resolution frequency to mimic continuous signal
t_cont = 0:1/f_cont:duration;
x_cont = sin(2 * pi * f_signal * t_cont);

%% Task 1: Generate & Save the Original Signal
fig1 = figure('Name', 'Original Continuous Signal', 'Color', 'w');
plot(t_cont, x_cont, 'LineWidth', 1.8, 'Color', [0 0.447 0.741]);
title('Continuous Analog Vibration Signal (10 Hz Sine Wave)', 'FontSize', 12);
xlabel('Time (s)', 'FontSize', 11);
ylabel('Amplitude', 'FontSize', 11);
xlim([0 duration]);
ylim([-1.2 1.2]);
grid on;
legend('Continuous Signal (f = 10 Hz)', 'Location', 'northeast');

% Save original signal figure
exportgraphics(fig1, 'original_signal.png', 'Resolution', 300);

%% Task 2: Sample Signal at Specified Frequencies
fs_list = [15, 20, 25, 50, 100];

% 1. Export Individual Figures (as specified in repository layout)
for i = 1:length(fs_list)
    fs = fs_list(i);
    Ts = 1 / fs;
    t_sampled = 0:Ts:duration;
    x_sampled = sin(2 * pi * f_signal * t_sampled);

    fig = figure('Name', sprintf('Sampling at %d Hz', fs), 'Color', 'w');
    plot(t_cont, x_cont, 'Color', [0.7 0.7 0.7], 'LineWidth', 1.2, ...
        'DisplayName', 'Analog Signal (10 Hz)');
    hold on;
    stem(t_sampled, x_sampled, 'filled', 'LineWidth', 1.4, ...
        'Color', [0.85 0.325 0.098], 'MarkerFaceColor', [0.85 0.325 0.098], ...
        'DisplayName', sprintf('Samples (fs = %d Hz)', fs));

    % Interpolated line showing perceived digital signal
    plot(t_sampled, x_sampled, '--', 'Color', [0.85 0.325 0.098], ...
        'LineWidth', 1.0, 'DisplayName', 'Reconstructed Track');

    title(sprintf('Vibration Signal Sampled at f_s = %d Hz', fs), 'FontSize', 12);
    xlabel('Time (s)', 'FontSize', 11);
    ylabel('Amplitude', 'FontSize', 11);
    xlim([0 duration]);
    ylim([-1.2 1.2]);
    grid on;
    legend('Location', 'northeast');
    hold off;

    filename = sprintf('sampling_%dHz.png', fs);
    exportgraphics(fig, filename, 'Resolution', 300);
end

% 2. Combined Summary Subplot Figure
fig_summary = figure('Name', 'Sampling Comparison Summary', 'Color', 'w', ...
    'Position', [100, 100, 1000, 1100]);
for i = 1:length(fs_list)
    fs = fs_list(i);
    Ts = 1 / fs;
    t_sampled = 0:Ts:duration;
    x_sampled = sin(2 * pi * f_signal * t_sampled);

    subplot(5, 1, i);
    plot(t_cont, x_cont, 'Color', [0.65 0.65 0.65], 'LineWidth', 1.1);
    hold on;
    stem(t_sampled, x_sampled, 'filled', 'MarkerSize', 4, ...
        'Color', [0.85 0.325 0.098], 'MarkerFaceColor', [0.85 0.325 0.098]);
    plot(t_sampled, x_sampled, '--', 'Color', [0.85 0.325 0.098], 'LineWidth', 0.9);
    hold off;

    title(sprintf('f_s = %d Hz', fs), 'FontSize', 10, 'FontWeight', 'bold');
    ylabel('Amp');
    xlim([0 duration]);
    ylim([-1.2 1.2]);
    grid on;
    if i == 5
        xlabel('Time (seconds)');
    end
end

disp('All figures generated and exported successfully.');