module apb_mux#(parameter DATA_WIDTH = 8, ADDR_WIDTH = 8)(
input mux_sel,
input mst_psel,
input [ADDR_WIDTH -1:0] addr,
input slv_PREADY1,slv_PREADY2,
input [DATA_WIDTH - 1:0] slv_PRDATA1,slv_PRDATA2,
output reg mst_PREADY,
output reg [DATA_WIDTH -1:0] mst_PRDATA,
output reg slv_psel1,slv_psel2
);

always@(*)
begin
	if(mux_sel)
	begin
		slv_psel1 = mst_psel;
	 	mst_PREADY = slv_PREADY1;
		mst_PRDATA = slv_PRDATA1;
	end
	else
	begin
		slv_psel2 = mst_psel;
	 	mst_PREADY = slv_PREADY2;
		mst_PRDATA = slv_PRDATA2;
	end
end
endmodule
