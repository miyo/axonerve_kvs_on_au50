`default_nettype none

module cmac_usplus_emitter
  (
   input wire clk,
   input wire reset,

   input wire [511:0] din_data,
   input wire din_valid,
   input wire din_sop,
   input wire din_eop,
   input wire [7:0] din_mty,

   output reg [511:0] dout_data,
   output reg dout_valid,
   output wire dout_kick,
   output wire [13:0] dout_bytes,
   input wire cmac_busy,
   input wire cmac_done,
   input wire cmac_tx_rdy
   );

    reg[7:0] data_ready_state = 8'd0;
    reg dout_ready = 1'b0;
    reg [15:0] dout_count = 16'd0;

    always @(posedge clk) begin
	if(reset == 1'b1) begin
	    dout_valid <= 1'b0;
	    dout_ready <= 1'b0;
	    dout_count <= 16'd0;
	end else begin
	    dout_data <= din_data;
	    dout_valid <= din_valid;
	    if(data_ready_state == 0) begin
		if(din_valid == 1 && din_sop == 1) begin
		    if(din_eop == 1) begin
			dout_ready <= 1;
			dout_count <= 64 - din_mty;
		    end else begin
			dout_ready <= 0;
			dout_count <= 64;
			data_ready_state <= data_ready_state + 1;
		    end
		end else begin
		    dout_ready <= 0;
		end
	    end else if(data_ready_state == 1) begin
		if(din_valid == 1) begin
		    if(din_eop == 1) begin
			dout_ready <= 1;
			dout_count <= dout_count + (64 - din_mty);
			data_ready_state <= 0;
		    end else begin
			dout_ready <= 0;
			dout_count <= dout_count + 64;
		    end
		end else begin
		    dout_ready <= 0;
		end
	    end else begin
		dout_ready <= 0;
	    end
	end
    end

    reg fifo_rd = 1'b0;
    wire [15:0] fifo_q;
    wire fifo_full, fifo_empty;
    wire fifo_valid;
    wire fifo_overflow, fifo_underflow;
    wire fifo_wr_rst_busy, fifo_rd_rst_busy;

    fifo_16_1024_ft fifo_i(.clk(clk),
			   .srst(reset),
			   .din(dout_count),
			   .wr_en(dout_ready),
			   .rd_en(fifo_rd),
			   .dout(fifo_q),
			   .full(fifo_full),
			   .overflow(fifo_overflow),
			   .empty(fifo_empty),
			   .valid(fifo_valid),
			   .underflow(fifo_underflow),
			   .wr_rst_busy(fifo_wr_rst_busy),
			   .rd_rst_busy(fifo_rd_rst_busy));

    reg [7:0] kick_state = 8'd0;
    reg kick_reg = 1'b0;
    reg [13:0] bytes_reg = 14'd0;
    assign dout_kick = kick_reg;
    assign dout_bytes = bytes_reg;

    always @(posedge clk) begin
	if(reset == 1'b1) begin
	    kick_reg <= 1'b0;
	    bytes_reg <= 14'd0;
	    kick_state <= 8'd0;
	    fifo_rd <= 1'b0;
	end else begin
	    case(kick_state)
		0 : begin
		    if(fifo_valid && cmac_tx_rdy) begin
			kick_reg <= 1'b1;
			kick_state <= kick_state + 1;
			bytes_reg <= fifo_q[13:0];
			fifo_rd <= 1'b1;
		    end else begin
			kick_reg <= 1'b0;
			fifo_rd <= 1'b0;
		    end
		end
		1 : begin
		    fifo_rd <= 1'b0;
		    if(cmac_busy == 1'b1) begin // TX begin
			kick_reg <= 1'b0;
			kick_state <= kick_state + 1;
		    end
		end
		2 : begin
		    if(cmac_done == 1'b1) begin // TX done
			kick_state <= 0;
		    end
		end
		default: begin
		    kick_state <= 0;
		    kick_reg <= 1'b0;
		    fifo_rd <= 1'b0;
		end
	    endcase // case (kick_state)
	end
    end

endmodule // cmac_usplus_emitter

`default_nettype wire

