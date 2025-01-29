`include "generator.sv"
`include "driver.sv"
`include "monitor.sv"
`include "scoreboard.sv"


class enviroment;
    generator gen;
    driver driv;
  	monitor mon;
  	scoreboard scb;

	mailbox gen2driv;
  mailbox mon2scb;

	event gen_ended;

	virtual alu_interface alu_virtual_interface;

  function new(virtual alu_interface alu_virtual_interface);
    this.alu_virtual_interface = alu_virtual_interface;
    gen2driv = new();
    mon2scb = new();
    gen = new(gen2driv, gen_ended);
    driv = new(alu_virtual_interface, gen2driv);
    mon = new(alu_virtual_interface, mon2scb);
     scb = new(mon2scb);
endfunction

task pre_test();
  fork
  	mon.monitor();
    scb.main();
    driv.reset();
  join
endtask

task test();
  $display("Glowny test alu");
    fork
        begin
            gen.main();
        end
        begin
            driv.drive();
        end
        begin
            mon.monitor();
        end
        begin
            scb.main();
        end
    join_any
endtask
  
  task acu_test();
    $display("Test dzialania akumulatora");
     fork
        gen.main();
        driv.drive();
     	mon.monitor_acu();
        scb.acu_scb();
    join_any
endtask

task post_tested();
    wait(gen_ended.triggered);
    wait(gen.repeat_count == driv.transmision_counter);
  	wait(mon.trans_counter == scb.trans_cnt);
  mon.ended = 1;
  scb.ended = 1;
endtask

task run;
  $display("Test Resetu");
    pre_test();
  #10
    test();
	post_tested();
  #10
  mon.ended = 0;
  scb.ended = 0;
  //gen.repeat_count = 0;
  driv.transmision_counter = 0;
  mon.trans_counter = 0;
  scb.trans_cnt = 0;
  $display("test 2");
  	acu_test();
  	post_tested();
    $finish;
endtask
endclass




