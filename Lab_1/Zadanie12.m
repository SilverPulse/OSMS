% Задание 12: Спектры оригинального и прореженного сигналов

% Подгружаем оригинальный файл и создаем переменные (из зад-ий. 9 и 11)
[y, Fs] = audioread('voice.wav');
if size(y, 2) > 1
    y = y(:, 1);
end
y1 = downsample(y, 10);
Fs_new = Fs / 10;

% 1. ПФ для оригинального звучания
N_orig = length(y);
Y_orig = fft(y);
% Нормируем амплитуду
Y_mag_orig = abs(Y_orig) / N_orig; 
f_axis_orig = (0:N_orig-1) * (Fs / N_orig);

% 2. ПФ для прореженного сигнала
N_down = length(y1);
Y_down = fft(y1);
Y_mag_down = abs(Y_down) / N_down;
f_axis_down = (0:N_down-1) * (Fs_new / N_down);

figure;
% Верхний график: Оригинальный голос
subplot(2, 1, 1);
plot(f_axis_orig(1:floor(N_orig/2)), Y_mag_orig(1:floor(N_orig/2)), 'b');
title('Амплитудный спектр оригинального голоса (48000 Hz)');
xlabel('Частота, (GHz)');
ylabel('Амплитуда');
grid on;
xlim([0 Fs/2]); 

% Нижний график: Прореженный голос
subplot(2, 1, 2);
plot(f_axis_down(1:floor(N_down/2)), Y_mag_down(1:floor(N_down/2)), 'r');
title('Амплитудный спектр прореженного голоса (4800 Hz)');
xlabel('Частота, (GHz)');
ylabel('Амплитуда');
grid on;
xlim([0 Fs_new/2]);