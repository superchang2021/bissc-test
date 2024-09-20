` timescale 1ns/1ps

/*******************************************************************************************
// Company: DMT
// Engineer: 常仁威
// Create Date: 2024/08/21 10:31:40
// Design Name: biss_test
// Module Name: biss_test
// Project Name: biss_test
// Target Devices: FA303
// Tool Versions: 5.6.2
// Description: 测试BiSS-C通讯
// Dependencies: BiSS-C 主机需要给从机时钟信号，从机需要
// Revision:1.0
// Revision 0.01 - File Created
// Additional Comments:使用编码器为SEF128A1-6-02600-03000-BIS-PR15C6,26位编码器、单圈模式
// 帧格式： 1上升沿的LAT、1上升沿的ACK（新周期的开始）、
// 1上升沿的起始位、1上升沿的CDS（帧头）、N个上升沿的N位数据（N自定义）、M个上升沿的M位校验位
*******************************************************************************************/

module biss_test(
// sys signals
  input    sys_clk,      //系统clk
  input    sys_rst_n,    //系统rst_n
  input    key,          //按键
//BiSS-C signals
  input    sl,       //从机给主机输出的数据 使用J3的7号脚 对应M15
    output [3:0] led, // p4 n5 p5 m6
    output re,       // M422-E模块的控制信号，控制接收使能，先设定为低 使用J3的11号脚 对应R15
    output de,       // M422-E模块的控制信号，控制发送使能，先设定为高 使用J3的15号脚 对应T14
    output ma        //主机给从机的时钟信号 使用J3的3号脚 对应K16
);

// parameter define
parameter  CRC_W  = 8'd8;              //CRC 校验位宽
parameter  DATA_W = 8'd26;             //数据位宽

// wire define
wire locked;
wire clk_200M;    //200MHz clk
wire clk_5M;     //5MHz clk(这里变量名称记得更改)

wire [25:0] data;       //编码器角度数据
wire [7:0] crc_data;    //对应的校验位
wire [5:0] crc_c;       // 计算得到的CRC校验位
wire [1:0] err_data;
wire crc_en;

// assign define
assign re = 1'b0;
assign de = 1'b1;

/************************
           PLL
************************/
mypll U1_pll(
  .refclk      (sys_clk),
  .reset       (1'b0),
  .clk0_out    (clk_200M),
  .clk1_out    (clk_5M),
  .extlock     (locked)
);

/************************
      biss_control
************************/
biss_control U2_control(
// sys input
.clk         (clk_200M),     //模块主时钟
.clk_5M      (clk_5M),      //10MHz基准时钟
.rst_n       (sys_rst_n),    //复位信号
// input
.key         (key),          //按键信号
.data_in     (sl),           //编码器输出信号
.clk_out     (ma),           //输出时钟信号
//output
.crc_en_o    (crc_en),
.crc_data    (crc_data),     //校验位
.err_data    (err_data),
.data_out    (data)          //获取的编码器数据
);

/************************
      biss_CRC
************************/
biss_crc6 U3_CRC(
.clk(clk_200M),
.rst_n(sys_rst_n),

.crc_en(crc_en),
.data_in({4'b0000,data,err_data}),
.crc_outt(crc_c)

);



// led 
led U4_led(
.clk(sys_clk),
.rst_n(sys_rst_n),
.led(led)  
);



endmodule
