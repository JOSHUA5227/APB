module apb_master(
input PCLK,PRESETn,transfer,READ_WRITE, //done
input apb_write_paddr,apb_read_paddr, //done
input apb_write_data, //done
input PREADY, //done
input PRDATA, // todo
output PWRITE,PSEL1,PENABLE, //done
output paddr,pwdata,apb_read_data_out, // todo
output mux_sel // done but might have to change
);

localparam [1:0] idle =2'b00,setup=2'b01,access =2'b10;
reg [1:0] ps,ns;

reg next_sel,next_en,next_pwrite;
reg next_paddr_R,next_padd_W;
reg next_mux_sel;
reg next_write_data;


always@(posedge PCLK or PRESETn)
begin
	if(PRESETn)
	begin
		PSEL1 <= 0;
		PENABLE <= 0;
		PWRITE <= 1;
		ps <= idle;
		mux_sel <= 0;
	end	
	else
	begin
		ps <= ns;
		PWRITE <= next_pwrite;
		mux_sel <= next_mux_sel;
	end
end


always@(*)
begin
	next_sel = 0;
	next_en = 0;
	next_pwrite = 0;
	next_mux_sel = 0;
	next_write_data = 0;


	case(ps)
	idle:
	begin
		next_pwrite = (READ_WRITE);
		next_mux_sel = (READ_WRITE) ? apb_read_paddr[8]:apb_write_paddr[8];
		next_paddr_R = apb_write_paddr;
		next_paddr_W = apb_read_paddr;
		next_write_data = apb_write_data;
		next_sel = 0;
		next_en = 0;

		if(transfer)
		begin
			ns = setup;
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
