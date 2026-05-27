module apb_master(
input PCLK,PRESETn,transfer,READ_WRITE,
input apb_write_paddr,apb_read_paddr,
input apb_write_data,
input PREADY,
input PRDATA,
output PWRITE,PSEL1,PENABLE,
output paddr,pwdata,apb_read_data_out
);

localparam [1:0] idle =2'b00,setup=2'b01,access =2'b10;
reg [1:0] ps,ns;

reg next_sel,next_en;

always@(posedge PCLK or PRESETn)
begin
	if(PRESETn)
	begin
		PSEL1 <= 0;
		PENABLE <= 0;
		PWRITE <= 1;
		ps <= idle;
	end	
	else
	begin
		ps <= ns;
		PWRITE <= READ_WRITE
	end
end


always@(*)
begin
	next_sel = 0;
	next_en = 0;
	case(ps)
	idle:
	begin
		next_sel = 0;
		next_en = 0;
		if(transfer)
		begin
			ns =  setup;
		end
		else
		begin
			ns = idle;
		end
	end

	setup:
	begin
		next_sel = 1;
		next_en =0;
		ns = access;
	end

	access:
	begin
		if(PREADY)
		begin
			if(transfer)
			begin
				ns = setup;
			end
			else
			begin
				ns = idle;
			end
		end
		else
		begin
			ns = access;
		end
	end	
	default:
	begin
		ns = idle;
	end
	endcase
end	

endmodule
