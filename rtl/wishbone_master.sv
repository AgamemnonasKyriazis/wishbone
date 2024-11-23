module wishbone_master #(
    parameter DATA_WIDTH = 32,
    parameter ADDR_WIDTH = 32
) (
    input  i_RST,
    input  i_CLK,
    output logic [ADDR_WIDTH-1:0] o_ADDR,
    output logic [DATA_WIDTH-1:0] o_DATA,
    input  [DATA_WIDTH-1:0] i_DATA,
    output logic o_WE,
    output logic [3:0] o_SEL,
    output logic o_STB,
    input  i_ACK,
    output logic o_CYC,
    output o_TAGN,
    input  i_TAGN,

    input  i_req,
    input  [ADDR_WIDTH-1:0] i_addr,
    input  [DATA_WIDTH-1:0] i_wdata,
    input  i_we,
    output [DATA_WIDTH-1:0] o_rdata,
    output logic o_gnt
);

typedef enum {
    IDLE,
    TRANS,
    WAIT_ACK
} state_t;

state_t state;
state_t next_state;


always_ff @(posedge i_CLK) begin
    if (i_RST)
        state <= IDLE;
    else
        state <= next_state;
end

reg [ADDR_WIDTH-1:0] addr;
reg [DATA_WIDTH-1:0] data;
reg we;
always_ff @(posedge i_CLK) begin
    if (i_req) begin
        addr <= i_addr;
        data <= i_wdata;
        we   <= i_we;
    end
end

always_comb begin    
    case (state)
    IDLE : begin
        o_CYC = 1'b0;
        o_STB = 1'b0;
        o_SEL = 4'b0000;
        o_WE  = 1'b0;
        o_ADDR = 0;
        o_DATA = 0;
    end
    TRANS, WAIT_ACK : begin
        o_CYC = 1'b1;
        o_STB = 1'b1;
        o_SEL = 4'b1111;
        o_WE  = we;
        o_ADDR = addr;
        o_DATA = data;
    end
    endcase
end

always_comb begin
    case (state)
    IDLE : begin
        if (i_req)
            next_state = TRANS;
    end
    TRANS, WAIT_ACK : begin
        next_state = WAIT_ACK;
        if (i_ACK)
            next_state = IDLE;
    end
    default : begin
        next_state = IDLE;
    end
    endcase
end

assign o_gnt = i_ACK;
assign o_rdata = i_DATA;

endmodule