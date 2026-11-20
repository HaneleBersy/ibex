import os

os.system('verilator --cc --exe --timing --coverage --build --trace-vcd sim_main.cpp ../../testbench/tb_ibex_rollback.sv')
os.system('obj_dir/Vtb_ibex_rollback')
os.system('gtkwave tb_ibex_rollback.vcd')