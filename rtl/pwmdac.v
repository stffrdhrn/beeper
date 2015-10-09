module pwmdac(
  input  [7:0] sample,
  output       pwmout,
  
  input        clk,  /* 110Mhz 44000 x 250 x 10*/
  input        rst_n
);

parameter CLK_FREQ       = 32;
parameter PWM_PER_CYLCLE = 4;  /*(3=41K, 4=31K, 8=15K, 16=7800)*/

reg  [7:0] sample_ff;
reg  [7:0] pwm_dutycyc_ff; /* keeps count of duty cycle (250hz) */
reg  [3:0] pwm_outcnt_ff; /* keeps count of ouputs per sample (10) */

assign pwmout = (sample_ff > pwm_dutycyc_ff);

always @ (posedge clk)
  if (~rst_n) 
    begin
    sample_ff <= 8'd0;
    pwm_dutycyc_ff = 8'd0;
    pwm_outcnt_ff = 4'd0;
    end
  else
    begin
    pwm_dutycyc_ff <= pwm_dutycyc_ff + 1'b1;  
  
    if (!pwm_dutycyc_ff) 
      if (pwm_outcnt_ff == 4'd3) 
        begin
        sample_ff <= sample;
        pwm_outcnt_ff <= 4'd0;
        end 
      else
        pwm_outcnt_ff <= pwm_outcnt_ff + 1'b1;

    end
    
endmodule