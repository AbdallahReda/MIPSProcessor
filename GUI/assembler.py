from assembly_parser import assembly_parser
from instruction_table import instruction_table
from register_table import register_table
from pseudoinstruction_table import pseudoinstruction_table

import Tkinter
from Tkinter import *
from ScrolledText import *
import tkFileDialog
import tkMessageBox

import sys
import getopt
import subprocess



def usage():
    print 'Usage: '+sys.argv[0]+'<inputfile1> <inputfile2> ... <outputfile>'
    sys.exit(1)

def main(argv):
    files = argv
    if len(files) <2:
        usage()
    files = argv[0:len(files)-1]

    f= open(argv[len(files)],'w')
    sys.stdout = f


    for filename in files:
        asm           = open(filename)
        lines         = asm.readlines()
        parser        = assembly_parser(64, instruction_table, register_table, pseudoinstruction_table,4)      
	parser.first_pass(lines)
        parser.second_pass(lines)


    f.close()


root = Tkinter.Tk(className="CO Project")
#root.geometry('{}x{}'.format(50, 150))
root.grid_columnconfigure(0, weight = 1)
root.grid_columnconfigure(0, weight = 1)
root.grid_rowconfigure(1, weight = 1)
root.grid_rowconfigure(3, weight = 1)
Tkinter.Label(root, height = '2', text = 'Input').grid(row =0,column = 0)
Tkinter.Label(root, height = '2', text = 'Simulation Output').grid(row =2,column = 0)
input_asm = ScrolledText(root,height = '17')
input_asm.grid(row = 1, column = 0, sticky = N+S+W+E)
output_monitor = ScrolledText(root,height = '12', state= 'disabled')
output_monitor.grid(row = 3, column = 0, sticky = N+S+W+E)

# create a menu & define functions for each menu item

def open_command():
        file = tkFileDialog.askopenfile(parent=root,mode='rb',title='Select a file')
        if file != None:
            new() 
	    contents = file.read()
            input_asm.insert('1.0',contents)
            file.close()


def save_command():
    file = tkFileDialog.asksaveasfile(mode='w')
    if file != None:
    # slice off the last character from get, as an extra return is added
        data = input_asm.get('1.0', END+'-1c')
        file.write(data)
        file.close()
        
def exit_command():
    if tkMessageBox.askokcancel("Quit", "Do you really want to quit?"):
        root.destroy()        

def about_command():
    label = tkMessageBox.showinfo("About", "Assembler with Verilog simulator integration project. \n\n\nTeam members: \n\nAbdelrahman Mahmoud\nAbdelrahman Yassin\nAbdullah Reda\nDiaa Ahmed\nSamuel Medhat")
        

def new():
    input_asm.delete('1.0', END)


    output_monitor['state'] = 'normal'
    output_monitor.delete('1.0', END)
    output_monitor['state'] = 'disabled'

def export_inst():
    #file = tkFileDialog.asksaveasfile(mode='w')
    #if file != None:
    # slice off the last character from get, as an extra return is added
        #s = file.name
        #file.close()
        data = input_asm.get('1.0', END)
        s='inst_mem.txt'
        f= open(s,'w')
        sys.stdout = f
        lines = data.splitlines()
        inst_no = len(lines)
        
        parser        = assembly_parser(64, instruction_table, register_table, pseudoinstruction_table,4)      
        parser.first_pass(lines)
        parser.second_pass(lines)

        for i in range(inst_no,256+1):
        	f.write('00000000\n')        
        f.close()
        sys.stdout = sys.__stdout__
	tkMessageBox.showinfo("Export", "Done exporting instruction memory!")

def export_2():
    file = tkFileDialog.asksaveasfile(mode='w')
    if file != None:
    # slice off the last character from get, as an extra return is added
        s = file.name
        file.close()
        data = input_asm.get('1.0', END)
 
        f= open(s,'w')
        #print s
        sys.stdout = f
        lines = data.splitlines()
        inst_no = len(lines)
        
        parser        = assembly_parser(64, instruction_table, register_table, pseudoinstruction_table,4)      
        parser.first_pass(lines)
        parser.second_pass(lines)
        for i in range(inst_no,256+1):
        	f.write('00000000\n')          
        f.close()
        sys.stdout = sys.__stdout__
        
def export_reg():
        data = input_asm.get('1.0', END)
        s='regs.txt'
        f= open(s,'w')
        f.write(data)
        lines = data.splitlines()
        reg_no = len(lines)
        
        for i in range(reg_no,32+1):
        	f.write('00000000\n')        
        f.close()
	
	tkMessageBox.showinfo("Export", "Done exporting register file!")
def export_mem():
        data = input_asm.get('1.0', END)
        s='data_mem.txt'
        f= open(s,'w')
        f.write(data)
        lines = data.splitlines()
        mem_no = len(lines)
        
        for i in range(mem_no,256+1):
        	f.write('00000000\n')        
        f.close()        
	tkMessageBox.showinfo("Export", "Done exporting data memory!")

def execute():
#iverilog -o mips 1.InstructionFetch.v 2.Decode.v 3.Execution.v 4.MEMandWB.v MUXES.v MIPS_Trial.v -s  MIPS_TB
#vvp mips
	output = subprocess.check_output(['iverilog','-o','mips','1.InstructionFetch.v','2.Decode.v','3.Execution.v','4.MEMandWB.v','MUXES.v','MIPS_Trial.v','-s','MIPS_TB'])
	output = subprocess.check_output(['vvp','mips'])
	print output
	

	

	output_monitor['state'] = 'normal'
	output_monitor.insert('1.0',output)
	output_monitor['state'] = 'disabled'

	
	
	
	 
menu = Menu(root)
root.config(menu=menu)
filemenu = Menu(menu)
menu.add_cascade(label="File", menu=filemenu)
filemenu.add_command(label="New", command=new)
filemenu.add_command(label="Open...", command=open_command)
filemenu.add_command(label="Save", command=save_command)
filemenu.add_separator()
filemenu.add_command(label="Execute", command=execute)
filemenu.add_separator()
filemenu.add_command(label="Exit", command=exit_command)

exportmenu = Menu(menu)
menu.add_cascade(label="Export", menu=exportmenu)
exportmenu.add_command(label="Machine code", command=export_2)
exportmenu.add_command(label="Instruction memory", command=export_inst)
exportmenu.add_command(label="Reggister file", command=export_reg)
exportmenu.add_command(label="Data memory", command=export_mem)

helpmenu = Menu(menu)
menu.add_cascade(label="Help", menu=helpmenu)
helpmenu.add_command(label="About...", command=about_command)


#textPad.pack()
root.mainloop()
