module SVA_synchronous_FIFO
#(parameter width = 16, size_bits = 4, depth = 16)
(input clk, rst_, fifo_write, fifo_read, fifo_full, fifo_empty, input [width-1:0] fifo_data_out, input [size_bits:0] cnt, input [size_bits-1:0] wr_ptr, rd_ptr);
property rst1;
	@(negedge rst_) 1'b1 |=> @(posedge clk)  ((fifo_empty == 1) && (fifo_full == 0) && (cnt == 0) && (rd_ptr==0) && (wr_ptr==0));
	//On reset, the read and write pointers are zero, empty and full indicators are ?1? and ?0?,respectively (since the memory is indeed empty), and the counter is zero as well.
endproperty

property p2;
	@(posedge clk) disable iff(!rst_) cnt == 0 |-> fifo_empty; // The fifo empty signal is asserted whenever cnt = 0. Disable this property if the reset is active.
endproperty
property p3;
	@(posedge clk) disable iff(!rst_) cnt >= 16  |-> fifo_full; //The fifo full signal is asserted whenever cnt >= 16. Disable this property if the reset is active.
endproperty
property p4;
	@(posedge clk) /*disable iff(!rst_)*/ (fifo_full && fifo_write && !fifo_read) |=>  $stable(wr_ptr); //If the FIFO is full and there is write request (but not read), then the write pointer should not change.
endproperty
property p5;
	@(posedge clk) /*disable iff(!rst_)*/ (fifo_empty && !fifo_write && fifo_read) |=>  $stable(rd_ptr); //If the FIFO is empty and there is read request (but not write), then the read pointer should not change. 
endproperty

reset: assert property (rst1) else $display($time,,, "\t\t %m FAIL");
reset1: cover property (rst1) $display($time,,, "\t\t %m PASS");
property2: assert property (p2) else $display($time,,, "\t\t %m FAIL");
propert2: cover property (p2) $display($time,,, "\t\t %m PASS");
property3: assert property (p3) else $display($time,,, "\t\t %m FAIL");
propert3: cover property (p3) $display($time,,, "\t\t %m PASS");
property4: assert property (p4) else $display($time,,, "\t\t %m FAIL");
propert4: cover property (p4) $display($time,,, "\t\t %m PASS");
property5: assert property (p5) else $display($time,,, "\t\t %m FAIL");
propert5: cover property (p5) $display($time,,, "\t\t %m PASS");
endmodule

/*property p2;
	@(posedge clk) disable iff(!rst_)  fifo_empty |-> cnt == 0;
endproperty
property p3;
	@(posedge clk) disable iff(!rst_) fifo_full |-> cnt >= 16;
endproperty*/

/*reset: assert property (rst1) $display($time,,, "\t\t %m PASS"); else $display($time,,, "\t\t %m FAIL");

property2: assert property (p2) $display($time,,, "\t\t %m PASS"); else $display($time,,, "\t\t %m FAIL");

property3: assert property (p3) $display($time,,, "\t\t %m PASS"); else $display($time,,, "\t\t %m FAIL");

property4: assert property (p4) $display($time,,, "\t\t %m PASS"); else $display($time,,, "\t\t %m FAIL");

property5: assert property (p5) $display($time,,, "\t\t %m PASS"); else $display($time,,, "\t\t %m FAIL");*/
