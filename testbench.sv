
`include "interface.sv"
`include "test.sv"

module tbench_top;
 //clock and reset signal declaration
  bit clk;
  bit reset;
  
  //clock generation
  always #5 clk = ~clk;
  
  //reset Generation
  initial begin
    clk = 0;
    reset = 1;
    #5 reset =0;
  end
  
  //creatinng instance of interface, inorder to connect DUT and testcase
  alu_interface alu_interface_unit(clk,reset);
  
  //Testcase instance, interface handle is passed to test as an argument
  test t1(alu_interface_unit);
  
  //DUT instance, interface signals are connected to the DUT ports
  alu DUT(
  .i_clk(alu_interface_unit.clk), 
  .i_rst(alu_interface_unit.reset),
  .i_acumulator_ce(alu_interface_unit.acumulator_ce),
  .i_operation_code(alu_interface_unit.opcode),
  .i_register_file(alu_interface_unit.reg_file_data_in),
  .i_register_file_ce(alu_interface_unit.reg_file_ce),
  .i_register_file_mux_addr(alu_interface_unit.reg_file_adr),
  .i_data_memory_read_enable(alu_interface_unit.data_memory_read_enable),
  .i_data_memory(alu_interface_unit.data_memory),
  .i_direct_data(alu_interface_unit.data_direct),
  .i_direct_load(alu_interface_unit.direct_load),
  .o_alu(alu_interface_unit.alu_result),
  .o_acumulator(alu_interface_unit.acu_output),
  .o_register_file(alu_interface_unit.register_file_output),
  .o_carry(alu_interface_unit.c_out),
    .o_alu_argument(alu_interface_unit.alu_argument)
  );
  
  //enabling the wave dump
  initial begin 
    $dumpfile("dump.vcd"); $dumpvars;
  end
endmodule
