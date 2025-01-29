class transaction;
    rand bit [2:0] opcode;
    rand bit acumulator_ce;
    rand bit [7:0] reg_file_data_in;
   	rand bit [2:0] reg_file_ce;
    rand bit [1:0] reg_file_adr;
    rand bit data_memory_read_enable;
    rand bit [7:0] data_memory;
    rand bit [7:0] data_direct;
    rand bit direct_load;

    bit [7:0] alu_result;
    bit [7:0] acu_output;
    bit [7:0] register_file_output;
    bit c_out;
  	bit [7:0] o_alu_argument;
  bit [7:0] previous_acu; 
  	bit reset;

  constraint c_enables {
   reg_file_ce == 3'b000;
    direct_load dist {1 := 10, 0 := 90};
    data_memory_read_enable dist {1 := 10, 0 := 90};
    acumulator_ce dist {1 := 80, 0 := 20};
  }
  constraint c_diretct_load {
    if(direct_load) data_memory_read_enable == 0;
  }
  constraint c_data_memory_read_enable{
    if(data_memory_read_enable) direct_load == 0;
  }
  
   constraint c_opcode_dependency {
     if (opcode == 3'b000 | opcode == 3'b001 | opcode == 3'b010 | opcode == 3'b011 | opcode == 3'b100 | 	opcode == 3'b101 | opcode == 3'b110) acumulator_ce == 1;
     else 
       acumulator_ce == 0;
      
    }
  
  function void display();
        $display("Transaction: opcode=%b, acumulator_ce=%b, reg_file_data_in=%h, reg_file_ce=%b, reg_file_adr=%b, data_memory_read_enable=%b, data_memory=%h, data_direct=%h, direct_load=%b", 
                 opcode, acumulator_ce, reg_file_data_in, reg_file_ce, reg_file_adr, data_memory_read_enable, data_memory, data_direct, direct_load);
    endfunction
endclass




