% MATLAB Script to Scale Samples
clear; clc; close all;

% Parameters
load('1735.mat'); % Input file name
output_file_name = '1735_scaled.mat'; % Output file name
manual_offsets = [1764, 0, 0, 0, 1812, 1764]; % Offset values
actual_values = [230, 2, 2, 2, 230, 230]; % Actual RMS values

% Initialize channels matrix
[num_signals, signal_length] = size(channels);

% Initialize variables for the results
scaled_signals = zeros(size(channels));

% Offset and Scale signals
for i = 1:num_signals
    % Extract the i-th signal
    signal = channels(i, :);

    % Apply manual offset
    signal_with_manual_offset = signal - manual_offsets(i);

    % Adjust signal so that 2048 becomes 0
    signal_centered = signal_with_manual_offset;

    % Calculate the RMS value
    rms_value = sqrt(mean(signal_centered.^2));

    % Calculate the scaling factor
    scaling_factor = actual_values(i) / rms_value;
end

% Save the scaled signals in the specified output file
save(output_file_name, 'scaled_signals');

