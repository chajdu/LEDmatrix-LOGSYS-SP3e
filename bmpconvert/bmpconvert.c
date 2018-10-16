// Code based on: http://www.fileformat.info/format/bmp/egff.htm
// Tweaked based on https://en.wikipedia.org/wiki/BMP_file_format
// Designed to read a BMP Version 3 and dump its color channels separately for use in the LED matrix driver code

#include <stdio.h>
#include <stdlib.h>
#include <string.h>


typedef struct __attribute__((__packed__)) BMPFileHeader_t {
    uint16_t FileType;          // File type, always 4D42h ("BM")
    uint32_t FileSize;          // Size of the file in bytes
    uint16_t Reserved1;         // Always 0
    uint16_t Reserved2;         // Always 0
    uint32_t BitmapOffset;      // Starting position of image data in bytes
} BMPFileHeader_t;

typedef struct __attribute__((__packed__)) BMPHeader_t {
    uint32_t Size;              // Size of this header in bytes
    uint32_t Width;             // Image width in pixels
    uint32_t Height;            // Image height in pixels
    uint16_t Planes;            // Number of color planes
    uint16_t BitsPerPixel;      // Number of bits per pixel
    uint32_t Compression;       // Compression methods used
    uint32_t SizeOfBitmap;      // Size of bitmap in bytes
    uint32_t HorzResolution;    // Horizontal resolution in pixels per meter
    uint32_t VertResolution;    // Vertical resolution in pixels per meter
    uint32_t ColorsUsed;        // Number of colors in the image
    uint32_t ColorsImportant;   // Minimum number of important colors
} BMPHeader_t;


FILE *file_in, *file_out_R, *file_out_G, *file_out_B;
BMPFileHeader_t BMPFileHeader;
BMPHeader_t BMPHeader;


int main(int argc, char *argv[]) {
    if(argc != 2) {
        printf("Usage: %s [input file]\n", argv[0]);
        
        exit(1);
    }

    file_in = fopen(argv[1], "rb");

    
    // Read BMP file header
    fread(&BMPFileHeader, sizeof(BMPFileHeader), 1, file_in);

    printf("------------------------------\n");
    printf("-- BMP file header properties\n");
    printf("------------------------------\n");
    printf("File type: %X\n", BMPFileHeader.FileType);
    printf("File size: %d\n", BMPFileHeader.FileSize);
    printf("Bitmap offset: %d\n", BMPFileHeader.BitmapOffset);

    // Checks
    if ( BMPFileHeader.FileType != 0x4D42 ) {
        printf("\nNot a bitmap, unsupported file type!\n");
        
        fclose(file_in);
        return(0);
    }
    
    if ( BMPFileHeader.BitmapOffset != 54 ) {
        printf("\nBitmap offset != 54, unsupported file type!\n");
        
        fclose(file_in);
        return(0);
    }
    

    // Read BMP header
    fread(&BMPHeader, sizeof(BMPHeader), 1, file_in);

    printf("------------------------------\n");
    printf("-- BMP header properties\n");
    printf("------------------------------\n");
    printf("Header size: %d\n", BMPHeader.Size);
    printf("Width: %d\n", BMPHeader.Width);
    printf("Height: %d\n", BMPHeader.Height);
    printf("Planes: %d\n", BMPHeader.Planes);
    printf("BitsPerPixel: %d\n", BMPHeader.BitsPerPixel);
    printf("Compression: %d\n", BMPHeader.Compression);
    printf("SizeOfBitmap: %d\n", BMPHeader.SizeOfBitmap);
    printf("HorzResolution: %d\n", BMPHeader.HorzResolution);
    printf("VertResolution: %d\n", BMPHeader.VertResolution);
    printf("ColorsUsed: %d\n", BMPHeader.ColorsUsed);
    printf("ColorsImportant: %d\n", BMPHeader.ColorsImportant);
       
    // Checks
    if ( BMPHeader.Size != 40 ) {
        printf("\nBMP header size != 40, unsupported file type!\n");
        
        fclose(file_in);
        return(0);
    }

    if ( BMPHeader.BitsPerPixel != 24 ) {
        printf("\nBMP bits per pixel != 24, unsupported file type!\n");
        
        fclose(file_in);
        return(0);
    }

    if ( BMPHeader.Height < 0 ) {
        printf("\nBMP height < 0, not upside-down BMP, unsupported file type!\n");
        
        fclose(file_in);
        return(0);
    }
    
    
    // To be fair, this code is only intended to be used with 64x32 bitmaps, hence the reading buffers are allocated this way and the readout code is also adapted for this...
    // In this case, row padding is not an issue
    
    if ( ! ( (BMPHeader.Width == 64) && (BMPHeader.Height == 32) ) ) {
        printf("\nBMP size != 64x32, unsupported file type!\n");
        
        fclose(file_in);
        return(0);
    }
    
    unsigned char BMP_R[64][32], BMP_G[64][32], BMP_B[64][32];
    
    for ( int row = 31; row >= 0; row-- )
        for ( int col = 0; col < 64; col++ ) {
            fread(&BMP_B[col][row], sizeof(unsigned char), 1, file_in);
            fread(&BMP_G[col][row], sizeof(unsigned char), 1, file_in);
            fread(&BMP_R[col][row], sizeof(unsigned char), 1, file_in);
        }
    
    fclose(file_in);
    
    
    // Write output files
    int cnt = 0;
    
    file_out_R = fopen("BRAM_top_R.vhd", "wb");
    file_out_G = fopen("BRAM_top_G.vhd", "wb");
    file_out_B = fopen("BRAM_top_B.vhd", "wb");
    
    for ( int row = 0; row < 16; row++ ) {        
        for ( int col = 0; col < 64; col++ ) {
            if ( cnt == 0 ) {
                fprintf(file_out_R, "       ");
                fprintf(file_out_G, "       ");
                fprintf(file_out_B, "       ");
            }
            
            fprintf(file_out_R, " X\"%02X\",", BMP_R[col][row]);
            fprintf(file_out_G, " X\"%02X\",", BMP_G[col][row]);
            fprintf(file_out_B, " X\"%02X\",", BMP_B[col][row]);
            
            if ( ++cnt == 64 ) {
                cnt = 0;

                fprintf(file_out_R, "\n");
                fprintf(file_out_G, "\n");
                fprintf(file_out_B, "\n");
            }
        }
    }

    fclose(file_out_R);
    fclose(file_out_G);
    fclose(file_out_B);
    
    
    cnt = 0;

    file_out_R = fopen("BRAM_bot_R.vhd", "wb");
    file_out_G = fopen("BRAM_bot_G.vhd", "wb");
    file_out_B = fopen("BRAM_bot_B.vhd", "wb");
    
    for ( int row = 16; row < 32; row++ ) {
        for ( int col = 0; col < 64; col++ ) {
            if ( cnt == 0 ) {
                fprintf(file_out_R, "       ");
                fprintf(file_out_G, "       ");
                fprintf(file_out_B, "       ");
            }
            
            fprintf(file_out_R, " X\"%02X\",", BMP_R[col][row]);
            fprintf(file_out_G, " X\"%02X\",", BMP_G[col][row]);
            fprintf(file_out_B, " X\"%02X\",", BMP_B[col][row]);
            
            if ( ++cnt == 64 ) {
                cnt = 0;

                fprintf(file_out_R, "\n");
                fprintf(file_out_G, "\n");
                fprintf(file_out_B, "\n");
            }
        }
    }

    fclose(file_out_R);
    fclose(file_out_G);
    fclose(file_out_B);

    return 0;
}
