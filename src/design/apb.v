module apb #(
	parameter ADDR_WIDTH = 9,
	parameter DATA_WIDTH = 8
)
(
	input PCLK,
	input PRESETn,

	input transfer,
	input READ_WRITE,

	input [ADDR_WIDTH-1:0] apb_write_paddr,
	input [ADDR_WIDTH-1:0] apb_read_paddr,

	input [DATA_WIDTH-1:0] apb_write_data,

	output [DATA_WIDTH-1:0] apb_read_data_out
);
wire PWRITE;
wire PSEL;
wire PENABLE;

wire slv_psel1;
wire slv_psel2;

wire [ADDR_WIDTH-2:0] paddr;
wire [DATA_WIDTH-1:0] pwdata;

wire slv_PREADY1;
wire slv_PREADY2;

wire [DATA_WIDTH-1:0] slv_PRDATA1;
wire [DATA_WIDTH-1:0] slv_PRDATA2;

apb_protocol #(
	.ADDR_WIDTH(ADDR_WIDTH),
	.DATA_WIDTH(DATA_WIDTH)
) u_protocol (
	.PCLK(PCLK),
	.PRESETn(PRESETn),

	.transfer(transfer),
	.READ_WRITE(READ_WRITE),

	.apb_write_paddr(apb_write_paddr),
	.apb_read_paddr(apb_read_paddr),

	.apb_write_data(apb_write_data),

	.slv_PREADY1(slv_PREADY1),
	.slv_PREADY2(slv_PREADY2),

	.slv_PRDATA1(slv_PRDATA1),
	.slv_PRDATA2(slv_PRDATA2),

	.PWRITE(PWRITE),
	.PSEL(PSEL),
	.PENABLE(PENABLE),

	.slv_psel1(slv_psel1),
	.slv_psel2(slv_psel2),

	.paddr(paddr),
	.pwdata(pwdata),

	.apb_read_data_out(apb_read_data_out)
);

apb_slave #(
	.ADDR_WIDTH(ADDR_WIDTH-1),
	.DATA_WIDTH(DATA_WIDTH)
) u_slave1 (
	.PCLK(PCLK),
	.PRESETn(PRESETn),

	.PSEL(slv_psel1),
	.PENABLE(PENABLE),
	.PWRITE(PWRITE),

	.PWDATA(pwdata),
	.PADDR(paddr),

	.PRDATA(slv_PRDATA1),
	.PREADY(slv_PREADY1)
);

apb_slave #(
	.ADDR_WIDTH(ADDR_WIDTH-1),
	.DATA_WIDTH(DATA_WIDTH)
) u_slave2 (
	.PCLK(PCLK),
	.PRESETn(PRESETn),

	.PSEL(slv_psel2),
	.PENABLE(PENABLE),
	.PWRITE(PWRITE),

	.PWDATA(pwdata),
	.PADDR(paddr),

	.PRDATA(slv_PRDATA2),
	.PREADY(slv_PREADY2)
);

endmodule
