# Computação Paralela
## Tarefa 10 - Avaliação de Desempenho do Crivo Paralelo

> Gustavo Henrique Gomes de Araújo
>
> Matrícula 496952

### Comparação de versões de otimização

|  | Sequancial | Paralelo (estático) | Paralelo sem critical (estático) | Paralelo sem critical (dinâmico) | Paralelo sem critical, com reduce (dinâmico) |
|:-|:-:|:-:|:-:|:-:|:-:|
| Task clock (utilização) | 0,997 | 1,696 | 1,990 | 1,970 | 1,990
| Stalled cycles frontend (ciclos ociosos na ULA) | N/A | N/A | N/A | N/A | N/A |
| Stalled cycles backend (ciclos ociosos na busca de instrução) | N/A | N/A | N/A | N/A | N/A |
| Instructions (instruções por ciclo) | 2,98 | 0,44 | 3,16 | 3,25 | 3,34 |
| LLC load misses (taxa de falta na cache L3) | 52,59% | 0,02% | 19,29% | 16,36% | 0,27% |
| Time elapsed (tempo total de execução) | 0,25 | 1,42 | 0,13 | 0,14 | 0,12 |

O que foi percebido de possibilidade é a utilização de um reduce no for interno do bloco código que move os elementos para a posição final.

```c
// Move elements to final position
for(i=0; i < n; i++) 
{
    int pos_final = 0; 
    
    #pragma omp reduce(+:pos_final) // <-- Adição desse comando
    for(j=0; j < nthreads; j++) 
        pos_final += pos[j][i];

    out[n-pos_final] = in[i];
}
```

É difícil identificar pelo resultado do perf informações que possam ajudar a encontrar melhorias possíveis ou gargalos, já que a cada execução o valor do `LLC-load-misses` mudava consideravelmente. Em alguns testes consegui aumentar o `task-clock` para até 1.999, mas o tempo de execução aumentou absurdamente, não havendo melhoria.