`default_nettype none

module resetgen#(parameter RESET_COUNT=100)
    (
     input wire clk,
     input wire reset_in,
     output wire reset_out
     );

    reg [15:0] reset_counter = 16'd0;
    reg reset_reg = 1'b1;

    assign reset_out = reset_reg;

    always @(posedge clk) begin
	if(reset_in == 1'b1) begin
	    reset_reg <= 1'b1;
	    reset_counter <= 0;
	end else begin
	    if(reset_counter < RESET_COUNT) begin
		reset_counter <= reset_counter + 1;
		reset_reg <= 1'b1;
	    end else begin
		reset_reg <= 1'b0;
	    end
      end
   end
endmodule // resetgen

`default_nettype wire
