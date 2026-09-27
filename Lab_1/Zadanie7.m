% Задание 7: Увеличение частоты дискретизации в 4 раза (80 Гц)
Fs_new = 80; 
Ts_new = 1 / Fs_new;

% Оцифровка
t_discrete_new = 0:Ts_new:1; 
y_discrete_new = A * sin(2 * pi * f * t_discrete_new + phase);

figure;
stem(t_discrete_new, y_discrete_new, 'g', 'filled', 'LineWidth', 1.5);
grid on;
title('Дискретные отсчеты (80 Hz)');
xlabel('Время t, (с)');
ylabel('Амплитуда');
xlim([0 0.5]); % Ограничим для наглядности

% Дискретное преобразование Фурье
N_new = length(y_discrete_new);
Y_new = fft(y_discrete_new);
Y_mag_new = abs(Y_new) / N_new;
f_axis_new = (0:N_new-1) * (Fs_new / N_new);

figure;
stem(f_axis_new, Y_mag_new, 'm', 'LineWidth', 1.5);
grid on;
title('Амплитудный спектр (80 Hz)');
xlabel('Частота f, (Гц)');
ylabel('Амплитуда');

% Восстановление сигнала
figure;
plot(t, y, 'b', 'LineWidth', 2);
hold on;
plot(t_discrete_new, y_discrete_new, 'g-o', 'LineWidth', 1.5);
hold off;
grid on;
legend('Исходный сигнал', 'Восстановленный (80 Hz)');
title('Сравнение исходного и восстановленного сигнала');
xlabel('Время t, (с)');
ylabel('Амплитуда');
xlim([0 0.5]);