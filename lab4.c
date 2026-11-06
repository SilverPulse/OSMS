// Пункты 1 и 2  Автокорреляция и код Голда

#include <stdio.h>

int shift_reg(int reg[], int tap1, int tap2){
    int tail_bit = reg[4];

    int new_bit = reg[tap1] ^ reg[tap2];

    for (int i=4; i>0; i--){
        reg[i] = reg[i-1];

    }

    reg[0] = new_bit;

    return tail_bit;

}

int main(){
    int reg_x[5] = {1,1,0,0,0};
    int reg_y[5] = {1,1,1,1,1};

    int gold_code[31];

    printf("Старт генерации кода Голда...\n");

    for (int i=0; i<31; i++){
        int out_x = shift_reg(reg_x, 3, 4);
        int out_y = shift_reg(reg_y, 1, 4);

        gold_code[i] = out_x ^ out_y;
    }

    printf("Сгенерированный код Голда: ");
    for (int i=0; i<31; i++){
        printf("%d", gold_code[i]);
    }
    printf("\n");

    printf("\n--------------- Таблица автокорреляции --------------\n");
    printf("Сдвиг | Биты последовательности        | Автокорреляция\n");
    printf("------+--------------------------------+---------------\n");

    for (int s = 0; s < 31;s++){
        int matches = 0;
        int none_matches = 0;

        printf("%5d | ", s);

        for (int i=0; i<31; i++){
            int shifted_bits = gold_code[(i+s)%31];
            printf("%d", shifted_bits);

            if (gold_code[i] == shifted_bits){
                matches++;
            }   else{
                none_matches++;
            }
        }
        
        double autocorr = (double)(matches - none_matches)/ 31.0;
        printf(" | %+.4f\n", autocorr);
    }


    return 0;
}