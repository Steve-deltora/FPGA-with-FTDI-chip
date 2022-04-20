module usb(
	input   wire         clk   , // Parallel FIFO bus clock generate by UMFT601 chip
	input   wire         reset , // Chip Reset input, Active low.

	input   wire         rxf   , // Receive FIFO Full output signal, 0 means RX(receive) fifo has at least one byte of space to recieve data from PC.
	input   wire         txe   , // Transmit FIFO Empty output signal, 0 means TX(transmit) fifo has at least one byte data to transmit to PC.

	output  reg          oe    , // Data Output(to FPGA) Enable input(respect to UMFT601) signal. Active low.
	output  reg          rd    , // Read Enable input(respect to UMFT601) signal. Active low to get RX fifo data out to FPGA.

	output  reg          wr    , // Write Enable input(respect to UMFT601) signal. Active low to write data in FPGA to TX fifo.
	
	inout   wire [31:0]  data  , // I/O  , Parallel FIFO bus data.
	
	output  reg  [3:0]   be    , // Parallel FIFO bus byte enable
	inout   wire [1:0]   gpio    // Configurable GPIO.
);

	reg [31:0] data_p; // to save data to process.

	wire to_rd; // ftdi read signal
	assign to_rd = ~rxf & ~oe & ~rd;

	// read data
	always @ (negedge clk or negedge reset)begin
		if(~reset) begin
			oe     <= 1'h1;
			rd     <= 1'h1;
			be     <= 4'h0;
			data_p <=  'h0;
		end
		else begin
			oe     <= rxf    ? 1'h1 : 1'h0;
			rd     <= rxf    ? 1'h1 : (oe ? 1'h1 : 1'h0);
			be     <= rxf    ? 4'hf : 4'h0;
			data_p <= to_rd  ? data : data_p; // to save 'data' from PC 
		end
	end

	// write data
	always @ (negedge clk or negedge reset)begin
		if(~reset) begin
			wr <= 1'h1;
		end
		else begin
			wr <= txe ? 1'b1 : 1'h0;
		end
	end

	assign data = wr ? 32'hz : data_p + {8'h1, 8'h1, 8'h1, 8'h1}; // do some process then write back to PC

endmodule
