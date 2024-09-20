` timescale 1ns/100ps

module biss_test_tb;

reg sys_clk;
reg sys_rst_n;
reg key;
reg sl;
reg [31:0] cnt_ma;
reg reg_ma0;
reg reg_ma1;
reg [31:0] cnt_STP;

biss_test u_test(
.sys_clk(sys_clk),
.sys_rst_n(sys_rst_n),
.key(key),
.sl(sl),
.ma(ma)
);

initial begin
 sys_clk = 1'b0;
 sys_rst_n = 1'b0;
 key = 1'b1;
 sl = 1'b1;
 cnt_ma = 32'd0;
 cnt_STP = 32'd0;
 reg_ma0 = 1'b1;
 reg_ma1 = 1'b1;
 # 1000 sys_rst_n = 1'b1;
 # 20000 key = 1'b0;
end

always @(posedge ma) begin
  cnt_ma <= cnt_ma + 1'b1;
end

always @(posedge sys_clk) begin
  reg_ma0 <= ma;
  reg_ma1 <= reg_ma0;
end

always @(posedge sys_clk or negedge sys_rst_n) begin
  if(~sys_rst_n) begin
    sl <= 1'b1;
  end
  else if({reg_ma0,reg_ma1} == 2'b10 && cnt_ma == 8'd3) begin
    sl <= ~sl;
  end 
  else if({reg_ma0,reg_ma1} == 2'b10 && cnt_ma == 8'd4) begin
    sl <= ~sl;
  end
  else if({reg_ma0,reg_ma1} == 2'b10 && cnt_ma == 8'd5) begin
    sl <= ~sl;
  end
  else if({reg_ma0,reg_ma1} == 2'b10 && cnt_ma >= 8'd6 && cnt_ma <= 8'd39) begin
    sl <= ~sl;
  end
  else if(cnt_STP == 32'd200) begin
    sl <= 1'b1;
  end
  else begin
    sl <= sl;
  end
end


always @(posedge sys_clk or negedge sys_rst_n) begin
  if(~sys_rst_n) begin
    cnt_STP <= 32'd0;
  end
  else if(cnt_ma == 8'd40) begin
    cnt_STP <= cnt_STP + 1'b1;
  end
  else begin
    cnt_STP <= cnt_STP;
  end
end

always #10 sys_clk = ~sys_clk;

endmodule
