function Read(serialPort, numSamples, sampleRate, nameCal, nameOut)

% Parameters
baudRate = 115200;          % Baud rate (not critical for USB)
numChannels = 6;            % Number of data channels

% Load calibration data
data = load(nameCal);

% Define samples to read
readSamples = 6.*numSamples;

% Open serial connection
serialObj = serialport(serialPort, baudRate);
serialObj.ByteOrder = 'little-endian';
flush(serialObj);

% Preallocate storage for serial data
rawData = zeros(1, readSamples, 'uint16');

% Read data from the serial port
tic
rawData = read(serialObj,readSamples,"uint16");
toc

% Initialize the channels matrix
channels = zeros(numChannels, ceil(readSamples / numChannels));

% Assign data to channels
for i = 1:readSamples
    channelIndex = mod(i-1, numChannels) + 1;
    sampleIndex = ceil(i / numChannels);
    channels(channelIndex, sampleIndex) = rawData(i);
end

% Swap Row 1 with Row 4 for correct order
 temp = channels(1, :);
 channels(1, :) = channels(4, :); 
 channels(4, :) = temp; 

% Extract values
manualOffsets = data.calibrationValues(1, :); 
scalingFactor = data.calibrationValues(2, :); 

% Initialize channels matrix
[numSignals, signalLength] = size(channels);

% Initialize variables for the results
scaledSignals = zeros(size(channels));

% Offset and Scale signals
for i = 1:numSignals
    % Extract the i-th signal
    signal = channels(i, :);

    % Apply offset
    signalWithOffset = signal - manualOffsets(i);

    % Scale the signal
    scaledSignal = signalWithOffset * scalingFactor(i);

    % Store the scaled signal
    scaledSignals(i, :) = scaledSignal;
end    

save(nameOut, 'scaledSignals');

% Generate time vector
time = (0:signalLength-1) / sampleRate;

% Plot signals for validation
figure;
for i = 1:numSignals
    subplot(numSignals, 1, i);
    plot(time, scaledSignals(i, :));
    title(['Csatorna ', num2str(i)]);
    xlabel('Idő (s)');
    ylabel('Érték');
    ylim([0, 4096]);
    fontname("Roboto Slab");
    grid on;
end


% Close the serial port
clear serialObj;
disp('Processing complete.');