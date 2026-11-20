import os

os.system('verilator --cc --exe --timing --coverage --build --trace-vcd sim_main.cpp ../../testbench/tb_ibex_rollback.sv > output.txt')
os.system('obj_dir/Vtb_ibex_rollback')
os.system('gtkwave tb_ibex_rollback.vcd tb_ibex_rollback.gtkw')