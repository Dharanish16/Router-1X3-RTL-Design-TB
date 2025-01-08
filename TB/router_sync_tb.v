
module router_sync_tb();
      reg [1:0]data_in;
      reg clock,resetn,detect_add,full_0,full_1,full_2,empty_0,empty_1,empty_2,write_enb_reg,read_enb_0,read_enb_1,read_enb_2;
		wire vld_out_0,vld_out_1,vld_out_2,soft_reset_0,soft_reset_1,soft_reset_2,fifo_full;
		wire [2:0]write_enb;
      parameter cycle = 10;
      
      router_sync DUT(clock,resetn,data_in,detect_add,full_0,full_1,full_2,empty_0,empty_1,empty_2,write_enb_reg,read_enb_0,read_enb_1,read_enb_2,
                   vld_out_0,vld_out_1,vld_out_2,fifo_full,soft_reset_0,soft_reset_1,soft_reset_2,write_enb);
      
      //clock generation
      always
          begin
             #(cycle/2) clock = 1'b0;
             #(cycle/2) clock = 1'b1;
          end
      
      //task reset
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
			    data_in = 2'b00;
				 detect_add = 1'b0;
				 {full_0,full_1,full_2} = 3'b000;
				 {empty_0,empty_1,empty_2} = 3'b000;
				 write_enb_reg = 1'b0;
				 {read_enb_0,read_enb_1,read_enb_2} = 3'b000;
			 end
		endtask
				 

      //task for detect_add
		task detect_address;
		    input address_signal;
			 begin
			    @(negedge clock)
				      detect_add = address_signal;
			 end
		endtask
		
		//task for data_in
		task address;
		   input [1:0]rx_address;
			begin
			   @(negedge clock)
				   data_in = rx_address;
			end
		endtask
		
		//task for empty
		task empty_status;
		    input e0,e1,e2;
			 begin
			    empty_0 = e0;
				 empty_1 = e1;
				 empty_2 = e2;
			 end
	   endtask
		 
		//task for read_enb
		task read_signal;
		    input r0,r1,r2;
			 begin
			    {read_enb_0,read_enb_1,read_enb_2} = {r0,r1,r2};
			 end
		endtask
		
		//task for write_enb_reg
		task write_signal;
		    begin
			    write_enb_reg = 1'b1;
			 end
		endtask
		
		//task for delay
		task delay;
		    begin
				 @(negedge clock);
			 end
		endtask
		
		
		initial
		   begin
			   initialize;
				delay;
				rst;
				detect_address(1);
				address(2'b10);
				write_signal;
				empty_status(1,1,0);
				read_signal(0,0,0);
				repeat(40)
				delay;
				read_signal(0,0,1);
				#1000;
		 end
endmodule
				
		