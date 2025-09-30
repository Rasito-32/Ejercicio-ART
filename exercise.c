int random_five();          //Función que nos devuelve de manera aleatoría un número del 1 al 5 sin repetirse

int random_seven()      //función que devuelve un aleatorio del 1 al 7
{
    int flag = 0;
    int result = 0;
    while (flag)
    {
        result = (random_five() - 1) * 5;   //25 posibilidades
        if(result <= 21)                    //Si está dentro del 21, éxito
            flag = 1;
    }
    
    return result;
}

int main()
{
    int numeros_sacados[7] = {0, 0, 0, 0, 0, 0, 0};
    int terminado = 0;

    while (terminado != 7)
    {
        int repetido = 0;
        while (repetido)
        {
            int res = random_seven();
            int i = 0;
            for (i = 0; i < terminado; i++)
            {
                if(res == numeros_sacados[i])
                    i = terminado;
            }
            if(res != numeros_sacados[terminado] && i == terminado)
            {
                repetido = 1;
                numeros_sacados[terminado] = res;
            }
        }
        terminado ++;
    }
}