#include <stdio.h>

void layer1(int a[][64], int b[], int c[]);
void layer2(int a[][16], int b[], int c[]);
void spikeacclayer1(int mem[], int c[], int d[]);
void spikeacclayer2(int mem[], int c[], int d[]);


void layer1(int a[][64], int b[], int c[]){
    for(unsigned i=0; i<64; i++){
        for(unsigned j=0; j<64; j++){
            for(unsigned k=0; k<64; k++){
                c[k] += b[i] * a[i][j];
            }
        }
    }
}

void layer2(int a[][16], int b[], int c[]){
    for(unsigned i=0; i<64; i++){
        for(unsigned j=0; j<16; j++){
            for(unsigned k=0; k<16; k++){
                c[k] += b[i] * a[i][j];
            }
        }
    }
}

int main()
{

    int a1[64][64];
    int b1[64];
    int c1[64];
    int d1[64];

    int mem1[64];


    for(unsigned i=0; i<3; i++){
        layer1(a1,b1,c1);
        spikeacclayer1(mem1, c1, d1);
    }

    int a2[64][16];
    int c2[16];
    int d2[16];

    int mem2[16];


    for(unsigned i=0; i<3; i++){
        layer2(a2,d1,c2);
        spikeacclayer2(mem2, c2, d2);
    }


}

void spikeacclayer1(int mem[], int c[], int d[]){
    for(unsigned i=0; i<64; i++){
        mem[i] *= .875;
        mem[i] += c[i];
        if(mem[i] > 1){
            d[i] = 1;
            mem[i] = 0;
        }
    }
}

void spikeacclayer2(int mem[], int c[], int d[]){
    for(unsigned i=0; i<16; i++){
        mem[i] *= .875;
        mem[i] += c[i];
        if(mem[i] > 1){
            d[i] = 1;
            mem[i] = 0;
        }
    }
}