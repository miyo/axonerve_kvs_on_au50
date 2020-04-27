/***************************************************************
Generated 2020/03/24 18:44:12 JST, Packetina v0.1.1
 
source code:
----------------------------------------------------------------
module ether_rx(
  input  recv [512]bitstream
  output ether_header [112]bit
  output ether_data [512]bitstream
){

  parameter APP_KEY=16'h6000
   
  local recv_buf [400]bit
  local recv_mty_reg [8]bit
  local ether_data_sop_reg bit
  
  idle(recv.sop == 1 && recv.valid == 1 && recv.data[415:400] == APP_KEY){
    ether_header.data <= recv.data[511:400];
    ether_header.valid <= 1;
    if(recv.eop == 1){
      ether_data.data <= {recv.data[399:0], 112'd0};
      ether_data.eop <= 1;
      ether_data.sop <= 1;
      ether_data.valid <= 1;
      ether_data.mty <= recv.mty + 14; // remove ether header bytes
      idle();
    }else{
      ether_data.valid <= 0;
      ether_data_sop_reg <= 1;
      recv_buf <= recv.data[399:0];
      recv_all();
    }
  }else{
    ether_header.data <= 112'd0;
    ether_header.valid <= 1'b0;
    ether_data.data <= 512'd0;
    ether_data.valid <= 1'b0;
    ether_data.sop <= 1'b0;
    ether_data.eop <= 1'b0;
    ether_data.mty <= 8'd0;
    recv_buf <= 400'd0;
    recv_mty_reg <= 8'd0;
    ether_data_sop_reg <= 1'b0;
  }
 
  recv_all(recv.valid == 1){
    ether_data.data <= {recv_buf, recv.data[511:400]};
    ether_data.valid <= 1;
    ether_data.sop <= ether_data_sop_reg
    ether_data_sop_reg <= 0; // sop is asserted only at once
    recv_buf <= recv.data[399:0];
    if(recv.eop == 1){
      if(recv.mty >= 50){ // all data are output with recv_buf, and no data should be remained
        ether_data.mty <= recv.mty - 50;
        ether_data.eop <= 1;
        idle();
      }else{
        ether_data.eop <= 0;
        recv_mty_reg <= recv.mty + 14;
        last_one();
      }
    } 
  }else{
    ether_data.valid <= 0;
  }
  
  last_one(){
   ether_data.data <= {recv_buf, 112'h0};
   ether_data.valid <= 1;
   ether_data.eop <= 1;
   ether_data.sop <= 0;
   ether_data.mty <= recv_mty_reg;
   idle();
  }
}
----------------------------------------------------------------

*************************************************************/

`default_nettype none

module ether_rx#(parameter APP_KEY=16'h6000)
(
input wire clk,
input wire reset,

// input  recv [512]bitstream
input wire [511:0] recv_data,
input wire recv_valid,
input wire recv_sop,
input wire recv_eop,
input wire [7:0] recv_mty,

// output ether_header [112]bit
output reg [111:0] ether_header_data,
output reg ether_header_valid,

// output ether_data [512]bitstream
output reg [511:0] ether_data_data,
output reg ether_data_valid,
output reg ether_data_sop,
output reg ether_data_eop,
output reg [7:0] ether_data_mty
);

    enum {IDLE, RECV_ALL, LAST_ONE} state;

    // local recv_buf [400]bit
    reg [399:0] recv_buf;
    // local recv_mty_reg [8]bit
    reg [7:0] recv_mty_reg;
    // local ether_data_sop_reg bit
    reg ether_data_sop_reg;

    always @(posedge clk) begin
	case(state)
	    IDLE: begin
		if(recv_sop == 1'b1 && recv_valid == 1'b1 && recv_data[415:400] == APP_KEY) begin
		    ether_header_data <= recv_data[511:400];
		    ether_header_valid <= 1'b1;
		    if(recv_eop == 1'b1) begin
			ether_data_data <= {recv_data[399:0], 112'd0};
			ether_data_eop <= 1'b1;
			ether_data_sop <= 1'b1;
			ether_data_valid <= 1'b1;
			ether_data_mty <= recv_mty - 14;
			state <= IDLE;
		    end else begin
			ether_data_valid <= 1'b0;
			ether_data_sop_reg <= 1'b1;
			recv_buf <= recv_data[399:0];
			state <= RECV_ALL;
		    end
		end else begin
		    ether_header_data <= 112'd0;
		    ether_header_valid <= 1'b0;
		    ether_data_data <= 512'd0;
		    ether_data_valid <= 1'b0;
		    ether_data_sop <= 1'b0;
		    ether_data_eop <= 1'b0;
		    ether_data_mty <= 8'd0;
		    recv_buf <= 400'd0;
		    recv_mty_reg <= 8'd0;
		    ether_data_sop_reg <= 1'b0;
		end
	    end

	    RECV_ALL: begin
		if(recv_valid == 1'b1) begin
		    ether_data_data <= {recv_buf[399:0], recv_data[511:400]};
		    ether_data_valid <= 1'b1;
		    ether_data_sop <= ether_data_sop_reg;
		    ether_data_sop_reg <= 1'b0;
		    recv_buf <= recv_data[399:0];
		    if(recv_eop == 1'b1) begin
			if(recv_mty >= 50) begin
			    ether_data_mty <= recv_mty - 50;
			    ether_data_eop <= 1'b1;
			    state <= IDLE;
			end else begin
			    ether_data_eop <= 1'b0;
			    recv_mty_reg <= recv_mty + 14;
			    state <= LAST_ONE;
			end
		    end
		end else begin
		    ether_data_valid <= 1'b0;
		end
	    end

	    LAST_ONE: begin
		ether_data_data <= {recv_buf, 112'h0};
		ether_data_valid <= 1'b1;
		ether_data_eop <= 1'b1;
		ether_data_sop <= 1'b0;
		ether_data_mty <= recv_mty_reg;
		state <= IDLE;
	    end

	    default: begin
		state <= IDLE;
	    end
	endcase
    end

endmodule // ether_rx

`default_nettype wire
