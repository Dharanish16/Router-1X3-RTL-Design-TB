
module router_fsm_tb();
       //port declarations for tb
       reg [1:0]data_in;
       reg clock,resetn,pkt_valid,fifo_full,fifo_empty_0,fifo_empty_1,fifo_empty_2,
		     soft_reset_0,soft_reset_1,soft_reset_2,parity_done,low_packet_valid;
		 wire write_enb_reg,detect_add,ld_state,lfd_state,full_state,rst_int_reg,busy;
		 
		 //router_fsm_instantiation
		 router_fsm DUT(clock,resetn,pkt_valid,data_in,fifo_full,fifo_empty_0,fifo_empty_1,
                  fifo_empty_2,soft_reset_0,soft_reset_1,soft_reset_2,parity_done,
						low_packet_valid,write_enb_reg,detect_add,ld_state,laf_state,lfd_state,
						full_state,rst_int_reg,busy);
		 
		 parameter cycle = 10;
		 //clock generation
		 always
		    begin
			    #(cycle/2) clock = 1'b0;
				 #(cycle/2) clock = 1'b1;
			 end
			 
		 //resetn task
		 task rst;
		    begin
			    @(negedge clock)
				     resetn = 1'b0;
				 @(negedge clock)
				     resetn = 1'b1;
			 end
		 endtask
		 
		 //task t1
		 task t1;
		     begin
			     @(negedge clock)
				  pkt_valid = 1'b1;
				  data_in = 2'b00;
				  fifo_empty_0 = 1'b1;
				  @(negedge clock)
				  @(negedge clock)
				  fifo_full = 1'b0;
				  pkt_valid = 1'b0;
				  @(negedge clock)
				  fifo_full = 1'b0;
			 end
		 endtask
		 
		 //task t2
		 task t2;
		     begin
			     @(negedge clock)
				  pkt_valid = 1'b1;
				  data_in = 2'b00;
				  fifo_empty_0 = 1'b1;
				  @(negedge clock)
				  @(negedge clock)
				  fifo_full = 1'b1;
				  @(negedge clock)
				  fifo_full = 1'b0;
				  @(negedge clock)
				  parity_done = 1'b0;
				  low_packet_valid = 1'b0;
				  @(negedge clock)
				  fifo_full = 1'b0;
			 end
		endtask
		
		initial 
		    begin
			    rst;
				 @(negedge clock)
				 t1;
				 @(negedge clock)
				 t2;
			 end
endmodule
				 
				  
		 
		 
			  