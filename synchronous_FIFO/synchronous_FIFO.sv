module synchronous_FIFO
#(parameter width = 16, size_bits = 4, depth = 16)
(input logic clk, rst_, fifo_write, fifo_read, input logic [width-1:0] fifo_data_in, output logic [width-1:0] fifo_data_out, output logic fifo_full, fifo_empty);

logic[size_bits-1:0] wr_ptr; 
logic[size_bits-1:0] rd_ptr;
logic [size_bits:0] cnt;

logic [width-1:0]fifo_memory[depth-1:0];

always_comb
begin
	if(cnt == 0)
		fifo_empty = 1; //if fifo is empty (cnt = 0), fifo_empty asserted (active high) 
	else 
		fifo_empty = 0; //else fifo_empty deasserted

        if(cnt == depth)
		fifo_full = 1; //if fifo is full (cnt = 16), fifo_full asserted (active high) 
	else
		fifo_full = 0;//else fifo_full deasserted
end
always_ff @(posedge clk, negedge rst_) //The cnt operates on a positive edge clock and has an asynchronous active low reset
begin
	if(!rst_)
		cnt <= 0; //On reset, cnt is zero
	else if((fifo_write && !fifo_full) && (fifo_read && !fifo_empty))
		cnt <= cnt; //the cnt does not change, each time there is write request and the FIFO is not full and there is read request and the FIFO is not empty 
	else if(fifo_write && !fifo_full)
		cnt <= cnt + 1;  //counter (cnt) increments on a write event, each time there is write request and the FIFO is not full 
	else if(fifo_read && !fifo_empty)
		cnt <= cnt - 1; //counter (cnt) decrements on a event, each time there is read request and the FIFO is not empty 
	else 
		cnt <= cnt;  //else the cnt does not change
end


always_ff @(posedge clk, negedge rst_) //The FIFO operates on a positive edge clock and has an asynchronous active low reset
begin
	if(!rst_)
		fifo_data_out <= 0; //On reset, fifo_data_out is zero
	else if(fifo_read && !fifo_empty)
		fifo_data_out <= fifo_memory[rd_ptr]; //if there is read request and the FIFO is not empty,  outputs the fifo_memory[rd_ptr] data
	else
		fifo_data_out <= fifo_data_out; //else the fifo_data_out does not change
end

always_ff @(posedge clk, negedge rst_) //The FIFO operates on a positive edge clock and has an asynchronous active low reset
begin
	if(fifo_write && !fifo_full) 
		fifo_memory[wr_ptr] <=  fifo_data_in; //if there is write request and the FIFO is not full, the input data is loaded to fifo_memory[wr_ptr]
	else
		fifo_memory[wr_ptr] <= fifo_memory[wr_ptr];  //else the fifo_memory[wr_ptr] does not change
end

always_ff @(posedge clk, negedge rst_)
begin
	if(!rst_)
	begin
		wr_ptr <= 0; //On reset, the write pointer is zero
		rd_ptr <= 0;//On reset, the read pointer is zero
	end
	else
	begin
		if(fifo_write && !fifo_full)
			wr_ptr <= wr_ptr + 1; //The write pointer increments by 1, each time there is write request and the FIFO is not full 
		else
			wr_ptr <= wr_ptr;  //else the wr_ptr t does not change

		if(fifo_read && !fifo_empty)
			rd_ptr <= rd_ptr + 1; //The read pointer increments by 1, each time there is read request and the FIFO is not empty 
		else
			rd_ptr <= rd_ptr;    //else the rd_ptr does not change
	end
end
endmodule
