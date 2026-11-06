// Пункты 3 и 4: Генерация второй последовательности Голда и взаимная корреляция

#include <stdio.h>

int shift_reg(int reg[], int tap1, int tap2) {
    int tail_bit = reg[4];

    int new_bit = reg[tap1] ^ reg[tap2];

    for (int i = 4; i > 0; i--) {
        reg[i] = reg[i - 1];
    }

    reg[0] = new_bit;

    return tail_bit;
}

int main() {
    // Первая последовательность (из пунктов 1 и 2: X = 24, Y = 31)

    int reg_x1[5] = {1, 1, 0, 0, 0}; // 24 в двоичном виде
    int reg_y1[5] = {1, 1, 1, 1, 1}; // 31 в двоичном виде
    int gold_code1[31];

    for (int i = 0; i < 31; i++) {
        int out_x = shift_reg(reg_x1, 3, 4);
        int out_y = shift_reg(reg_y1, 1, 4);
        gold_code1[i] = out_x ^ out_y;
    }

    // Вторая последовательность (по заданию: X = X + 1 = 25, Y = Y - 5 = 26)
    int reg_x2[5] = {1, 1, 0, 0, 1}; // 25 в двоичном виде: 16 + 8 + 1
    int reg_y2[5] = {1, 1, 0, 1, 0}; // 26 в двоичном виде: 16 + 8 + 2
    int gold_code2[31];

    for (int i = 0; i < 31; i++) {
        int out_x = shift_reg(reg_x2, 3, 4);
        int out_y = shift_reg(reg_y2, 1, 4);
        gold_code2[i] = out_x ^ out_y;
    }

    printf("Код Голда 1 (X=24, Y=31): ");
    for (int i = 0; i < 31; i++) {
        printf("%d", gold_code1[i]);
    }
    printf("\n");

    printf("Код Голда 2 (X=25, Y=26): ");
    for (int i = 0; i < 31; i++) {
        printf("%d", gold_code2[i]);
    }
    printf("\n\n");


    // Расчет взаимной корреляции
    int matches = 0;
    int none_matches = 0;

    for (int i = 0; i < 31; i++) {
        if (gold_code1[i] == gold_code2[i]) {
            matches++;
        } else {
            none_matches++;
        }
    }

    double cross_corr = (double)(matches - none_matches) / 31.0;

    printf("---- Результаты взаимной корреляции ----\n");
    printf("Совпадений бит   : %d\n", matches);
    printf("Несовпадений бит : %d\n", none_matches);
    printf("Взаимная корреляция: %+.4f\n", cross_corr);

    return 0;
}