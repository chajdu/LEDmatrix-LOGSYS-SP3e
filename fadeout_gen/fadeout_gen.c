#include <stdio.h>
#include <stdlib.h>
#include <string.h>


FILE *file_out;

const double fadeout_step = 0.01;
double fadeout_curr = 1;
int cnt = 0;


int main(int argc, char *argv[]) {
    if ( argc != 2 ) {
        printf("Usage: %s [output file name]\n", argv[0]);
        
        return -1;
    }
    
    file_out = fopen(argv[1], "wt");

    fprintf(file_out, "       ");
    
    // Fade out
    while (fadeout_curr > 0) {
        fprintf(file_out, " X\"%02X\",", int(fadeout_curr * 255));
        
        if ( ++cnt % 16 == 0 )
            fprintf(file_out, "\n       ");
        
        fadeout_curr -= fadeout_step;
    }
    
    // Fade back in
    do {
        fprintf(file_out, " X\"%02X\",", int(fadeout_curr * 255));

        if ( ++cnt % 16 == 0 )
            fprintf(file_out, "\n       ");
        
        fadeout_curr += fadeout_step;
    } while (fadeout_curr < 1);
    
    fprintf(file_out, "\n");
    fclose(file_out);
    
    return 0;
}