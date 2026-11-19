// Ibex rollback testbench
`include "ibex_rollback.sv"

`timescale 1 ns/10 ps

module tb_ibex_rollback #(
    parameter int unsigned CLK_CYCLE = 10
);

  logic clk_i;
  logic rst_ni;

  // Main Core Output Signals
  logic main_instr_req_i;
//   logic [31:0]                  main_instr_addr_i,
//   logic                         main_data_req_i,
//   logic                         main_data_we_i,
//   logic [3:0]                   main_data_be_i,
//   logic [31:0]                  main_data_addr_i,
//   logic [31:0]                  main_data_wdata_i,
//   logic                         main_data_tag_i,
//   logic [4:0]                   main_rf_raddr_a_i,
//   logic [4:0]                   main_rf_raddr_b_i,
//   logic [4:0]                   main_rf_waddr_wb_i,
//   logic                         main_rf_we_wb_i,
//   logic [RegFileDataWidth-1:0]  main_rf_wdata_wb_i,
//   cap_t                         main_rf_wcap_wb_i,
//   logic [IC_NUM_WAYS-1:0]       main_ic_tag_req_i,
//   logic                         main_ic_tag_write_i,
//   logic [IC_INDEX_W-1:0]        main_ic_tag_addr_i,
//   logic [TagSizeECC-1:0]        main_ic_tag_wdata_i,
//   logic [IC_NUM_WAYS-1:0]       main_ic_data_req_i,
//   logic                         main_ic_data_write_i,
//   logic [IC_INDEX_W-1:0]        main_ic_data_addr_i,
//   logic [LineSizeECC-1:0]       main_ic_data_wdata_i,
//   logic                         main_ic_scr_key_req_i,
//   logic                         main_irq_pending_i,
//   crash_dump_t                  main_crash_dump_i,
//   logic                         main_double_fault_seen_i,
//   ibex_mubi_t                   main_core_busy_i,

  // Shadow Core Output Signals
  logic shadow_instr_req_i;
//   logic [31:0]                  shadow_instr_addr_i,
//   logic                         shadow_data_req_i,
//   logic                         shadow_data_we_i,
//   logic [3:0]                   shadow_data_be_i,
//   logic [31:0]                  shadow_data_addr_i,
//   logic [31:0]                  shadow_data_wdata_i,
//   logic                         shadow_data_tag_i,
//   logic [4:0]                   shadow_rf_raddr_a_i,
//   logic [4:0]                   shadow_rf_raddr_b_i,
//   logic [4:0]                   shadow_rf_waddr_wb_i,
//   logic                         shadow_rf_we_wb_i,
//   logic [RegFileDataWidth-1:0]  shadow_rf_wdata_wb_i,
//   cap_t                         shadow_rf_wcap_wb_i,
//   logic [IC_NUM_WAYS-1:0]       shadow_ic_tag_req_i,
//   logic                         shadow_ic_tag_write_i,
//   logic [IC_INDEX_W-1:0]        shadow_ic_tag_addr_i,
//   logic [TagSizeECC-1:0]        shadow_ic_tag_wdata_i,
//   logic [IC_NUM_WAYS-1:0]       shadow_ic_data_req_i,
//   logic                         shadow_ic_data_write_i,
//   logic [IC_INDEX_W-1:0]        shadow_ic_data_addr_i,
//   logic [LineSizeECC-1:0]       shadow_ic_data_wdata_i,
//   logic                         shadow_ic_scr_key_req_i,
//   logic                         shadow_irq_pending_i,
//   crash_dump_t                  shadow_crash_dump_i,
//   logic                         shadow_double_fault_seen_i,
//   ibex_mubi_t                   shadow_core_busy_i,


ibex_rollback DUT (
  .clk_i(clk_i),
  .rst_ni(rst_ni),

  // Main Core Output Signals
  .main_instr_req_i(main_instr_req_i),
//   .main_instr_addr_i(),
//   .main_data_req_i(),
//   .main_data_we_i(),
//   .main_data_be_i(),
//   .main_data_addr_i(),
//   .main_data_wdata_i(),
//   .main_data_tag_i(),
//   .main_rf_raddr_a_i(),
//   .main_rf_raddr_b_i(),
//   .main_rf_waddr_wb_i(),
//   .main_rf_we_wb_i(),
//   .main_rf_wdata_wb_i,
//   .main_rf_wcap_wb_i,
//   .main_ic_tag_req_i,
//   .main_ic_tag_write_i,
//   .main_ic_tag_addr_i,
//   .main_ic_tag_wdata_i,
//   .main_ic_data_req_i,
//   .main_ic_data_write_i,
//   .main_ic_data_addr_i,
//   .main_ic_data_wdata_i,
//   .main_ic_scr_key_req_i,
//   .main_irq_pending_i,
//   .main_crash_dump_i,
//   .main_double_fault_seen_i,
//   .main_core_busy_i,

  // Shadow Core Output Signals
  .shadow_instr_req_i(shadow_instr_req_i)
//   input  logic [31:0]                  shadow_instr_addr_i,
//   input  logic                         shadow_data_req_i,
//   input  logic                         shadow_data_we_i,
//   input  logic [3:0]                   shadow_data_be_i,
//   input  logic [31:0]                  shadow_data_addr_i,
//   input  logic [31:0]                  shadow_data_wdata_i,
//   input  logic                         shadow_data_tag_i,
//   input  logic [4:0]                   shadow_rf_raddr_a_i,
//   input  logic [4:0]                   shadow_rf_raddr_b_i,
//   input  logic [4:0]                   shadow_rf_waddr_wb_i,
//   input  logic                         shadow_rf_we_wb_i,
//   input  logic [RegFileDataWidth-1:0]  shadow_rf_wdata_wb_i,
//   input  cap_t                         shadow_rf_wcap_wb_i,
//   input  logic [IC_NUM_WAYS-1:0]       shadow_ic_tag_req_i,
//   input  logic                         shadow_ic_tag_write_i,
//   input  logic [IC_INDEX_W-1:0]        shadow_ic_tag_addr_i,
//   input  logic [TagSizeECC-1:0]        shadow_ic_tag_wdata_i,
//   input  logic [IC_NUM_WAYS-1:0]       shadow_ic_data_req_i,
//   input  logic                         shadow_ic_data_write_i,
//   input  logic [IC_INDEX_W-1:0]        shadow_ic_data_addr_i,
//   input  logic [LineSizeECC-1:0]       shadow_ic_data_wdata_i,
//   input  logic                         shadow_ic_scr_key_req_i,
//   input  logic                         shadow_irq_pending_i,
//   input  crash_dump_t                  shadow_crash_dump_i,
//   input  logic                         shadow_double_fault_seen_i,
//   input  ibex_mubi_t                   shadow_core_busy_i,
);

logic clk_temp;
logic rst_ntemp;

initial begin // execute the procedure only once !
    // Initial state
    clk_temp = 1'b0;
    rst_ntemp = 1'b1;
    shadow_instr_req_i = 1'b0;
    main_instr_req_i = 1'b0;

    // Clock generation
    forever # (CLK_CYCLE/2) clk_temp = ~clk_temp; 

    # 100;
    shadow_instr_req_i = 1'b1;
    # 100;
    shadow_instr_req_i = 1'b0;
    # 100;
    main_instr_req_i = 1'b1;
    # 100;
    shadow_instr_req_i = 1'b1;
    # 100;
    rst_ntemp= 1'b0;
end

assign clk_i = clk_temp;
assign rst_ni = rst_ntemp;

endmodule