module pwmdac_tb();

reg enable, pwmclk;
reg [7:0] sample;
wire pwmout;

initial 
begin
  enable = 0;
  pwmclk = 0;
  sample = 8'd100;
end

always 
  #1  pwmclk <= ~pwmclk;

initial
begin
  #15 enable = 1;

  #1000 sample <= 8'd012;

  #7000 enable = 0;
  
end
  
pwmdac pwmdaci (
    .pwmclk(pwmclk),
	 .sample(sample),
	 .enable(enable),
	 
	 .pwmout(pwmout)
);
  
endmodule