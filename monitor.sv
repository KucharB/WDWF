class monitor;
    virtual alu_interface alu_unit_interface;
    mailbox mon_dut;
    int trans_counter = 0;
  	int ended;

    function new(virtual alu_interface alu_interface_vir, mailbox mon_dut);
        this.alu_unit_interface = alu_interface_vir;
        this.mon_dut = mon_dut;
    endfunction

  task monitor;
    forever begin
        transaction trans;
        trans = new();
      if(ended == 1)
        break;
      if(alu_unit_interface.MONITOR.reset) begin
        trans.reset = 1;
       	trans.acu_output = alu_unit_interface.MONITOR.monitor_cb.acu_output;
        trans.reg_file_adr = alu_unit_interface.MONITOR.monitor_cb.reg_file_adr;
        mon_dut.put(trans);
        break;
      end
      else begin
        trans.reset = 0;
      @(posedge alu_unit_interface.MONITOR.clk);
        trans.acumulator_ce = alu_unit_interface.MONITOR.monitor_cb.acumulator_ce;
        trans.opcode = alu_unit_interface.MONITOR.monitor_cb.opcode;
        trans.reg_file_data_in = alu_unit_interface.MONITOR.monitor_cb.reg_file_data_in;
        trans.reg_file_ce = alu_unit_interface.MONITOR.monitor_cb.reg_file_ce;
        trans.reg_file_adr = alu_unit_interface.MONITOR.monitor_cb.reg_file_adr;
        trans.data_memory_read_enable = alu_unit_interface.MONITOR.monitor_cb.data_memory_read_enable;
        trans.data_memory = alu_unit_interface.MONITOR.monitor_cb.data_memory;
        trans.data_direct = alu_unit_interface.MONITOR.monitor_cb.data_direct;
        trans.direct_load = alu_unit_interface.MONITOR.monitor_cb.direct_load;
        trans.alu_result = alu_unit_interface.MONITOR.monitor_cb.alu_result;
        trans.acu_output = alu_unit_interface.MONITOR.monitor_cb.acu_output;
        trans.register_file_output = alu_unit_interface.MONITOR.monitor_cb.register_file_output;
        trans.c_out = alu_unit_interface.MONITOR.monitor_cb.c_out;
		trans.o_alu_argument = alu_unit_interface.MONITOR.monitor_cb.alu_argument;
        mon_dut.put(trans);
        trans_counter++;
      end
    end
endtask
  
   task monitor_acu;
    forever begin
      transaction trans;
      trans = new();
      trans.alu_result = alu_unit_interface.MONITOR.monitor_cb.alu_result;
      trans.data_memory_read_enable = alu_unit_interface.MONITOR.monitor_cb.data_memory_read_enable;
      trans.acumulator_ce = alu_unit_interface.MONITOR.monitor_cb.acumulator_ce;
      trans.direct_load = alu_unit_interface.MONITOR.monitor_cb.direct_load;
      trans.previous_acu = alu_unit_interface.MONITOR.monitor_cb.acu_output;
      trans.data_direct = alu_unit_interface.MONITOR.monitor_cb.data_direct;
      @(posedge alu_unit_interface.MONITOR.clk);
      trans.acu_output = alu_unit_interface.MONITOR.monitor_cb.acu_output;
      mon_dut.put(trans);
      trans_counter++;
      end

  endtask

  
    /*task monitor_acu;
    forever begin
      transaction trans;
      trans = new();
      @(posedge alu_unit_interface.MONITOR.clk);
      trans.alu_result = alu_unit_interface.MONITOR.monitor_cb.alu_result;
      if(alu_unit_interface.MONITOR.monitor_cb.acumulator_ce == 1) 
        begin
        	@(posedge alu_unit_interface.MONITOR.clk);
          	trans.acu_output = alu_unit_interface.MONITOR.monitor_cb.acu_output;
          	mon_dut.put(trans);
          	trans_counter++;
            end
       	end
  endtask*/

  
endclass




