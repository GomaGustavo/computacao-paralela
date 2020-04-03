/*
Tempo sequencial:
   real    0m0.150s
   user    0m0.150s
   sys     0m0.000s

Tempo paralelo:
   real    0m0.093s
   user    0m0.350s
   sys     0m0.010s

Tempo paralelo (vetorizado):
   real    0m0.608s
   user    0m2.217s
   sys     0m0.013s
*/

#include <stdio.h>
#include <stdlib.h>

int main() {
   int i, j, n = 30000; 

   // Allocate input, output and position arrays
   int *in = (int*) calloc(n, sizeof(int));
   int *pos = (int*) calloc(n, sizeof(int));   
   int *out = (int*) calloc(n, sizeof(int));   

   // Initialize input array in the reverse order
   for(i = 0; i < n; i++) {
      in[i] = n - i;  
   }

   // Silly sort (you have to make this code parallel)
   for(i = 0; i < n; i++) {
      int soma = 0;

      #pragma omp parallel for simd reduction(+:soma)
      for(j = 0; j < n; j++) {
         if(in[i] > in[j]) {
            soma++;
         }
      }

      pos[i] = soma;
   }

   // Move elements to final position
   #pragma omp parallel for simd
   for(i = 0; i < n; i++) {
      out[pos[i]] = in[i];
   }

   // Check if answer is correct
   for(i = 0; i < n; i++) {
      if(i + 1 != out[i]) {
         printf("test failed\n");
         exit(0);
      }
   }

   printf("test passed\n"); 
}  