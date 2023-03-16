#include <stdio.h>

void matmul(int a[][128], int b[], int c[]);



void matmul(int a[][128], int b[], int c[]){
    for(unsigned i=0; i<128; i++){
        for(unsigned j=0; j<128; j++){
            for(unsigned k=0; k<128; k++){
                c[k] += b[i] * a[i][j];
            }
        }
    }
}

int main()
{

    int a[128][128];
    int b[128];
    int c[128];

    a[0][0] = 1;
    b[0] = 1;

    matmul(a,b,c);
    // printf("Hello, world!  Pi is approximately %d.\n", c[0]);

}


