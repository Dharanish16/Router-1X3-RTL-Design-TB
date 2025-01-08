
module router_fifo_tb();
     parameter width = 9;
	  reg [width-2:0]data_in;
	  reg clock,resetn,read_enb,write_enb,soft_reset,lfd_state;
	  wire [width-2:0]data_out;
	  integer k;
	  
	  parameter cycle = 10;
	  
	  router_fifo DUT(clock,resetn,data_in,read_enb,write_enb,data_out,full,empty,lfd_state,soft_reset);
	  
	  //clock
	  always
	     begin
		    #(cycle/2) clock = 1'b0;
			 #(cycle/2) clock = 1'b1;
		  end
	  
	  //reset
	  task rst;
	     begin
		    @(negedge clock)
			    resetn = 1'b0;
			 @(negedge clock)
			    resetn = 1'b1;
		  end
	  endtask
	  
	  //soft_reset
	  task soft_rst;
	     begin
		     @(negedge clock)
			     soft_reset = 1'b1;
			  @(negedge clock)
			     soft_reset = 1'b0;
		  end
	  endtask 
	  
	  //initialize
	  task initialize;
	     begin
		    read_enb = 0;
			 write_enb = 0;
		  end
	  endtask 
	  
	  //write 
	  task write;
	      reg [7:0]payload_data,parity,header;
         reg [5:0]payload_len;
         reg [1:0]addr;	
            begin
            @(negedge clock)
            payload_len = 6'd14;
            addr = 2'b01;
            header = {payload_len,addr};					  
	         data_in = header;
				lfd_state = 1'b1;
			   write_enb = 1'b1;
				for(k=0;k<payload_len;k=k+1)
				   begin
					   @(negedge clock)
						lfd_state = 1'b0;
						payload_data = {$random}%256;
						data_in = payload_data;
				   end
				@(negedge clock)
				parity = $random;
				data_in = parity;
				end
	  endtask
	  
	  initial
	     begin
		     initialize;
			  rst;
			  soft_rst;
			  write;
			  repeat(5)
			  @(negedge clock)
			  write_enb = 1'b0;
			  read_enb = 1'b1;
		 end
		 
	 initial
	    $monitor("soft_reset=%b, lfd_state=%b, full=%b, empty=%b, data_in=%b, data_out=%b, resetn=%b, read_enb=%b, write_enb=%b",soft_reset,lfd_state,full,empty,data_in,data_out,resetn,read_enb,write_enb);
endmodule

			  