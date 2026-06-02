module apb_slave #(
    parameter ADDR_WIDTH = 8,
    parameter DATA_WIDTH = 8
)(
    input PCLK,
    input PRESETn,

    input PSEL,
    input PENABLE,
    input PWRITE,

    input [DATA_WIDTH-1:0] PWDATA,
    input [ADDR_WIDTH-1:0] PADDR,

    output reg [DATA_WIDTH-1:0] PRDATA,
    output reg PREADY
);

localparam MEM_DEPTH = (1 << ADDR_WIDTH);

reg [DATA_WIDTH-1:0] mem [0:MEM_DEPTH-1];

integer i;

always @(posedge PCLK or negedge PRESETn)
begin
    if(!PRESETn)
    begin
        PREADY <= 1'b0;
        PRDATA <= 0;

        for(i = 0; i < MEM_DEPTH; i = i + 1)
            mem[i] <= {DATA_WIDTH{1'b0}};
    end
    else
    begin
        if(PSEL && PENABLE)
        begin
            PREADY <= 1'b1;

            if(PWRITE)
            begin
                mem[PADDR] <= PWDATA;
            end
            else
            begin
                PRDATA <= mem[PADDR];
            end
        end
        else
        begin
            PREADY <= 1'b0;
        end
    end
end

endmodule
