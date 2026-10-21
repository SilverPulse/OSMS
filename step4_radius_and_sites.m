% =========================================================================
% ФАЙЛ 4: Расчет радиуса сот и количества базовых станций
% =========================================================================

% Исходные данные
Area_Macro_km2 = 100; % Площадь для макросети (COST 231 и Walfisch-Ikegami)
Area_Micro_km2 = 4;   % Площадь для микросети (UMiNLOS)

MAPL_UL = 126.70;     % Максимальные потери UL
MAPL_DL = 144.09;     % Максимальные потери DL

[val_U, idx_U] = unique(PL_UMiNLOS);
[val_C, idx_C] = unique(PL_COST231);
[val_W, idx_W] = unique(L_Walfisch);

% -------------------------------------------------------------------------
% 1. Находим радиусы в UL и DL для всех трех моделей (в метрах)
% -------------------------------------------------------------------------
% UMiNLOS
R_UL_UMiNLOS_m = interp1(val_U, d_m(idx_U), MAPL_UL);
R_DL_UMiNLOS_m = interp1(val_U, d_m(idx_U), MAPL_DL);
R_min_UMiNLOS_m = min(R_UL_UMiNLOS_m, R_DL_UMiNLOS_m);

% COST 231 Hata
R_UL_COST231_m = interp1(val_C, d_m(idx_C), MAPL_UL);
R_DL_COST231_m = interp1(val_C, d_m(idx_C), MAPL_DL);
R_min_COST231_m = min(R_UL_COST231_m, R_DL_COST231_m); 

% Walfisch-Ikegami
R_UL_Walfisch_m = interp1(val_W, d_m(idx_W), MAPL_UL);
R_DL_Walfisch_m = interp1(val_W, d_m(idx_W), MAPL_DL);
R_min_Walfisch_m = min(R_UL_Walfisch_m, R_DL_Walfisch_m);

% Переводим итоговые минимальные радиусы в километры для расчета площадей
R_min_UMiNLOS_km = R_min_UMiNLOS_m / 1000;
R_min_COST231_km = R_min_COST231_m / 1000;
R_min_Walfisch_km = R_min_Walfisch_m / 1000;

% -------------------------------------------------------------------------
% 2. Расчет площади одной 3-секторной базовой станции (S = 1.95 * R^2)
% -------------------------------------------------------------------------
S_site_UMiNLOS = 1.95 * (R_min_UMiNLOS_km^2);
S_site_COST231 = 1.95 * (R_min_COST231_km^2);
S_site_Walfisch = 1.95 * (R_min_Walfisch_km^2);

% -------------------------------------------------------------------------
% 3. Расчет требуемого количества базовых станций
% -------------------------------------------------------------------------
N_sites_UMiNLOS = ceil(Area_Micro_km2 / S_site_UMiNLOS);
N_sites_COST231 = ceil(Area_Macro_km2 / S_site_COST231);
N_sites_Walfisch = ceil(Area_Macro_km2 / S_site_Walfisch);


fprintf('=== РЕЗУЛЬТАТЫ РАССЧЁТОВ ===\n');
fprintf('Модель UMiNLOS (Микро/Фемтосоты, indoor):\n');
fprintf(' - Радиус UL: %.1f м | Радиус DL: %.1f м\n', R_UL_UMiNLOS_m, R_DL_UMiNLOS_m);
fprintf(' - Итоговый радиус соты: %.1f м\n', R_min_UMiNLOS_m);
fprintf(' - Площадь 1 сайта: %.5f кв.км\n', S_site_UMiNLOS);
fprintf(' - Кол-во базовых станций на %d кв.км: %d шт.\n\n', Area_Micro_km2, N_sites_UMiNLOS);

fprintf('Модель COST 231 Hata (Макросоты):\n');
fprintf(' - Радиус UL: %.1f м | Радиус DL: %.1f м\n', R_UL_COST231_m, R_DL_COST231_m);
fprintf(' - Итоговый радиус соты: %.1f м\n', R_min_COST231_m);
fprintf(' - Площадь 1 сайта: %.5f кв.км\n', S_site_COST231);
fprintf(' - Кол-во базовых станций на %d кв.км: %d шт.\n\n', Area_Macro_km2, N_sites_COST231);

fprintf('Модель Walfisch-Ikegami (Макросоты, манхэттенская застройка):\n');
fprintf(' - Радиус UL: %.1f м | Радиус DL: %.1f м\n', R_UL_Walfisch_m, R_DL_Walfisch_m);
fprintf(' - Итоговый радиус соты: %.1f м\n', R_min_Walfisch_m);
fprintf(' - Площадь 1 сайта: %.5f кв.км\n', S_site_Walfisch);
fprintf(' - Кол-во базовых станций на %d кв.км: %d шт.\n', Area_Macro_km2, N_sites_Walfisch);