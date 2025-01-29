interface alu_interface(
    input logic clk, reset
);

//inputs
logic acumulator_ce;
logic [2:0] opcode;
logic [7:0] reg_file_data_in;
logic [2:0] reg_file_ce;
logic [1:0] reg_file_adr;
logic data_memory_read_enable;
logic [7:0] data_memory;
logic [7:0] data_direct;
logic direct_load;
//outputs
logic [7:0] alu_result;
logic [7:0] acu_output;
logic [7:0] register_file_output;
logic c_out;
logic [7:0] alu_argument;


clocking driver_cb @(posedge clk);
    default input #1 output #1;
    output acumulator_ce;
    output opcode;
    output reg_file_data_in;
    output reg_file_ce;
    output reg_file_adr;
    output data_memory_read_enable;
    output data_memory;
    output data_direct;
    output direct_load;
endclocking

clocking monitor_cb @(posedge clk);
    default input #1 output #1;
    input acumulator_ce;
    input opcode;
    input reg_file_data_in;
    input reg_file_ce;
    input reg_file_adr;
    input data_memory_read_enable;
    input data_memory;
    input data_direct;
    input direct_load;
    input alu_result;
    input acu_output;
    input register_file_output;
    input c_out;
  	input alu_argument;
endclocking

modport DRIVER(clocking driver_cb, input clk, input reset);

modport MONITOR(clocking monitor_cb, input clk, input reset);
endinterface




