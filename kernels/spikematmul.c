#include <stdio.h>

void matmul(int a[][64], int b[], int c[]);
void spikeacc(int mem[], int c[], int d[]);


void matmul(int a[][64], int b[], int c[]){
    for(unsigned i=0; i<64; i++){
        for(unsigned j=0; j<64; j++){
            for(unsigned k=0; k<64; k++){
                c[k] += b[i] * a[i][j];
            }
        }
    }
}

int main()
{

    int a[64][64];
    int b[64];
    int c[64];
    int d[64];

    int mem[64];

    for(unsigned i=0; i<3; i++){
        matmul(a,b,c);
        spikeacc(mem, c, d);
    }
        // printf("Hello, world!  Pi is approximately %d.\n", c[0]);

}

void spikeacc(int mem[], int c[], int d[]){
    for(unsigned i=0; i<64; i++){
        mem[i] *= .875;
        mem[i] += c[i];
        if(mem[i] > 1){
            d[i] = 1;
            mem[i] = 0;
        }
    }
}