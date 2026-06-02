module apb_master#(parameter ADDR_WIDTH = 9,DATA_WIDTH = 8)(
input PCLK,PRESETn,transfer,READ_WRITE, //done
input [ADDR_WIDTH -1:0] apb_write_paddr,apb_read_paddr, //done
input [DATA_WIDTH -1:0] apb_write_data, //done
input PREADY, //done
input [DATA_WIDTH -1:0] PRDATA, // done
output reg PWRITE,PSEL,PENABLE, //done
output reg [ADDR_WIDTH -2:0] paddr,
output reg [DATA_WIDTH -1:0] pwdata,apb_read_data_out, // done
output reg mux_sel // done but might have to change
);

localparam [1:0] idle =2'b00,setup=2'b01,access =2'b10;
reg [1:0] ps,ns;

reg next_sel,next_en,next_pwrite;
reg [ADDR_WIDTH -2:0]next_paddr_R,next_paddr_W;
reg next_mux_sel;
reg [DATA_WIDTH -1:0] next_write_data;


always@(posedge PCLK or negedge PRESETn)
begin
	if(!PRESETn)
	begin
		PSEL <= 0;
		PENABLE <= 0;
		PWRITE <= 1;
		ps <= idle;
		mux_sel <= 0;
		paddr <= 0;
		pwdata <= 0;
		apb_read_data_out <= 0;
	end	
	else
	begin
		ps <= ns;
		PWRITE <= next_pwrite;
		mux_sel <= next_mux_sel;
		PSEL <= next_sel;
		PENABLE <= next_en;	
		pwdata <= next_write_data;

		if( (ps == idle))
		begin
			if(READ_WRITE)
				paddr <= next_paddr_R;
			else
				paddr <= next_paddr_W;
		end
		if( (ps==access) && PREADY)
		begin
			if(!PWRITE)
				apb_read_data_out <= PRDATA;

			if(transfer)
			begin	
				if(READ_WRITE)
					paddr <= next_paddr_R;
				else
					paddr <= next_paddr_W;
			end
		end

	end
end


always@(*)
begin

	ns = ps;

	next_sel = PSEL;
	next_en = PENABLE;
	next_pwrite = PWRITE;
	next_mux_sel = mux_sel;

	next_paddr_W = paddr;
	next_paddr_R = paddr;
	next_write_data = pwdata;

	case(ps)
	idle:
	begin
		next_pwrite = ~(READ_WRITE);
		next_mux_sel = (READ_WRITE) ? apb_read_paddr[ADDR_WIDTH -1]:apb_write_paddr[ADDR_WIDTH -1];
		next_paddr_W = apb_write_paddr[ADDR_WIDTH-2:0];
		next_paddr_R = apb_read_paddr[ADDR_WIDTH-2:0];
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
		next_sel = 1;
		next_en = 1;
		if(PREADY)
		begin
			if(transfer)
			begin
				ns = setup;
				next_pwrite = ~(READ_WRITE);
				next_mux_sel = (READ_WRITE) ? apb_read_paddr[ADDR_WIDTH -1]:apb_write_paddr[ADDR_WIDTH -1];
				next_paddr_W = apb_write_paddr[ADDR_WIDTH-2:0];
				next_paddr_R = apb_read_paddr[ADDR_WIDTH-2:0];
				next_write_data = apb_write_data;
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
