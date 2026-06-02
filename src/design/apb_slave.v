module apb_slave#(parameter ADDR_WIDTH = 8,DATA_WIDTH = 8)(
input PCLK,PRESETn,
input PSEL,
input PENABLE,
input PWRITE,
input [DATA_WIDTH -1:0] PWDATA,
input [ADDR_WIDTH -1:0] PADDR,
output reg [DATA_WIDTH -1:0] PRDATA,
output reg PREADY
);

reg [DATA_WIDTH -1:0] mem [0:(2**ADDR_WIDTH) -1];

always@(posedge PCLK or negedge PRESETn)
begin
	if(!PRESETn)
	begin
		PREADY <=0;
		PRDATA <=0;
	end
	else
	begin
		if(PSEL && PENABLE)
		begin
			if(PWRITE)
			begin
				mem[PADDR] <= PWDATA;
				PREADY <= 1;
			end
			else
			begin
				PRDATA <= mem[PADDR];
				PREADY <= 1;
			end
		end
		else
		begin
			PREADY <= 0;
		end
	end
end
endmodule
