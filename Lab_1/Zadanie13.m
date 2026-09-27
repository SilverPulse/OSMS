% Задание 13: Влияние разрядности АЦП на сигнал и спектр

% Параметры сигнала по варианту (Вариант 24)
f = 10; 
A = 5;  
phase = pi / 7; 
Fs_adc = 200;
t = 0:1/Fs_adc:1; 
y = A * sin(2 * pi * f * t + phase);

bits = [3, 4, 5, 6]; % Требуемые разрядности АЦП

figure;
for i = 1:length(bits)
    b = bits(i);
    levels = 2^b - 1; % Вычисляем число уровней (7 для 3 бит и т.д.)
    
    % Нормализуем сигнал (от 0 до 1), масштабируем до levels и округляем
    y_norm = (y - min(y)) / (max(y) - min(y)); 
    y_quant_int = round(y_norm * levels); 
    
    % Защита от выхода за границы диапазона
    y_quant_int(y_quant_int > levels) = levels;
    y_quant_int(y_quant_int < 0) = 0;
    
    % Возвращаем квантованный сигнал в исходный масштаб для вычисления ошибки
    y_quant = (y_quant_int / levels) * (max(y) - min(y)) + min(y);
    
    % Вычисляем и выводим среднюю ошибку квантования
    error_quant = mean(abs(y - y_quant));
    disp(['Средняя ошибка квантования для ', num2str(b), ' бит: ', num2str(error_quant)]);
    
  % Построение сигнала во времени
    subplot(4, 2, 2*i - 1);
    plot(t, y, 'b', t, y_quant, 'r', 'LineWidth', 1.2);
    title([num2str(b), '-битный АЦП. Сигнал во времени']);
    xlabel('Время, [с]');
    ylabel('Амплитуда'); 
    grid on;
    
    % Построение спектра
    Y_q = fft(y_quant);
    Y_q_mag = abs(Y_q) / length(y_quant);
    f_axis = (0:length(y_quant)-1) * (Fs_adc / length(y_quant));
    
    subplot(4, 2, 2*i);
    stem(f_axis(1:floor(end/2)), Y_q_mag(1:floor(end/2)), 'm', 'filled');
    title([num2str(b), '-битный АЦП. Амплитудный спектр']);
    xlabel('Частота, [Гц]');
    ylabel('Амплитуда');
    xlim([0 50]); 
    grid on;
end