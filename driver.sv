class driver;

int transmision_counter = 0;
virtual alu_interface alu_unit_interface;
mailbox generator_to_driver;

function new(virtual alu_interface alu_virtual_interface_unit, mailbox alu_generator_to_driver);
    this.alu_unit_interface = alu_virtual_interface_unit;
    this.generator_to_driver = alu_generator_to_driver;
endfunction

task reset;
    wait(alu_unit_interface.reset);
    $display("[DRIVER] RESET STARTED");
    alu_unit_interface.DRIVER.driver_cb.acumulator_ce <= 0;
    alu_unit_interface.DRIVER.driver_cb.reg_file_ce <= 0;
    alu_unit_interface.DRIVER.driver_cb.data_memory_read_enable <= 0;
    alu_unit_interface.DRIVER.driver_cb.direct_load <= 0;
    wait(!alu_unit_interface.reset);
    $display("[DRIVER] RESET ENDED");
endtask

task drive;
    forever begin
        transaction trans;
      generator_to_driver.get(trans);
      //trans.display();
     
        alu_unit_interface.DRIVER.driver_cb.acumulator_ce <= trans.acumulator_ce;
        alu_unit_interface.DRIVER.driver_cb.reg_file_ce <= trans.reg_file_ce;
        alu_unit_interface.DRIVER.driver_cb.data_memory_read_enable <= trans.data_memory_read_enable;
        alu_unit_interface.DRIVER.driver_cb.direct_load <= trans.direct_load;

        alu_unit_interface.DRIVER.driver_cb.opcode <= trans.opcode;
        alu_unit_interface.DRIVER.driver_cb.reg_file_data_in <= trans.reg_file_data_in;
        alu_unit_interface.DRIVER.driver_cb.data_memory <= trans.data_memory;
        alu_unit_interface.DRIVER.driver_cb.data_direct <= trans.data_direct;
        alu_unit_interface.DRIVER.driver_cb.direct_load <= trans.direct_load;
      	transmision_counter++;
    	 @(posedge alu_unit_interface.DRIVER.clk);
    end
endtask


endclass



