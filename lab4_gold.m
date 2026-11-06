% =========================================================================
% Лабораторная работа №4: Коды Голда и корреляция (Вариант 24)
% =========================================================================
clear; clc; close all;

% Исходные последовательности (X=24, Y=31 и X=25, Y=26)
gold1_bits = [1 1 1 0 0 0 0 0 1 1 1 1 1 0 1 1 0 0 1 0 0 0 1 1 0 1 1 1 1 0 1];
gold2_bits = [1 1 0 0 0 0 0 0 1 0 1 1 0 1 0 1 1 1 1 0 1 1 1 0 1 0 1 0 1 0 1];

N = length(gold1_bits); % 31 бит

% Перевод в полярный формат
s1 = 1 - 2 * gold1_bits;
s2 = 1 - 2 * gold2_bits;

% Вычисление автокорреляции и взаимной корреляции
[R_auto, lags_auto] = xcorr(s1, s1, 'normalized');
[R_cross, lags_cross] = xcorr(s1, s2, 'normalized');

zero_lag_idx = find(lags_cross == 0);
cross_corr_zero = R_cross(zero_lag_idx);

fprintf('--- Результаты в MATLAB ---\n');
fprintf('Пик автокорреляции при lag = 0 : %+.4f\n', R_auto(lags_auto == 0));
fprintf('Взаимная корреляция при lag = 0: %+.4f\n', cross_corr_zero);

figure('Name', 'Корреляционные свойства кодов Голда', 'Color', 'w', 'Position', [100, 100, 900, 600]);

subplot(2, 1, 1);
stem(lags_auto, R_auto, 'filled', 'LineWidth', 1.5, 'MarkerSize', 6, 'Color', '#0072BD');
grid on;
xlabel('Величина задержки (lag, биты)');
ylabel('R_{auto}(\tau)');
title('Функция автокорреляции кода Голда 1 (X=24, Y=31)');
xlim([-30 30]);
ylim([-0.5 1.1]);
yline(0, 'k--', 'LineWidth', 1);

subplot(2, 1, 2);
stem(lags_cross, R_cross, 'filled', 'LineWidth', 1.5, 'MarkerSize', 6, 'Color', '#D95319');
grid on;
xlabel('Величина задержки (lag, биты)');
ylabel('R_{cross}(\tau)');
title('Функция взаимной корреляции кодов Голда 1 и 2');
xlim([-30 30]);
ylim([-0.5 1.1]);
yline(0, 'k--', 'LineWidth', 1);