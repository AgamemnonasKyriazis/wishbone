test:
	iverilog -g2012 top_tb.v rtl/*.sv
	./a.out
	GDK_BACKEND=x11 gtkwave top_tb.vcd

clean:
	rm -f a.out