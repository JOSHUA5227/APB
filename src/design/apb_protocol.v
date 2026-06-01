module apb_protocol #(parameter DATA_WIDTH=8, ADDR_WIDTH=8)
(
	input PCLK,
	input PRESETn,
	input transfer,
	input READ_WRITE,
	input [ADDR_WIDTH:0] apb_read_paddr,
	input [ADDR_WIDTH:0] apb_write_paddr,
	input [DATA_WIDTH-1:0] apb_write_data,
	input slv_PREADY1,
	input slv_PREADY2,
	input [DATA_WIDTH-1:0] slv_PRDATA1,
	input [DATA_WIDTH-1:0] slv_PRDATA2,
	output PWRITE,
	output PENABLE,
	output PSEL1,
	output slv_psel1,
	output slv_psel2,
	output [ADDR_WIDTH-1:0] paddr,
	output [DATA_WIDTH-1:0] pwdata,
	output [DATA_WIDTH-1:0] apb_read_data_out
);

wire mux_sel;
wire mst_PREADY;
wire [DATA_WIDTH-1:0] mst_PRDATA;

apb_master #(
	.ADDR_WIDTH(ADDR_WIDTH),
	.DATA_WIDTH(DATA_WIDTH)
) u_master (
	.PCLK(PCLK),
	.PRESETn(PRESETn),

	.transfer(transfer),
	.READ_WRITE(READ_WRITE),

	.apb_write_paddr(apb_write_paddr),
	.apb_read_paddr(apb_read_paddr),

	.apb_write_data(apb_write_data),

	.PREADY(mst_PREADY),
	.PRDATA(mst_PRDATA),

	.PWRITE(PWRITE),
	.PSEL1(PSEL1),
	.PENABLE(PENABLE),

	.paddr(paddr),
	.pwdata(pwdata),
	.apb_read_data_out(apb_read_data_out),

	.mux_sel(mux_sel)
);

apb_mux u_mux(
	.mux_sel(mux_sel),

	.mst_psel(PSEL1),

	.slv_PREADY1(slv_PREADY1),
	.slv_PREADY2(slv_PREADY2),

	.slv_PRDATA1(slv_PRDATA1),
	.slv_PRDATA2(slv_PRDATA2),

	.mst_PREADY(mst_PREADY),
	.mst_PRDATA(mst_PRDATA),

	.slv_psel1(slv_psel1),
	.slv_psel2(slv_psel2)
);


endmodule
