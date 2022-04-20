module usb(
	input   wire         clk   , // I    , Parallel FIFO bus clock
	input   wire         reset , // I    , Chip Reset input, Active low.

	input   wire         rxf   , // I    , Receive FIFO Full output signal.
	input   wire         txe   , // I    , Transmit FIFO Empty output signal.

	output  reg          oe    , // I    , Data Output Enable input signal.
	output  reg          rd    , // I    , Read Enable input signal.

	output  reg          wr    , // O    , Write Enable input signal.

	inout   wire [31:0]  data  , // I/O  , Parallel FIFO bus data.

	output  reg  [3:0]   be    , // I/O  , Parallel FIFO bus byte enable.
	inout   wire [1:0]   gpio    // I/O  , Configurable GPIO.
);

reg [31:0] data_p;

wire to_rd;
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
		oe     <= rxf    ? 1'h1   : 1'h0;
		rd     <= rxf    ? 1'h1   : (oe ? 1'h1 : 1'h0);
		be     <= rxf    ? 4'hf   : 4'h0;
		data_p <= to_rd  ? data : data_p;
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

assign data = wr ? 32'hz : data_p + {8'h1, 8'h1, 8'h1, 8'h1};

endmodule
