// Ibex rollback module
// This module compares two sets of core outputs. In case of mismatch, both cores are rolled back
// to execute again the instruction.

module ibex_rollback 
#(
  parameter int unsigned MismatchCounterSize = 2,
  parameter int unsigned MismatchCounterThreshold = 3
//   parameter base_isa_e              BaseIsa                     = BaseIsaRV32I,
//   parameter int unsigned            LockstepOffset              = 1,
//   parameter bit                     PMPEnable                   = 1'b0,
//   parameter int unsigned            PMPGranularity              = 0,
//   parameter int unsigned            PMPNumRegions               = 4,
//   parameter ibex_pkg::pmp_cfg_t     PMPRstCfg[PMP_MAX_REGIONS]  = ibex_pkg::PmpCfgRst,
//   parameter logic [PMP_ADDR_MSB:0]  PMPRstAddr[PMP_MAX_REGIONS] = ibex_pkg::PmpAddrRst,
//   parameter ibex_pkg::pmp_mseccfg_t PMPRstMsecCfg               = ibex_pkg::PmpMseccfgRst,
//   parameter int unsigned            MHPMCounterNum              = 0,
//   parameter int unsigned            MHPMCounterWidth            = 40,
//   parameter bit                     RV32E                       = 1'b0,
//   parameter rv32m_e                 RV32M                       = RV32MFast,
//   parameter rv32b_e                 RV32B                       = RV32BNone,
//   parameter rv32zc_e                RV32ZC                      = RV32ZcaZcbZcmp,
//   parameter bit                     BranchTargetALU             = 1'b0,
//   parameter bit                     WritebackStage              = 1'b0,
//   parameter bit                     ICache                      = 1'b0,
//   parameter bit                     ICacheECC                   = 1'b0,
//   parameter bit                     ICacheTweakInfection        = 1'b0,
//   parameter int unsigned            BusSizeECC                  = BUS_SIZE,
//   parameter int unsigned            TagSizeECC                  = IC_TAG_SIZE,
//   parameter int unsigned            LineSizeECC                 = IC_LINE_SIZE,
//   parameter bit                     BranchPredictor             = 1'b0,
//   parameter bit                     DbgTriggerEn                = 1'b0,
//   parameter int unsigned            DbgHwBreakNum               = 1,
//   parameter bit                     ResetAll                    = 1'b0,
//   parameter lfsr_seed_t             RndCnstLfsrSeed             = RndCnstLfsrSeedDefault,
//   parameter lfsr_perm_t             RndCnstLfsrPerm             = RndCnstLfsrPermDefault,
//   parameter bit                     SecureIbex                  = 1'b0,
//   parameter bit                     DummyInstructions           = 1'b0,
//   parameter bit                     RegFileECC                  = 1'b0,
//   parameter int unsigned            RegFileDataWidth            = 32,
//   parameter int unsigned            RegFileDataEccWidth         = 39,
//   parameter int unsigned            RegFileCapEccWidth          = REGCAP_W + 7,
//   parameter regfile_e               RegFile                     = RegFileFF,
//   parameter bit                     MemECC                      = 1'b0,
//   parameter int unsigned            MemDataWidth                = MemECC ? 32 + 7 : 32,
//   parameter int unsigned            DmBaseAddr                  = 32'h1A110000,
//   parameter int unsigned            DmAddrMask                  = 32'h00000FFF,
//   parameter int unsigned            DmHaltAddr                  = 32'h1A110800,
//   parameter int unsigned            DmExceptionAddr             = 32'h1A110808,
//   // mvendorid: encoding of manufacturer/provider
//   parameter logic [31:0]            CsrMvendorId                = 32'b0,
//   // marchid: encoding of base microarchitecture
//   parameter logic [31:0]            CsrMimpId                   = 32'b0
)
(
  input  logic                         clk_i,
  input  logic                         rst_ni,

  // Main Core Output Signals
  input  logic                         main_instr_req_i,
  // input  logic [31:0]                  main_instr_addr_i,
  // input  logic                         main_data_req_i,
  // input  logic                         main_data_we_i,
  // input  logic [3:0]                   main_data_be_i,
  // input  logic [31:0]                  main_data_addr_i,
  // input  logic [31:0]                  main_data_wdata_i,
  // input  logic                         main_data_tag_i,
  // input  logic [4:0]                   main_rf_raddr_a_i,
  // input  logic [4:0]                   main_rf_raddr_b_i,
  // input  logic [4:0]                   main_rf_waddr_wb_i,
  // input  logic                         main_rf_we_wb_i,
  // input  logic [RegFileDataWidth-1:0]  main_rf_wdata_wb_i,
  // input  cap_t                         main_rf_wcap_wb_i,
  // input  logic [IC_NUM_WAYS-1:0]       main_ic_tag_req_i,
  // input  logic                         main_ic_tag_write_i,
  // input  logic [IC_INDEX_W-1:0]        main_ic_tag_addr_i,
  // input  logic [TagSizeECC-1:0]        main_ic_tag_wdata_i,
  // input  logic [IC_NUM_WAYS-1:0]       main_ic_data_req_i,
  // input  logic                         main_ic_data_write_i,
  // input  logic [IC_INDEX_W-1:0]        main_ic_data_addr_i,
  // input  logic [LineSizeECC-1:0]       main_ic_data_wdata_i,
  // input  logic                         main_ic_scr_key_req_i,
  // input  logic                         main_irq_pending_i,
  // input  crash_dump_t                  main_crash_dump_i,
  // input  logic                         main_double_fault_seen_i,
  // input  ibex_mubi_t                   main_core_busy_i,

  // Shadow Core Output Signals
  input  logic                         shadow_instr_req_i,
  // input  logic [31:0]                  shadow_instr_addr_i,
  // input  logic                         shadow_data_req_i,
  // input  logic                         shadow_data_we_i,
  // input  logic [3:0]                   shadow_data_be_i,
  // input  logic [31:0]                  shadow_data_addr_i,
  // input  logic [31:0]                  shadow_data_wdata_i,
  // input  logic                         shadow_data_tag_i,
  // input  logic [4:0]                   shadow_rf_raddr_a_i,
  // input  logic [4:0]                   shadow_rf_raddr_b_i,
  // input  logic [4:0]                   shadow_rf_waddr_wb_i,
  // input  logic                         shadow_rf_we_wb_i,
  // input  logic [RegFileDataWidth-1:0]  shadow_rf_wdata_wb_i,
  // input  cap_t                         shadow_rf_wcap_wb_i,
  // input  logic [IC_NUM_WAYS-1:0]       shadow_ic_tag_req_i,
  // input  logic                         shadow_ic_tag_write_i,
  // input  logic [IC_INDEX_W-1:0]        shadow_ic_tag_addr_i,
  // input  logic [TagSizeECC-1:0]        shadow_ic_tag_wdata_i,
  // input  logic [IC_NUM_WAYS-1:0]       shadow_ic_data_req_i,
  // input  logic                         shadow_ic_data_write_i,
  // input  logic [IC_INDEX_W-1:0]        shadow_ic_data_addr_i,
  // input  logic [LineSizeECC-1:0]       shadow_ic_data_wdata_i,
  // input  logic                         shadow_ic_scr_key_req_i,
  // input  logic                         shadow_irq_pending_i,
  // input  crash_dump_t                  shadow_crash_dump_i,
  // input  logic                         shadow_double_fault_seen_i,
  // input  ibex_mubi_t                   shadow_core_busy_i,
  
  // Rollback lines
  output logic                          trigger_rollback

  // input  logic                         irq_software_i,
  // input  logic                         irq_timer_i,
//   input  logic                         irq_external_i,
//   input  logic [14:0]                  irq_fast_i,
//   input  logic                         irq_nm_i,

//   input  logic                         debug_req_i,

//   input  ibex_mubi_t                   fetch_enable_i,
//   input  ibex_mubi_t                   mcounteren_writable_i,
//   output logic                         alert_minor_o,
//   output logic                         alert_major_internal_o,
//   output logic                         alert_major_bus_o,
//   input  logic                         test_en_i,
//   input  logic                         scan_rst_ni,

//   output ibex_mubi_t                   lockstep_cmp_en_o,
//   output logic                         data_req_shadow_o,
//   output logic                         data_we_shadow_o,
//   output logic [3:0]                   data_be_shadow_o,
//   output logic [31:0]                  data_addr_shadow_o,
//   output logic [31:0]                  data_wdata_shadow_o,
//   output logic [6:0]                   data_wdata_intg_shadow_o,
//   output logic                         instr_req_shadow_o,
//   output logic [31:0]                  instr_addr_shadow_o
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
    // logic [MismatchCounterSize-1:0] mismatch_counter;

    // always_ff @(posedge clk_i or negedge rst_ni) begin
    //     if(!rst_ni) begin
    //        for (int unsigned i = 0; i < MismatchCounterSize; i++) begin
    //         mismatch_counter[i] <= 1'b0;
    //        end
    //     end
    //     else begin
    //       if(outputs_mismatch == 1'b1) begin
    //         mismatch_counter <= mismatch_counter + 1;
    //       end
    //       else begin
    //         mismatch_counter <= mismatch_counter;
    //       end
    //     end
    // end

    /*
    * Trigger rollback
    */
    
    // always_ff @(posedge clk_i or negedge rst_ni) begin
    //   if(!rst_ni) begin
    //     trigger_rollback <= 1'b0;
    //   end
    //   else begin
    //     if(mismatch_counter == MismatchCounterThreshold) begin
    //       trigger_rollback <= 1'b1;
    //     end
    //     else begin
    //      trigger_rollback <= 1'b0;
    //     end
    //   end
    // end



endmodule
