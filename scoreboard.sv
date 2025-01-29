//`include "transaction.sv"

class scoreboard;
	
    mailbox mon_dut;
    int trans_cnt = 0;
	int ended;
    function new(mailbox mon_dut);
        this.mon_dut = mon_dut;
    endfunction

    task main;
        transaction trans;
        forever begin
            mon_dut.get(trans);
          	trans_cnt++;
          if(ended == 1)
           		break;
          if(trans.reset)
            begin
              if(trans.acu_output == 8'd0 && trans.reg_file_adr == 2'd0)
                $display("Poprawnie przeprowadzono reset");
              else 
                $display("Niepoprawnie przeprowadzono reset");
              break;
            end

          if(trans.data_memory_read_enable)begin
            if(trans.o_alu_argument == trans.data_memory)
              $display("[SCOREBOARD] Poprawnie odczytano zawartosc pamieci danych");
            else
              $display("[SCOREBOARD] Nie poprawnie odczytano zawartosc pamieci danych");
            end
          else begin
             if(trans.o_alu_argument == trans.register_file_output)
               $display("[SCOREBOARD] Poprawnie odczytano zawartosc rejestru danych");
            else
              $display("[SCOREBOARD] Nie poprawnie odczytano zawartosc rejestru danych");
          end

          if (trans.alu_result != expected_alu_result(trans)) begin
            $display("[SCOREBOARD] Blad! Oczekiwano %h, otrzymano %h, acu: %h, arg: %h, op: %h", expected_alu_result(trans), trans.alu_result, trans.acu_output, trans.o_alu_argument, trans.opcode);
            end else begin
              $display("[SCOREBOARD] OK! Otrzymano poprawny wynik: %h, acu: %h, arg: %h, op: %h", trans.alu_result, trans.acu_output, trans.o_alu_argument, trans.opcode);
            end
        end
    endtask
   task acu_scb;
        transaction trans;
        forever begin
            mon_dut.get(trans);
            trans_cnt++;
          if(!trans.data_memory_read_enable && trans.acumulator_ce && !trans.direct_load) begin
          if (trans.acu_output == trans.alu_result) begin
              $display("[SCOREBOARD_AKU] OK! Poprawnie wpisano wartosc do akumulatora, acu: %h, alu_res odczytane takt zegara wczesniej: %h",
                         trans.acu_output, trans.alu_result);
            end else begin
              $display("[SCOREBOARD_AKU] Bład! Niepoprawnie wpisano wartosc do akumulatora, acu: %h, alu_res odczytane takt zegara wczesniej: %h",
                         trans.acu_output, trans.alu_result);
            	end
        	end
          if(!trans.data_memory_read_enable && !trans.acumulator_ce && !trans.direct_load) begin
            if(trans.previous_acu == trans.acu_output)
              $display("[SCOREBOARD_AKU] OK! Wartosc acu nie zmienila sie");
            else
              $display("[SCOREBOARD_AKU] Blad! Wartosc acu zmienila sie");
          end
          if(!trans.data_memory_read_enable && trans.acumulator_ce && trans.direct_load) begin
            if(trans.data_direct == trans.acu_output)
              $display("[SCOREBOARD_AKU] OK! Wpisano wartosc natychmiastowa");
            else
              $display("[SCOREBOARD_AKU] Blad! Nie wpisano wartosc natychmiastowa");
          end
        end
    endtask
  /*
  task acu_scb;
        transaction trans;
        forever begin
            mon_dut.get(trans);
            trans_cnt++;

          if (trans.acu_output == trans.alu_result) begin
              $display("[SCOREBOARD_AKU] OK! Poprawnie wpisano wartosc do akumulatora, acu: %h, alu_res odczytane takt zegara wczesniej: %h",
                         trans.acu_output, trans.alu_result);
            end else begin
              $display("[SCOREBOARD_AKU] Bład! Niepoprawnie wpisano wartosc do akumulatora, acu: %h, alu_res odczytane takt zegara wczesniej: %h",
                         trans.acu_output, trans.alu_result);
            end
        end
    endtask
  */
  function bit [7:0] expected_alu_result(transaction trans);
        case (trans.opcode)
            3'b000: return trans.acu_output + trans.o_alu_argument;
            3'b001: return trans.acu_output - trans.o_alu_argument;
            3'b010: return trans.acu_output & trans.o_alu_argument;
            3'b011: return trans.acu_output | trans.o_alu_argument;
            3'b100: return trans.acu_output ^ trans.o_alu_argument;
          	3'b101: return ~(trans.o_alu_argument);
          	3'b110: return trans.o_alu_argument;
          	3'b111: return trans.o_alu_argument;
        endcase   
    endfunction
endclass





