#include <stdio.h>
#include <string.h>
#include <stdlib.h>

int main(int argc ,char *argv[])
{
  FILE *infile, *outfile;
  char infname[1024];
  char outfname[1024];
  char fw_name[128];
  char *src_dir;

  int i=0;

  memset(infname,0,1024);
  memset(outfname,0,1024);
  memset(fw_name, 0, 128);

  src_dir = (char *)getenv("SRC_DIR");

  if(!src_dir) {
    printf("Environment value \"SRC_DIR\" not export \n");
    return -1;
  }

  if(strlen(src_dir) > (sizeof(infname)-100)) {
    printf("Environment value \"SRC_DIR\" is too long!\n");
    return -1;
  }

  strcat(infname,src_dir);
  strcat(outfname,src_dir);

  strcat(infname,  "/mcu/bin/MT7601.bin");
  strcat(outfname, "/include/mcu/MT7601_firmware.h");
  strcat(fw_name,  "MT7601_FirmwareImage");

  infile = fopen(infname,"r");

  if(infile == (FILE *) NULL) {
    printf("Can't read file %s\n",infname);
    return -1;
  }

  outfile = fopen(outfname,"w");
  if(outfile == (FILE *) NULL) {
	  fclose(infile);
    printf("Can't open write file %s\n", outfname);
    return -1;
  }

  fputs("/* AUTO GEN PLEASE DO NOT MODIFY IT */\n",outfile);
  fprintf(outfile, "UCHAR %s[] = {\n", fw_name);

  while(1)
  {
    unsigned char byte = getc(infile);
    if(feof(infile))
	    break;

    if(i>=16) {
	    fputs("\n", outfile);
	    i = 0;
    }
		fprintf(outfile, "0x%02x, ", byte);    
    i++;
  }

  fputs("} ;\n", outfile);
  fclose(infile);
  fclose(outfile);
  exit(0);
}
