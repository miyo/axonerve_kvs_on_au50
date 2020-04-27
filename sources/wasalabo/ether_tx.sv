/***************************************************************
Generated 2020/03/24 18:44:15 JST, Packetina v0.1.1
 
source code:
----------------------------------------------------------------
module ether_tx(
  input ether_header [112]bit
  input ether_data [512]bitstream
  output send [512]bitstream
){

  local send_buf [112]bit
  local send_mty_reg [8]bit
  
  idle(ether_header.valid==1 && ether_data.sop==1 && ether_data.valid==1){
    send.data <= {ether_header.data, ether_data.data[511:112]};
    send.valid <= 1;
    send.sop <= 1;
    send_buf <= ether_data.data[111:0];
    if(ether_data.eop == 1){
      if(ether_data.mty >= 14){
         send.mty <= ether_data.mty - 14;
         send.eop <= 1;
         idle();
      }else{
         send_mty_reg <= ether_data.mty + 50; // 64-((64-ether_data.mty+14)-64)
         send.eop <= 0;
         last_one();
      }
    }else{
      send.eop <= 0;
      recv_all();
    }
  }else{
    send.data <= 0;
    send.valid <= 0;
    send.sop <= 0;
    send.eop <= 0;
    send_buf <= 0;
  }
 
  recv_all(ether_data.valid == 1){
    send.data <= {send_buf, ether_data.data[511:112]};
    send.valid <= 1;
    send.sop <= 0;
    send_buf <= ether_data.data[111:0];
    if(ether_data.eop == 1){
      if(ether_data.mty >= 14){
        send.mty <= ether_data.mty - 14;
        send.eop <= 1;
        idle();
      }else{
        send_mty_reg <= ether_data.mty + 50; // 64-((64-ether_data.mty+14)-64)
        send.eop <= 0;
        last_one();
      }
    }
  }else{
    send.valid <= 0;
  }
  
  last_one(){
   send.data <= {send_buf, 400'h0};
   send.valid <= 1;
   send.eop <= 1;
   send.sop <= 0;
   send.mty <= send_mty_reg;
   idle();
  }
}
----------------------------------------------------------------

*************************************************************/

`default_nettype none

module ether_tx
(
input wire clk,
input wire reset,

// input ether_header [112]bit
input wire [111:0] ether_header_data,
input wire ether_header_valid,

// input ether_data [512]bitstream
input wire [511:0] ether_data_data,
input wire ether_data_valid,
input wire ether_data_sop,
input wire ether_data_eop,
input wire [7:0] ether_data_mty,
 
// output send [512]bitstream
output reg [511:0] send_data,
output reg send_valid,
output reg send_sop,
output reg send_eop,
output reg [7:0] send_mty
);

    enum {IDLE, RECV_ALL, LAST_ONE} state;

    // local send_buf [400]bit
    reg [399:0] send_buf;
    // local send_mty_reg [8]bit
    reg [7:0] send_mty_reg;

    always @(posedge clk) begin
	case(state)
	    IDLE: begin
		if(ether_header_valid == 1'b1 && ether_data_sop == 1'b1 && ether_data_valid == 1'b1) begin
		    send_data <= {ether_header_data, ether_data_data[511:112]};
		    send_valid <= 1'b1;
		    send_sop <= 1'b1;
		    send_buf <= ether_data_data[111:0];
		    if(ether_data_eop == 1'b1) begin
			if(ether_data_mty >= 14) begin
			    send_mty <= ether_data_mty - 14;
			    send_eop <= 1'b1;
			    state <= IDLE;
			end else begin
			    send_mty_reg <= ether_data_mty + 50;
			    send_eop <= 1'b0;
			    state <= LAST_ONE;
			end
		    end else begin
			send_eop <= 1'b0;
			state <= RECV_ALL;
		    end
		end else begin
		    send_data <= 512'd0;
		    send_valid <= 1'b0;
		    send_sop <= 1'b0;
		    send_eop <= 1'b0;
		    send_mty <= 8'd0;
		    send_buf <= 112'd0;
		    send_mty_reg <= 8'd0;
		end
	    end

	    RECV_ALL: begin
		if(ether_data_valid == 1'b1) begin
		    send_data <= {send_buf, ether_data_data[511:112]};
		    send_valid <= 1'b1;
		    send_sop <= 1'b0;
		    send_buf <= ether_data_data[111:0];
		    if(ether_data_eop == 1'b1) begin
			if(ether_data_mty >= 14) begin
			    send_mty <= ether_data_mty - 14;
			    send_eop <= 1'b1;
			    state <= IDLE;
			end else begin
			    send_mty_reg <= ether_data_mty + 50;
			    send_eop <= 1'b0;
			    state <= LAST_ONE;
			end
		    end
		end else begin
		    send_valid <= 1'b0;
		end
	    end

	    LAST_ONE: begin
		send_data <= {send_buf, 400'd0};
		send_valid <= 1'b1;
		send_eop <= 1'b1;
		send_sop <= 1'b0;
		send_mty <= send_mty_reg;
		state <= IDLE;
	    end

	    default: begin
		state <= IDLE;
	    end
	endcase
    end

endmodule // ether_tx

`default_nettype wire
