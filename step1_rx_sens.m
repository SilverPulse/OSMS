% =========================================================================
% ФАЙЛ 1: Расчет чувствительности приемников (RxSens)
% =========================================================================

% --- Исходные данные из методички ---
BW_UL_MHz = 10;      % Полоса частот в UL, МГц
BW_DL_MHz = 20;      % Полоса частот в DL, МГц

NF_BS = 2.4;         % Коэффициент шума приемника BS, дБ
NF_UE = 6;           % Коэффициент шума приемника пользователя, дБ

SINR_UL = 4;         % Требуемое отношение SINR для UL, дБ
SINR_DL = 2;         % Требуемое отношение SINR для DL, дБ

% Перевод мегагерц в герцы
BW_UL = BW_UL_MHz * 1e6; 
BW_DL = BW_DL_MHz * 1e6;


% 1. Расчет теплового шума (Thermal Noise)
% Подсказка: используй формулу -174 + 10 * log10(...)
ThermalNoise_UL = -174 + 10 * log10(BW_UL)
ThermalNoise_DL = -174 + 10 * log10(BW_DL)

% 2. Расчет чувствительности (RxSens)
% Подсказка: просуммируй коэффициент шума, тепловой шум и требуемый SINR
RxSens_BS = NF_BS + ThermalNoise_UL + SINR_UL 
RxSens_UE = NF_UE + ThermalNoise_DL + SINR_DL

fprintf('Thermal Noise UL: %.2f дБм\n', ThermalNoise_UL);
fprintf('Thermal Noise DL: %.2f дБм\n', ThermalNoise_DL);
fprintf('RxSens BS (UL): %.2f дБм\n', RxSens_BS);
fprintf('RxSens UE (DL): %.2f дБм\n', RxSens_UE);