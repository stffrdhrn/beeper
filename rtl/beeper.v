module beeper(
    input        clk,
	 input  [3:0] duty_cycle,
	 input        enable,
	 
	 output       beep
);

reg         beep_ff;
reg   [8:0] count_ff; // counts to 284 (1Mhz / 440 / 2 / 4)
reg   [2:0] duty_cycle_count_ff;

assign beep = beep_ff;

always @ (posedge clk)
  if (enable) begin
    if (count_ff == 9'd284) begin
	   duty_cycle_count_ff <= duty_cycle_count_ff + 1'b1;
		count_ff <= 9'd0;
	 end else
      count_ff <= count_ff + 1'b1;	 
  end
  else begin
    count_ff = 9'd0;
    duty_cycle_count_ff = 3'd0;
  end
  
always @ (*) 
case (duty_cycle_count_ff)
  3'd0:
    beep_ff <= (duty_cycle & 4'b1000) != 0; 
  3'd1: 
    beep_ff <= (duty_cycle & 4'b0100) != 0;
  3'd2:
    beep_ff <= (duty_cycle & 4'b0010) != 0;
  3'd3:
    beep_ff <= (duty_cycle & 4'b0001) != 0;
  default: 
    beep_ff <= 1'b0;
endcase

endmodule