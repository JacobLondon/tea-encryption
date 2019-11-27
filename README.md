# Tea Encryption Algorithm
This ECE 4304 project is an implementation of the Tea encryption algorithm designed in VHDL, targeting the Nexys 4 DDR FPGA board. The algorithm is based on the public domain algorithm Tea, the tiny encryption algorithm. The hardware description and testingwas done through the Vivado design suite.

## Project Structure
- ~/doc
    - Includes the PowerPoint, Poster, and the Paper for the project
- ~/src/software
    - The software for the project written in C
- ~/src/hardware
    - The Vivado projects, the constraints file, and the VHDL source files

# Building
## Software
The software was used as a testing tool and is written in C. Each C program under this directory can be compiled with `gcc` and no other options.
## Hardware
Open ~/src/hardware/vivado/xtea.xpr in Vivado 2019.1 or greater, and upload the Top.bit file to a Nexys 4 DDR board.

# Board IO
- Switches 0-7: The number of rounds for the algorithm to run.
- VGA Connection: Connect the VGA to a VGA capable monitor. The display will show 3 rows:
    - input data which will be encrypted
    - the encryption key
    - the result of the encryption
- UART Input
    - Using a tool such as `gtkterm` or `puTTY`, you can send data to the FPGA with the UART protocol to enter the input data, then the key respectively.
