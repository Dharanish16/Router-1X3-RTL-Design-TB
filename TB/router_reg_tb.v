
module router_reg_tb();
         reg[7:0]data_in;
			reg clock,resetn,pkt_valid,fifo_full,detect_add,ld_state,laf_state,full_state,
			    lfd_state,rst_int_reg;
			wire[7:0]dout;
			wire err,parity_done,low_packet_valid;
			
			parameter cycle = 10;
			integer i;
			
			router_reg DUT(clock,resetn,pkt_valid,data_in,fifo_full,detect_add,ld_state,full_state,
                        laf_state,lfd_state,rst_int_reg,err,parity_done,low_packet_valid,dout);
			
			//clock generation
			always 
			   begin
				   #(cycle/2) clock = 1'b0;
					#(cycle/2) clock = 1'b1;
			   end
				
		   //reset task
			task rst;
			   begin
				  @(negedge clock)
				     resetn = 1'b0;
				  @(negedge clock)
				     resetn = 1'b1;
				end
			endtask
			
			//initialization task
			task initialize;
			   begin
				   {pkt_valid,fifo_full,detect_add,ld_state,laf_state,full_state,
					 lfd_state,rst_int_reg} = 8'b0;
				end
			endtask
			
			//packet generation task
			task packet_generation;
			      reg[7:0]header,payload_data,parity;
					reg[5:0]payload_len;
					reg[1:0]addr;
					begin
					    @(negedge clock)
						 payload_len = 6'd5;
						 addr = 2'b10;
						 pkt_valid = 1'b1;
						 detect_add = 1'b1;
						 header = {payload_len,addr};
						 data_in = header;
						 parity = 8'b0 ^ header;
						 @(negedge clock)
						 detect_add = 1'b0;
						 lfd_state = 1'b1;
						 full_state = 1'b0;
						 fifo_full = 1'b0;
						 laf_state = 1'b0;
						 for(i=0;i<payload_len;i=i+1)
						     begin
							     @(negedge clock)
								      lfd_state = 1'b0;
										ld_state = 1'b1;
										payload_data = {$random}%256;
										data_in = payload_data;
										parity = parity ^ data_in;
							  end
						 @(negedge clock)
						 pkt_valid = 1'b0;
						 data_in = parity;
						 @(negedge clock)
						 ld_state = 1'b0;
				  end
		   endtask
			
			initial
			    begin
				    initialize;
					 #10;
					 rst;
					 #10;
					 packet_generation;
				 end
endmodule
