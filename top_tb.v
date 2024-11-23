`timescale 1ns / 1ps

module top_tb();

reg clk, rst;

reg req;
reg [31:0] wdata;
reg [31:0] addr;
reg we;
wire [31:0] rdata;
wire gnt;

reg [31:0] wishbone_addr;
reg [31:0] wishbone_m_data;
wire [31:0] wishbone_s_data;
reg wishbone_we;
reg [3:0] wishbone_sel;
reg wishbone_stb;
wire wishbone_ack;
reg wishbone_cyc;

reg valid_q;
always @(posedge clk) begin
   valid_q = wishbone_cyc & wishbone_stb & wishbone_ack;
end
wire valid = wishbone_cyc & wishbone_stb & wishbone_ack;
wire ready = (~wishbone_stb | ~wishbone_cyc) | (valid);

integer i;
initial begin
    $dumpfile("top_tb.vcd");
    $dumpvars(0, top_tb);
    
    req <= 0;
    wdata <= 0;
    addr <= 0;
    we <= 0;

    rst <= 1;
    clk <= 0;
    #10
    rst <= 0;

    req <= 1;
    wdata <= 32'h11223344;
    addr <= 0;
    we <= 1;
    #20
    req <= 0;
    wdata <= 0;
    addr <= 0;
    we <= 0;
    #100

    req <= 1;
    wdata <= 32'h55667788;
    addr <= 1;
    we <= 1;
    #20
    req <= 0;
    wdata <= 0;
    addr <= 0;
    we <= 0;
    #100

    req <= 1;
    wdata <= 32'h0;
    addr <= 0;
    we <= 0;
    #20
    req <= 0;
    wdata <= 0;
    addr <= 0;
    we <= 0;

    #100000
    $finish;
end

always #10 clk = ~clk;



wishbone_master #(
    .DATA_WIDTH(32),
    .ADDR_WIDTH(32)
) master (
    .i_RST(rst),
    .i_CLK(clk),
    .o_ADDR(wishbone_addr),
    .o_DATA(wishbone_m_data),
    .i_DATA(wishbone_s_data),
    .o_WE(wishbone_we),
    .o_SEL(wishbone_sel),
    .o_STB(wishbone_stb),
    .i_ACK(wishbone_ack),
    .o_CYC(wishbone_cyc),
    .o_TAGN(),
    .i_TAGN(),

    .i_req(req),
    .i_addr(addr),
    .i_wdata(wdata),
    .i_we(we),
    .o_rdata(rdata),
    .o_gnt(gnt)
);


wishbone_slave #(
    .DATA_WIDTH(32),
    .ADDR_WIDTH(32)
) slave_0 (
    .i_RST(rst),
    .i_CLK(clk),
    .i_ADDR(wishbone_addr),
    .i_DATA(wishbone_m_data),
    .o_DATA(wishbone_s_data),
    .i_WE(wishbone_we),
    .i_SEL(wishbone_sel),
    .i_STB(wishbone_stb),
    .o_ACK(wishbone_ack),
    .i_CYC(wishbone_cyc),
    .i_TAGN(),
    .o_TAGN()
);

endmodule