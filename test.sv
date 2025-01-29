`include "enviroment.sv"

program test(alu_interface alu_interface_unit);
enviroment test_enviroment;

initial begin
    test_enviroment = new(alu_interface_unit);
    test_enviroment.gen.repeat_count = 20;
    test_enviroment.run();
end
endprogram




