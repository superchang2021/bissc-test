create_clock -name clk_50MHz -period 20 -waveform {10 20} [get_ports {sys_clk}]
derive_pll_clocks