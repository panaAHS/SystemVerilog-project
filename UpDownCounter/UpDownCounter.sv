module UpDownCounter(input logic clk, rst_, ld_cnt, updn_cnt, count_enb, input logic [15:0] data_in, output logic [15:0] data_out);

always_ff @(posedge clk, negedge rst_) //The counter operates on a positive edge clock and has an asynchronous active low reset.
begin
	if(!rst_)  //Active low reset
		data_out <= 16'b0;
	else if(!ld_cnt) //A load operation has higher priority over count_enb 
		data_out <= data_in;  //if ld_cnt is  low, the input data is loaded and outputs this data. 
	else if(count_enb) //if count_enb is high 
		begin
		if(updn_cnt) 
			data_out <= data_out + 1'b1; //if updn_cnt is high, count up 
		else
			data_out <= data_out - 1'b1; //if updn_cnt is low, count down 
		end
	else 
		data_out <= data_out;  //in other cases the counter maintains its data stable
end
endmodule