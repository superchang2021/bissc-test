module CW_TOP_WRAPPER(jtdi, jtck, jrstn, jscan, jshift, jupdate, jtdo, trig_clk, bus_din, wt_ce, wt_en, wt_addr);
	localparam STAT_REG_LEN = 18;
	localparam BUS_NUM = 13;
	localparam BUS_DIN_NUM = 109;
	localparam BUS_CTRL_NUM = 270;
	localparam integer BUS_WIDTH[0:12] = {1,1,28,1,8,8,8,8,8,8,8,6,16};
	localparam integer BUS_DIN_POS[0:12] = {0,1,2,30,31,39,47,55,63,71,79,87,93};
	localparam integer BUS_CTRL_POS[0:12] = {0,6,12,72,78,98,118,138,158,178,198,218,234};

	input jtdi;
	input jtck;
	input jrstn;
	input [1:0] jscan;
	input jshift;
	input jupdate;
	output [1:0] jtdo;
	input trig_clk;
	input [BUS_DIN_NUM-1:0] bus_din;
	output wt_ce;
	output wt_en;
	output [15:0] wt_addr;

	cwc_top #(
		.STAT_REG_LEN(STAT_REG_LEN),
		.BUS_NUM(BUS_NUM),
		.BUS_DIN_NUM(BUS_DIN_NUM),
		.BUS_CTRL_NUM(BUS_CTRL_NUM),
		.BUS_WIDTH(BUS_WIDTH),
		.BUS_DIN_POS(BUS_DIN_POS),
		.BUS_CTRL_POS(BUS_CTRL_POS)
	)
	 wrapper_cwc_top(
		.jtdi(jtdi),
		.jtck(jtck),
		.jrstn(jrstn),
		.jscan(jscan),
		.jshift(jshift),
		.jupdate(jupdate),
		.jtdo(jtdo),
		.bus_din(bus_din),
		.trig_clk(trig_clk),
		.wt_ce(wt_ce),
		.wt_en(wt_en),
		.wt_addr(wt_addr)
	);
endmodule


