// Ibex rollback testbench
`include "/home/helen/Projects/ibex/rtl/ibex_rollback.sv"

// `timescale 1 ns/10 ps

module tb_ibex_rollback #(
    parameter int unsigned CLK_CYCLE = 10,
    parameter int unsigned MismatchCounterLen = 3
);

  logic clk_i;
  logic rst_ni;

  logic main_instr_req_i;
  logic shadow_instr_req_i;

  logic [1:0] ext_rb_trig_i;
  logic core_rb_trig_o;
  logic [MismatchCounterLen-1:0] mismatch_counter_o;

ibex_rollback DUT (
  .clk_i(clk_i),
  .rst_ni(rst_ni),

  // Main Core Output Signals
  .main_instr_req_i(main_instr_req_i),

  // Shadow Core Output Signals
  .shadow_instr_req_i(shadow_instr_req_i),

  .core_rb_trig_o(core_rb_trig_o),
  .ext_rb_trig_i(ext_rb_trig_i),
  .mismatch_counter_o(mismatch_counter_o)
);

// Clock generation
always # (CLK_CYCLE/2) clk_i = ~clk_i; 

initial begin // execute the procedure only once !
    // This has to be at beginning, in order to dump the
    // waveforms.
    $dumpfile("tb_ibex_rollback.vcd");
    $dumpvars();
    
    // Initial state
    // Those are blocking assignements, they are done in this order.
    clk_i = 1'b0;
    rst_ni = 1'b1;
    shadow_instr_req_i = 1'b0;
    main_instr_req_i = 1'b0;
    ext_rb_trig_i = 'b0;

    # (CLK_CYCLE*2);

    // mismatching core signals
    // increment mismatch counter to trigger a core rollback
    shadow_instr_req_i = 1'b1;
    # (CLK_CYCLE*12);

    // reset mismatch counter
    rst_ni= 1'b0;
    # CLK_CYCLE;
    rst_ni= 1'b1;

    // matching core signals, 
    // but now there is external rollback trigger
    shadow_instr_req_i = 1'b0;
    ext_rb_trig_i[0] = 1'b1;
    # (CLK_CYCLE*4);
    
    // matching core signals,
    // and no external rollback trigger
    ext_rb_trig_i[0] = 1'b0;
    # (CLK_CYCLE*4);
    
    $finish;
end

endmodule