module SVA_UpDownCounter(input clk, rst_, ld_cnt, count_enb, updn_cnt, input [15:0] data_out);
property rst1;
	@(negedge rst_) 1'b1 |=> @(posedge clk)  (data_out == 0);  //When reset is asserted, then the output of the counter is zero 

endproperty

property p1;
	@(posedge clk) disable iff(!rst_) (ld_cnt && !count_enb) |=> $stable(data_out);  //If ld_cnt is deasserted and count_enb is not enabled the counter output does not changea. This property should be disabled when rst is active (low) 
endproperty                                                                                         
property p2;
	@(posedge clk) disable iff(!rst_) (ld_cnt && count_enb) |-> if(updn_cnt) ##1 (data_out ==  $past(data_out, 1) + 1'b1)  else ##1 (data_out ==  $past(data_out, 1) - 1'b1);   /*If ld_cnt is deasserted and count_enb is enabled then if updn_cnt is high, the counter increments and if updn_cnt is low, the counter decrements, this property should be disabled when rst is active (low). */
endproperty

reset1: assert property (rst1) else $display($time,,, "\t\t %m FAIL");
reset: cover property(rst1) $display($time,,, "\t\t %m PASS");

propert1: assert property (p1) else $display($time,,, "\t\t %m FAIL");
property1: cover property (p1) $display($time,,, "\t\t %m PASS");

propert2: assert property (p2) else $display($time,,, "\t\t %m FAIL");
property2: cover property (p2) $display($time,,, "\t\t %m PASS");
endmodule


