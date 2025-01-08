
module router_top_tb();
      reg clock,resetn,pkt_valid,read_enb_0,read_enb_1,read_enb_2;
		reg [7:0]data_in;
		wire [7:0]data_out_0,data_out_1,data_out_2;
		
		parameter cycle = 10;
		integer i;
		
		router_top DUT(clock,resetn,data_in,read_enb_0,read_enb_1,read_enb_2,pkt_valid,data_out_0,
                  data_out_1,data_out_2,vld_out_0,vld_out_1,vld_out_2,err,busy);
						
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
			    read_enb_0 = 1'b0;
				 read_enb_1 = 1'b0;
				 read_enb_2 = 1'b0;
			 end
		endtask 
		
		//packet generation payload < 14
		task packet_generation_1;	// packet generation payload 8
			reg [7:0]header, payload_data, parity;
			reg [5:0]payloadlen;
			
			begin
				parity=0;
				wait(!busy)
				begin
				@(negedge clock);
				payloadlen=8;
				pkt_valid=1'b1;
				header={payloadlen,2'b10};
				data_in=header;
				parity=parity^data_in;
				end
				@(negedge clock);
							
				for(i=0;i<payloadlen;i=i+1)
					begin
					wait(!busy)				
					@(negedge clock);
					payload_data={$random}%256;
					data_in=payload_data;
					parity=parity^data_in;				
					end					
								
				wait(!busy)				
					@(negedge clock);
					pkt_valid=0;				
					data_in=parity;
					repeat(2)
			@(negedge clock);
			read_enb_2=1'b1;
			end
       endtask
		
		//packet generation payload > 14
		task packet_generation_2;	// packet generation payload 8
			reg [7:0]header, payload_data, parity;
			reg [5:0]payloadlen;
			
			begin
				parity=0;
				wait(!busy)
				begin
				@(negedge clock);
				payloadlen=16;
				pkt_valid=1'b1;
				header={payloadlen,2'b01};
				data_in=header;
				parity=parity^data_in;
				end
				@(negedge clock);
							
				for(i=0;i<payloadlen;i=i+1)
					begin
					wait(!busy)				
					@(negedge clock);
					payload_data={$random}%256;
					data_in=payload_data;
					parity=parity^data_in;				
					end					
								
				wait(!busy)				
					@(negedge clock);
					pkt_valid=0;				
					data_in=parity;
					repeat(2)
			@(negedge clock);
			read_enb_1=1'b1;
			end
		endtask
		
		initial
		   begin
			   initialize;
				#10;
				rst;
				#10;
				packet_generation_1;
				#10;
				packet_generation_2;
		   end
endmodule

				  