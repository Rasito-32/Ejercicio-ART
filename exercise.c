#include <stdio.h>
#include <stdlib.h>
#include <time.h>

int uniform_rand(int n);
int random_serven();

int main()
{
    srand(time(NULL));
    int numeros_sacados[10000];
    int terminado = 0;
    for(int i = 0; i < 10000; i ++)
    {
        numeros_sacados[i] = random_seven();
    }

    for(int i = 0; i < 7; i ++)
    {
        int output = 0;
        for(int j = 0; j < 10000; j++)
        {
            if(numeros_sacados[j] == i + 1)
                output ++;
        }
        float res = (float) (output/100);
        printf("Apariciones del %i: %f\n", i + 1, res);
    }
}

int uniform_rand(int n) {
    int r;
    int limit = RAND_MAX - (RAND_MAX % n);
    do {
        r = rand();
    } while (r >= limit);
    return r % n;
}

int random_seven()      //función que devuelve un aleatorio del 1 al 7
{
      int num;
    do {
        int a = uniform_rand(5);
        int b = uniform_rand(5); 
        num = a * 5 + b;     
    } while (num >= 21);         
    return num % 7 + 1;               
}
