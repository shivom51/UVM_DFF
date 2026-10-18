// uvm component class
class dff_scoreboard extends uvm_scoreboard ;
  `uvm_component_utils(dff_scoreboard) // reg class to uvm factory
  dff_seq_item tx_q[$];//queue

  uvm_analysis_imp #(dff_seq_item, dff_scoreboard) item_collected_export;


  //standard constructor
  function new(string name ="dff_scoreboard", uvm_component parent);
    super.new(name, parent);
    `uvm_info("scoreboard Class", "constructor", UVM_MEDIUM)
  endfunction
  
    //build phase
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    item_collected_export = new("item_collected_export", this);

  endfunction
  
  // write task - recives the pkt from monitor and pushes into queue
  virtual function void write(dff_seq_item tx);
    tx_q.push_back(tx);
  endfunction
  
  task run_phase(uvm_phase phase);
    dff_seq_item tx;
    forever begin
      wait(tx_q.size()>0);
      tx = tx_q.pop_front();
      //#10;
     // `uvm_info("scoreboard Class", "run_phase", UVM_MEDIUM)
      if (tx.d == tx.q) begin
        `uvm_info("scoreboard Class", "...PASS...", UVM_MEDIUM) 
        `uvm_info("SCB",$sformatf("tx.d =%b,  tx.q=%b",tx.d,tx.q), UVM_NONE)
                  //$display("PASS"); 
       end
      else  begin
        `uvm_info("scoreboard Class", "...FAIL...", UVM_MEDIUM) 
        `uvm_info("SCB",$sformatf("tx.d =%b,  tx.q=%b",tx.d,tx.q), UVM_NONE)


        //$display("Fail");
      end
    end
  endtask
  
  
  
endclass