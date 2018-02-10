MIPS Pipelined Processor
========================
Intro
-----

This project is made by a group of students at 3rd year Computer and systems department students at Faculty of Engineering Ain Shams University. This is a complete rewrite in (Verilog HDL). 

**#Group Names:**
1.Samuel Medhat
2.Diaa Ahmed
3.Abdelrahman Ibrahim
4.Abdelrahman Mahmoud
5.Abdallah Reda

The aim of this project is to simulate a pipelined MIPS processor dealing with various MIPS instructions.

This Project is supporting data hazards, control hazards for LW, BEQ and R-Format instructions.

The HDL code supporting filling the memories (Instruction Memory and Data Memory) and register files from outside text files or filling it manually by the user by typing them inside their modules.

These text files must be found inside the Project files directory under specific names.
 
There is also a GUI program with simple interface that can be simply used by any user.

GUI support converting ASSEMBLY language into machine code language, filling text files contain the data that will be stored in the Register file and the memories (Instruction Memory and Data Memory),and viewing the monitor of the internal test bench.


 

Contents
--------

- Mips_final : The final version of the implementation with all problems solved  
- Implementation_trials : the previous versions of the implementations from the single cycle version to the pipelined version 
- Support flexible matrix parser(Accept matrix in matrix, expressions and variables).
-Documentations-the folder that contains all of the documents related to the project like the project documentation,synthesis report,gui documentation,testcase

- GUI : an assembler that translates the assmebly to hexadecimal format
- project Documentation : A document of all the work done in the project and resources to some references 
- Synthesis report : A report that proves that the implementation is synthesizable using (Xilinx ISE Design Suite)
- Test_cases : some test cases to show that the implementation is working perfectly under any kind of hazards 

-Gui documentation :it describes how the gui works and how you can use it 






Mips_final
----------
This folder contains the final version of our project and contains also the codes self documented with the many comments.
We have 6 files:
1-fetch.v
2-decode.v
3-excuetion.v
4-memory.v
5-muxes.v
6-mips.v

-Implemantation trials 
This folder contains our journey to finish this project starting from single cycle going through the pipelining supporting more instructions with their hazards.

Documentations
--------------
This folder contains all the documents of our work and how to deal with it 


GUI
---
This GUI is used for creating input files for our MIPS Verilog project such as instruction memory, data memory and register file. The app is integrated with iVerilog to simulate the Verilog modules and show output results. It is also can be used on Windows and Linux  operating systems.
To run the gui you can run this command from the bash terminal or windows power shell


::

    python2 assembly.py

Contents Of Documentations
--------------------------


Project Documentation
---------------------
We have documented all our work in the documentation file in this file we have an intro to the project and what the project supports.
We have described the concept of pipelining and the hazards that may occur 
And how we dealed with it.

Synthesis report
----------------
This is output report from the synthesisation on xlinix which refer that our project is synthesized


TestCases
--------
We have 16 test cases varying from normal test cases to depandancy and hazard test cases to control test cases to control dependency and hazard test cases

GUI documentation
------------------
In this documentation we describe how does the GUI works and how to run it and how to use it in our simulation process.



