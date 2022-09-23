module test_synchronous_FIFO
#(parameter width = 16, size_bits = 4, depth = 16)();
bit rst_ = 1;
bit clk, fifo_write, fifo_read;

bit [width-1:0] fifo_data_in;
wire [width-1:0] fifo_data_out;
wire fifo_full, fifo_empty;


synchronous_FIFO #(.width(width), .depth(depth), .size_bits(size_bits)) dut(.rst_(rst_), .clk(clk), .fifo_write(fifo_write), .fifo_read(fifo_read), .fifo_data_in(fifo_data_in), .fifo_data_out(fifo_data_out), .fifo_full(fifo_full), .fifo_empty(fifo_empty));
bind dut SVA_synchronous_FIFO #(.width(width), .depth(depth), .size_bits(size_bits)) pdut(.clk(clk), .rst_(rst_), .fifo_write(fifo_write), .fifo_read(fifo_read), .fifo_full(fifo_full), .fifo_empty(fifo_empty), .fifo_data_out(fifo_data_out), .cnt(dut.cnt), .wr_ptr(dut.wr_ptr), .rd_ptr(dut.rd_ptr));

always #1 clk = ~clk; //period 2 t.u. (ns)

always @(posedge clk)
$display($stime,,,"clk=%b rst_=%b fifo_write=%b fifo_read=%b fifo_data_in=%d fifo_data_out=%d fifo_full=%b fifo_empty=%b cnt=%d wr_ptr=%d rd_ptr=%d",clk, rst_, fifo_write, fifo_read, fifo_data_in, fifo_data_out, fifo_full, fifo_empty, dut.cnt, dut.wr_ptr, dut.rd_ptr);

initial
begin
fifo_write = 0;
fifo_read = 0;
fifo_data_in = 16'b0000011;
rst_ = 0;
#2 rst_ = 1;
fifo_write = 1;
#2 fifo_data_in = 16'b0000010;
#2 fifo_data_in = 16'b0000011;
#2 fifo_data_in = 16'b0000100;
#2 fifo_data_in = 16'b0000101;
#2 fifo_data_in = 16'b0000110;
#2 fifo_write = 0;
fifo_read = 1;
#4 fifo_write = 1;
fifo_read = 0;
#2 fifo_data_in = 16'b0000100;
#2 fifo_data_in = 16'b0000101;
#2 fifo_data_in = 16'b0000110;
#2 fifo_data_in = 16'b0000111;
#2 fifo_data_in = 16'b0001000;
#2 fifo_data_in = 16'b0001001;
#2 fifo_data_in = 16'b0001010;
#2 fifo_data_in = 16'b0001011;
#2 fifo_write = 0;
fifo_read = 1;
#28 fifo_write = 1;
fifo_read = 0;
#2 fifo_data_in = 16'b0100010;
#2 fifo_data_in = 16'b0100011;
#2 fifo_data_in = 16'b0100100;
#2 fifo_data_in = 16'b0100101;
#2 fifo_data_in = 16'b0100110;
#2 fifo_data_in = 16'b0100111;
#2 fifo_data_in = 16'b0101000;
#2 fifo_data_in = 16'b0101001;
#2 fifo_data_in = 16'b0101010;
#2 fifo_data_in = 16'b0111011;
#2 fifo_data_in = 16'b0110010;
#2 fifo_data_in = 16'b0110011;
#2 fifo_data_in = 16'b0110100;
#2 fifo_data_in = 16'b0110101;
#2 fifo_data_in = 16'b0110110;
#2 fifo_data_in = 16'b0110111;
#2 fifo_data_in = 16'b0111000;
#2 fifo_data_in = 16'b0111001;
#2 fifo_data_in = 16'b0111010;
#2 fifo_data_in = 16'b0111011;
#2 fifo_write = 0;
fifo_read = 1;
#36 fifo_write = 1;
fifo_read = 0;
#2 fifo_data_in = 16'b0111010;
#2 fifo_data_in = 16'b0111011;
#2 fifo_data_in = 16'b0110111;
#2 fifo_data_in = 16'b0111000;
#2 fifo_write = 0;
fifo_read = 0;
#2 fifo_data_in = 16'b0111001;
#2 fifo_data_in = 16'b0111010;
fifo_read = 1;
fifo_write = 1;
#2 fifo_data_in = 16'b0111011;
#8 fifo_write = 0;
#14 fifo_read = 0;
fifo_write = 1;
fifo_data_in = 16'b1111011;
#2 fifo_write = 0;
fifo_read = 1;
#2 rst_ = 0;
#2 $finish;
end

endmodule