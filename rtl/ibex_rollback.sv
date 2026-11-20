// Ibex rollback module
// This module compares two sets of core outputs. In case of mismatch, both cores are rolled back
// to execute again the instruction.

module ibex_rollback 
#(
  parameter int unsigned MismatchCounterLen = 3,
  parameter logic [MismatchCounterLen-1:0] MismatchCounterThreshold = '1
)
(
  input  logic clk_i,
  input  logic rst_ni,

  // Core's EX output signals
  input  logic main_instr_req_i,

 // External core's EX output signals
  input logic shadow_instr_req_i, 
  
  // Rollback lines
  input logic [1:0] ext_rb_trig_i, // rollback triggers from outside
  output logic core_rb_trig_o, // internal rollback line

  // Log information
  output logic [MismatchCounterLen-1:0] mismatch_counter_o

);

    // Relevant Signals From Core Output
    typedef struct packed {
    logic                        instr_req;
    // logic [31:0]                 instr_addr;
    // logic                        data_req;
    // logic                        data_we;
    // logic [3:0]                  data_be;
    // logic [31:0]                 data_addr;
    // logic [31:0]                 data_wdata;
    // logic                        data_tag;
    // logic [4:0]                  rf_raddr_a;
    // logic [4:0]                  rf_raddr_b;
    // logic [4:0]                  rf_waddr_wb;
    // logic                        rf_we_wb;
    // logic [RegFileDataWidth-1:0] rf_wdata_wb;
    // logic [IC_NUM_WAYS-1:0]      ic_tag_req;
    // logic                        ic_tag_write;
    // logic [IC_INDEX_W-1:0]       ic_tag_addr;
    // logic [TagSizeECC-1:0]       ic_tag_wdata;
    // logic [IC_NUM_WAYS-1:0]      ic_data_req;
    // logic                        ic_data_write;
    // logic [IC_INDEX_W-1:0]       ic_data_addr;
    // logic [LineSizeECC-1:0]      ic_data_wdata;
    // logic                        ic_scr_key_req;
    // logic                        irq_pending;
    // crash_dump_t                 crash_dump;
    // logic                        double_fault_seen;
    // ibex_mubi_t                  core_busy;
    // cap_t                        rf_wcap_wb;
    } core_outputs_t;

    core_outputs_t main_outputs, shadow_outputs;

    // Assign Main Outputs
    assign main_outputs.instr_req           = main_instr_req_i;
    // assign main_outputs.instr_addr          = main_instr_addr_i;
    // assign main_outputs.data_req            = main_data_req_i;
    // assign main_outputs.data_we             = main_data_we_i;
    // assign main_outputs.data_be             = main_data_be_i;
    // assign main_outputs.data_addr           = main_data_addr_i;
    // assign main_outputs.data_wdata          = main_data_wdata_i;
    // assign main_outputs.data_tag            = main_data_tag_i;
    // assign main_outputs.rf_raddr_a          = main_rf_raddr_a_i;
    // assign main_outputs.rf_raddr_b          = main_rf_raddr_b_i;
    // assign main_outputs.rf_waddr_wb         = main_rf_waddr_wb_i;
    // assign main_outputs.rf_we_wb            = main_rf_we_wb_i;
    // assign main_outputs.rf_wdata_wb         = main_rf_wdata_wb_i;
    // assign main_outputs.ic_tag_req          = main_ic_tag_req_i;
    // assign main_outputs.ic_tag_write        = main_ic_tag_write_i;
    // assign main_outputs.ic_tag_addr         = main_ic_tag_addr_i;
    // assign main_outputs.ic_tag_wdata        = main_ic_tag_wdata_i;
    // assign main_outputs.ic_data_req         = main_ic_data_req_i;
    // assign main_outputs.ic_data_write       = main_ic_data_write_i;
    // assign main_outputs.ic_data_addr        = main_ic_data_addr_i;
    // assign main_outputs.ic_data_wdata       = main_ic_data_wdata_i;
    // assign main_outputs.ic_scr_key_req      = main_ic_scr_key_req_i;
    // assign main_outputs.irq_pending         = main_irq_pending_i;
    // assign main_outputs.crash_dump          = main_crash_dump_i;
    // assign main_outputs.double_fault_seen   = main_double_fault_seen_i;
    // assign main_outputs.core_busy           = main_core_busy_i;
    // assign main_outputs.rf_wcap_wb          = main_rf_wcap_wb_i;

    // Assign Shadow Outputs
    assign shadow_outputs.instr_req           = shadow_instr_req_i;
    // assign shadow_outputs.instr_addr          = shadow_instr_addr_i;
    // assign shadow_outputs.data_req            = shadow_data_req_i;
    // assign shadow_outputs.data_we             = shadow_data_we_i;
    // assign shadow_outputs.data_be             = shadow_data_be_i;
    // assign shadow_outputs.data_addr           = shadow_data_addr_i;
    // assign shadow_outputs.data_wdata          = shadow_data_wdata_i;
    // assign shadow_outputs.data_tag            = shadow_data_tag_i;
    // assign shadow_outputs.rf_raddr_a          = shadow_rf_raddr_a_i;
    // assign shadow_outputs.rf_raddr_b          = shadow_rf_raddr_b_i;
    // assign shadow_outputs.rf_waddr_wb         = shadow_rf_waddr_wb_i;
    // assign shadow_outputs.rf_we_wb            = shadow_rf_we_wb_i;
    // assign shadow_outputs.rf_wdata_wb         = shadow_rf_wdata_wb_i;
    // assign shadow_outputs.ic_tag_req          = shadow_ic_tag_req_i;
    // assign shadow_outputs.ic_tag_write        = shadow_ic_tag_write_i;
    // assign shadow_outputs.ic_tag_addr         = shadow_ic_tag_addr_i;
    // assign shadow_outputs.ic_tag_wdata        = shadow_ic_tag_wdata_i;
    // assign shadow_outputs.ic_data_req         = shadow_ic_data_req_i;
    // assign shadow_outputs.ic_data_write       = shadow_ic_data_write_i;
    // assign shadow_outputs.ic_data_addr        = shadow_ic_data_addr_i;
    // assign shadow_outputs.ic_data_wdata       = shadow_ic_data_wdata_i;
    // assign shadow_outputs.ic_scr_key_req      = shadow_ic_scr_key_req_i;
    // assign shadow_outputs.irq_pending         = shadow_irq_pending_i;
    // assign shadow_outputs.crash_dump          = shadow_crash_dump_i;
    // assign shadow_outputs.double_fault_seen   = shadow_double_fault_seen_i;
    // assign shadow_outputs.core_busy           = shadow_core_busy_i;
    // assign shadow_outputs.rf_wcap_wb          = shadow_rf_wcap_wb_i;

    // TODO : handle reset 
    // TODO : synchronous ?

    /*
    * Compare main and shadow outputs
    */
    logic outputs_mismatch;

    always_ff @(posedge clk_i or negedge rst_ni) begin
      if(!rst_ni)
        outputs_mismatch <= 1'b0;
      else
        outputs_mismatch <= (main_outputs != shadow_outputs);
    end
    
    /*
    * Update mismatch counter 
    */
    logic [MismatchCounterLen-1:0] mismatch_counter_local;

    always_ff @(posedge clk_i or negedge rst_ni) begin
        if(!rst_ni) begin
           mismatch_counter_local <= 0;
          end
        else begin
          if(outputs_mismatch == 1'b1 && core_rb_trig_o == 1'b0) begin
            mismatch_counter_local <= mismatch_counter_local + 1;
          end
          else begin
            mismatch_counter_local <= mismatch_counter_local;
          end
        end
    end

    /*
    * Update core rollback trigger :
    * If there is an output mismatch or an external rollback is asked,
    * the core rollback trigger is asserted.
    */
    always_ff @(posedge clk_i or negedge rst_ni) begin
      if(!rst_ni) begin
        core_rb_trig_o <= 1'b0;
        mismatch_counter_o <= 'b0;
      end
      else begin
        if(outputs_mismatch == 1'b1 || |ext_rb_trig_i == 1'b1) begin
          core_rb_trig_o <= 1'b1;
          mismatch_counter_o <= mismatch_counter_local;
        end
        else begin
         core_rb_trig_o <= 1'b0;
        end
      end
    end
endmodule
