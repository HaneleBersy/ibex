  #include "Vtb_ibex_rollback.h"

  #include "verilated.h"
  
  int main(int argc, char** argv)
  {
      VL_PRINTF("starting sim\n");

      VerilatedContext* contextp = new VerilatedContext;
      
      
      // Verilator must compute traced signals
      contextp->traceEverOn(true);
      
      contextp->commandArgs(argc, argv);


      Vtb_ibex_rollback* top = new Vtb_ibex_rollback{contextp};


      while (!contextp->gotFinish())
      {
        contextp->timeInc(1);  // 1 timeprecision period passes...

        top->eval();
      }

      VL_PRINTF("terminating sim\n");

      // top->final();
      // contextp->statsPrintSummary();

      delete top;
      delete contextp;
      return 0;
  }