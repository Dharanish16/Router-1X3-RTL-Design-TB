module top();

	import router_pkg::*;
	import uvm_pkg::*;
	
	bit clock;
	
	always 
		#10 clock = ~clock;
					// add the istance of interfaces
	router_if src_if0(clock);

	router_if dst_if0(clock);
	router_if dst_if1(clock);
	router_if dst_if2(clock);
					//add the router design top
	top_module_router DUV(.clk(clock),.rstn(src_if0.rstn),
					  	.pkt_valid(src_if0.pkt_valid),
						.read_enb_0(dst_if0.read_enb),.read_enb_1(dst_if1.read_enb),.read_enb_2(dst_if2.read_enb),
					  	.data_in(src_if0.data_in),
						.dout_0(dst_if0.dout),.dout_1(dst_if1.dout),.dout_2(dst_if2.dout),
						.vld_out_0(dst_if0.vld_out),.vld_out_1(dst_if1.vld_out),.vld_out_2(dst_if2.vld_out),
						.err(src_if0.err),.busy(src_if0.busy));

	initial begin 
	
	`ifdef VCS
		$fsdbDumpvars(0,top);
	`endif
	
		uvm_config_db #(virtual router_if)::set(null,"*","src_if0",src_if0);
		uvm_config_db #(virtual router_if)::set(null,"*","dst_if0",dst_if0);
		uvm_config_db #(virtual router_if)::set(null,"*","dst_if1",dst_if1);
		uvm_config_db #(virtual router_if)::set(null,"*","dst_if2",dst_if2);
		
			run_test();
	end

property STABLE;
	@(posedge clock) src_if0.busy |=> $stable(src_if0.data_in);
endproperty

property LFD;
	@(posedge clock) $rose(src_if0.pkt_valid) |=> $rose(src_if0.busy);
endproperty

property VALID;
	@(posedge clock) $rose(src_if0.pkt_valid) |=> ##2 (dst_if0.vld_out | dst_if1.vld_out | dst_if2.vld_out);
endproperty

property READ_ENB0;
	@(posedge clock) (dst_if0.vld_out) |-> ##[1:29] (dst_if0.read_enb);
endproperty

property READ_ENB1;
	@(posedge clock) dst_if1.vld_out |-> ##[1:29] dst_if1.read_enb;
endproperty

property READ_ENB2;
	@(posedge clock) dst_if2.vld_out |-> ##[1:29] dst_if2.read_enb;
endproperty

property READ_ENB_LOW0;
	@(posedge clock) ($fell(dst_if0.vld_out)) |=> ( $fell(dst_if0.read_enb));
endproperty


property READ_ENB_LOW1;
	@(posedge clock) $fell(dst_if1.vld_out) |=> $fell(dst_if1.read_enb);
endproperty

property READ_ENB_LOW2;
	@(posedge clock) $fell(dst_if2.vld_out) |=> $fell(dst_if2.read_enb);
endproperty

CP1 : cover property (STABLE);
CP2 : cover property (LFD);
CP3 : cover property (VALID);
CP4 : cover property (READ_ENB0);
CP5 : cover property (READ_ENB1);
CP6 : cover property (READ_ENB2);
CP7 : cover property (READ_ENB_LOW0);
CP8 : cover property (READ_ENB_LOW1);
CP9 : cover property (READ_ENB_LOW2);

AP1 : assert property (STABLE) $display("Assertion of STABLE is sucessfull"); 			else $error("STABLE failed");
AP2 : assert property (LFD) $display("Assertion of LFD is sucessfull"); 			else $error("LFD failed");
AP3 : assert property (VALID) $display("Assertion of VALID is sucessfull"); 			else $error("VALID failed");
AP4 : assert property (READ_ENB0) $display("Assertion of READ_ENB0 is sucessfull"); 		else $error("READ_ENB0 failed");
AP5 : assert property (READ_ENB1) $display("Assertion of READ_ENB1 is sucessfull"); 		else $error("READ_ENB1 failed");
AP6 : assert property (READ_ENB2) $display("Assertion of READ_ENB2 is sucessfull"); 		else $error("READ_ENB2 failed");
AP7 : assert property (READ_ENB_LOW0) $display("Assertion of READ_ENB_LOW0 is sucessfull"); 	else $error("READ_ENB_LOW0 failed");
AP8 : assert property (READ_ENB_LOW1) $display("Assertion of READ_ENB_LOW1 is sucessfull"); 	else $error("READ_ENB_LOW1 failed");
AP9 : assert property (READ_ENB_LOW2) $display("Assertion of READ_ENB_LOW2 is sucessfull"); 	else $error("READ_ENB_LOW2 failed");
endmodule
