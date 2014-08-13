module pwmdac(
    input        pwmclk,  /* 110Mhz 44000 x 250 x 10*/
	 input  [7:0] sample,
	 input        enable,
	 
	 output       pwmout
);

reg        pwmout_ff;
reg  [7:0] sample_ff;
reg  [7:0] pwm_dutycyc_ff; /* keeps count of duty cycle (250hz) */
reg  [3:0] pwm_outcnt_ff; /* keeps found of ouputs per sample (10) */

assign pwmout = pwmout_ff;

always @ (posedge pwmclk)
  if (enable) begin
    if (pwm_dutycyc_ff == 8'd249) begin
		pwm_dutycyc_ff <= 8'd0;
		if (pwm_outcnt_ff == 4'd9) begin
		  sample_ff <= sample;
		  pwm_outcnt_ff <= 4'd0;
		end else
		  pwm_outcnt_ff <= pwm_outcnt_ff + 1'b1;
	 end else
      pwm_dutycyc_ff <= pwm_dutycyc_ff + 1'b1;	 
  end
  else begin
    sample_ff <= sample;
    pwm_dutycyc_ff = 8'd0;
	 pwm_outcnt_ff = 4'd0;
  end
  
always @ (*) 
 if (enable)
  pwmout_ff <= sample_ff > pwm_dutycyc_ff;
 else 
  pwmout_ff <= 1'd0;

endmodule