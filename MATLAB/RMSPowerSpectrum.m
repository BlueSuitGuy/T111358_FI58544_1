function RMSPowerSpectrum(sampleRate, dataFile)
% Load data
data = load(dataFile);

% Extract signals 
channels = data.scaledSignals;

% Parameters
segment_length = floor(sampleRate * 10);         % Segment length
num_segments = 1;                              % Total segments
window = blackmanharris(segment_length);            % Window for each segment

% Total number of signals
num_signals = size(channels, 1);

% Frequency resolution of FFT
freq_resolution = sampleRate / segment_length;  

% Preallocate storage results
rms_power_spectra = zeros(num_signals, floor(segment_length / 2 + 1));

% Process each signal
for signal_idx = 1:num_signals
    
    % Get the signal
    signal = channels(signal_idx, 1:num_segments * segment_length); 

    % Suppress DC component
    signal = signal - mean(signal); 

    % Preallocate storage results for segment results
    segment_power_spectra = zeros(num_segments, floor(segment_length / 2 + 1));

    % Get segments and compute FFT for each
    for seg = 1:num_segments
        start_idx = (seg - 1) * segment_length + 1;
        end_idx = start_idx + segment_length - 1;
        
        % Extract segment and apply window
        segment = signal(start_idx:end_idx) .* window';
        
        % Compute FFT and normalize
        fft_result = fft(segment);
        
        % Compute power spectrum
        power_spectrum = abs(fft_result / segment_length).^2;
        
        % Convert to single-sided
        power_spectrum = power_spectrum(1:floor(segment_length / 2 + 1));
        
        % Adjust for power conservation
        power_spectrum(2:end-1) = 2 * power_spectrum(2:end-1);
        
        % Store power spectrum for segment
        segment_power_spectra(seg, :) = power_spectrum;
    end

    % Compute the average power spectrum across all segments
    mean_power_spectrum = mean(segment_power_spectra, 1);

    % Compute the RMS power spectrum
    rms_power_spectrum = sqrt(mean_power_spectrum);

    % Set the fundamental to 0 dB
    freq_axis = (0:(segment_length / 2)) * freq_resolution;
    [~, idx_50Hz] = min(abs(freq_axis - 50));
    normalization_factor = rms_power_spectrum(idx_50Hz);
    rms_power_spectrum_dB = 20 * log10(rms_power_spectrum / normalization_factor);

    % Store the result
    rms_power_spectra(signal_idx, :) = rms_power_spectrum_dB;

    % Plot the result
    figure;
    plot(freq_axis, rms_power_spectrum_dB, 'k');
    xlabel('Frekvencia (Hz)');
    ylabel('Amplítudó (dB)');
    if signal_idx <= 3
        title(sprintf('RMS teljesítmény spektrum - Áram L%d', signal_idx));
    else
        title(sprintf('RMS teljesítmény spektrum - Feszültség L%d', signal_idx - 3));
    end
    fontname("Roboto Slab");
    xlim([40 60]);
    grid on;
end
