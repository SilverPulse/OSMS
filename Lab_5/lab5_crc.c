#include <stdio.h>
#include <stdlib.h>

#define POLY_LEN 8
#define CRC_LEN  (POLY_LEN - 1)

void calc_crc(const int msg[], int msg_len, const int poly[], int poly_len, int crc_out[]) {
    int crc_len = poly_len - 1;

    int *temp = (int *)malloc(msg_len * sizeof(int));
    for (int i = 0; i < msg_len; i++) {
        temp[i] = msg[i];
    }

    int steps = msg_len - crc_len;
    for (int i = 0; i < steps; i++) {
        if (temp[i] == 1) {
            for (int j = 0; j < poly_len; j++) {
                temp[i + j] = temp[i + j] ^ poly[j];
            }
        }
    }

    for (int i = 0; i < crc_len; i++) {
        crc_out[i] = temp[msg_len - crc_len + i];
    }

    free(temp);
}

int check_packet(const int packet[], int total_len, const int poly[], int poly_len) {
    int crc_len = poly_len - 1;
    int *remainder = (int *)malloc(crc_len * sizeof(int));

    calc_crc(packet, total_len, poly, poly_len, remainder);

    int has_error = 0;
    for (int i = 0; i < crc_len; i++) {
        if (remainder[i] != 0) {
            has_error = 1;
            break;
        }
    }

    free(remainder);
    return has_error;
}

int main() {
    int poly[POLY_LEN] = {1, 0, 1, 1, 1, 1, 0, 0};

    int data44_len = 20 + 24;
    int total44_len = data44_len + CRC_LEN;

    int tx_input44[51] = {0};
    for (int i = 0; i < data44_len; i++) {
        tx_input44[i] = (i % 3 == 0 || i % 5 == 0) ? 1 : 0;
    }

    int crc44[CRC_LEN] = {0};
    calc_crc(tx_input44, total44_len, poly, POLY_LEN, crc44);

    int packet44[51] = {0};
    for (int i = 0; i < data44_len; i++) {
        packet44[i] = tx_input44[i];
    }
    for (int i = 0; i < CRC_LEN; i++) {
        packet44[data44_len + i] = crc44[i];
    }

    printf("=== Пакет 44 бита (Вариант 24) ===\n");
    printf("CRC (7 бит): ");
    for (int i = 0; i < CRC_LEN; i++) {
        printf("%d", crc44[i]);
    }
    printf("\n");

    int err44 = check_packet(packet44, total44_len, poly, POLY_LEN);
    printf("Проверка принятого пакета (без ошибок): %s\n\n",
           err44 ? "ОШИБКА ОБНАРУЖЕНА" : "ОШИБОК НЕТ");

    int data250_len = 250;
    int total250_len = data250_len + CRC_LEN;

    int tx_input250[257] = {0};
    for (int i = 0; i < data250_len; i++) {
        tx_input250[i] = ((i * 7 + 3) % 5) % 2;
    }

    int crc250[CRC_LEN] = {0};
    calc_crc(tx_input250, total250_len, poly, POLY_LEN, crc250);

    int packet250[257] = {0};
    for (int i = 0; i < data250_len; i++) {
        packet250[i] = tx_input250[i];
    }
    for (int i = 0; i < CRC_LEN; i++) {
        packet250[data250_len + i] = crc250[i];
    }

    printf("=== Пакет 250 бит (Вариант 24) ===\n");
    printf("CRC (7 бит): ");
    for (int i = 0; i < CRC_LEN; i++) {
        printf("%d", crc250[i]);
    }
    printf("\n");

    int err250 = check_packet(packet250, total250_len, poly, POLY_LEN);
    printf("Проверка принятого пакета (без ошибок): %s\n\n",
           err250 ? "ОШИБКА ОБНАРУЖЕНА" : "ОШИБОК НЕТ");

    int detected_errors = 0;
    int undetected_errors = 0;

    for (int pos = 0; pos < total250_len; pos++) {
        int corrupted[257];
        for (int i = 0; i < total250_len; i++) {
            corrupted[i] = packet250[i];
        }

        corrupted[pos] = corrupted[pos] ^ 1;

        if (check_packet(corrupted, total250_len, poly, POLY_LEN)) {
            detected_errors++;
        } else {
            undetected_errors++;
        }
    }

    printf("=== Результаты теста одиночных ошибок (всего итераций: %d) ===\n", total250_len);
    printf("Ошибок обнаружено    : %d\n", detected_errors);
    printf("Ошибок НЕ обнаружено : %d\n", undetected_errors);

    return 0;
}
