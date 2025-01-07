function TimeDomainPlot(sampleRate, plotDuration, dataFile)

% Load data
data = load(dataFile); 

% Define samples to plot
num_samples = round(plotDuration * sampleRate); 

% Extract vcurrent and voltage signals
time_vector = linspace(0, plotDuration, num_samples);
currents = data.scaledSignals(1:3, 1:num_samples); 
voltages = data.scaledSignals(4:6, 1:num_samples); 

% Plot signals
figure;
plot(time_vector, voltages(1, :), 'k-', 'DisplayName', 'L1');
hold on;
plot(time_vector, voltages(2, :), 'k-', 'DisplayName', 'L2');
plot(time_vector, voltages(3, :), 'k-', 'DisplayName', 'L3');
hold off;
title('Időtartomány feszültség');
xlabel('Idő (s)');
ylabel('Feszültség (V)');
text(0.01, voltages(1, round(0.01 * sampleRate)), 'L1');
text(0.01, voltages(2, round(0.01 * sampleRate)), 'L2');
text(0.01, voltages(3, round(0.01 * sampleRate)), 'L3');
fontname("Roboto Slab");
grid on;

figure;
plot(time_vector, currents(1, :), 'k-', 'DisplayName', 'L1');
hold on;
plot(time_vector, currents(2, :), 'k-', 'DisplayName', 'L2');
plot(time_vector, currents(3, :), 'k-', 'DisplayName', 'L3');
hold off;
title('Időtartomány áram');
xlabel('Idő (s)');
ylabel('Áram (A)');
text(0.01, currents(1, round(0.01 * sampleRate)), 'L1');
text(0.01, currents(2, round(0.01 * sampleRate)), 'L2');
text(0.01, currents(3, round(0.01 * sampleRate)), 'L3');
fontname("Roboto Slab");
grid on;
