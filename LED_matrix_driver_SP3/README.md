The code running on the LOGSYS SP3E itself.
Toplevel: LED_matrix_driver_SP3.vhd
Functionality:
- Displays the pixel values contained in the BRAMs as initialized by BRAM_bot_*.vhd and BRAM_top_*.vhd
  - The BRAM contents can be generated from an appropriate BMP file using bmpconvert
- Fadeout and rotation features also implemented for testing

Target platform: LOGSYS Spartan-3E FPGA board - http://logsys.mit.bme.hu/sites/default/files/page/2009/09/LOGSYS_SP3E_FPGA_Board.pdf (in Hungarian)
Compiler: Xilinx ISE
