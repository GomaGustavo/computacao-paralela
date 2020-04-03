#include <stdio.h>

long long num_passos = 1000000000;

int main(){
    int i, soma = 0.0;

    #pragma omp parallel for simd reduction(+:soma)
    for(i = 0; i < num_passos; i++){
        soma++;
    }

    printf("soma = %d\n", soma);
    return 0;
}