module led(
  input clk,
  input rst_n,
    output [3:0] led
);

reg [31:0] timer;
reg [3:0] led_in;

assign led = led_in;

always @(posedge clk or negedge rst_n) begin
  if(~rst_n) begin
    timer <= 32'd0;
  end
  else if(timer == 32'd199_999_999) begin
    timer <= 32'd0;
  end
  else begin
    timer <= timer + 1'b1;
  end
end

always @(posedge clk or negedge rst_n )begin
  if(~rst_n) begin
    led_in <= 4'b0000;
  end
  else if(timer == 32'd49_999_999) begin
    led_in <= 4'b0001;
  end
  else if(timer == 32'd99_999_999) begin
    led_in <= 4'b0010;
  end
  else if(timer == 32'd149_999_999) begin
    led_in <= 4'b0100;
  end
  else if(timer == 32'd199_999_999) begin
    led_in <= 4'b1000;
  end
end

endmodule
