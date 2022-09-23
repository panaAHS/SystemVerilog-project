module test_UpDownCounter;

bit rst_ = 1;
bit ld_cnt = 1;
bit clk, updn_cnt, count_enb;
bit [15:0] data_in;
wire [15:0] data_out;

UpDownCounter dut(.rst_(rst_), .clk(clk), .ld_cnt(ld_cnt), .updn_cnt(updn_cnt), .count_enb(count_enb), .data_in(data_in), .data_out(data_out));
bind dut SVA_UpDownCounter pdut (.clk(clk), .rst_(rst_), .ld_cnt(ld_cnt), .count_enb(count_enb), .updn_cnt(updn_cnt), .data_out(data_out));

always #1 clk = ~clk; //period 2 t.u. (ns)

always @(posedge clk)
 $display($stime,,,"clk=%b rst_=%b ld_cnt=%b updn_cnt=%b count_enb=%b data_out=%d",clk, rst_, ld_cnt, updn_cnt, count_enb, data_out);

initial
begin
updn_cnt = 0;
count_enb = 0;
data_in = 16'b1111111;
rst_ = 0;
#2 rst_ = 1;
count_enb = 1;
updn_cnt = 1;
#20 count_enb = 0;
#4 ld_cnt = 0;
#2 ld_cnt = 1;
#12 rst_ = 0;
#2 rst_ = 1;
#8 count_enb = 1;
#12 updn_cnt = 0;
#22 ld_cnt = 0;
#2 ld_cnt = 1;
#4 count_enb = 0;
#4 rst_ = 0;
#2 $finish;
end
endmodule
