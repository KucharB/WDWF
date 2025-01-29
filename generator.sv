`include "transaction.sv"

class generator;
    rand transaction trans;
    mailbox generator_to_driver;
    int repeat_count;
    event ended;

    function new(mailbox gen_driv, event ended);
        this.generator_to_driver = gen_driv;
        this.ended = ended;
    endfunction

task main();
    repeat(repeat_count) begin
        trans = new();
        trans.randomize();
        generator_to_driver.put(trans);
    end 
    -> ended;
endtask

endclass





