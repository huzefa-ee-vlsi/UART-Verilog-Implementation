`timescale 1ns / 1ps



module uart_loopback_tb(

    );
    


reg clk;
reg rst;
reg [7:0] data_in;
reg start;

wire [7:0] data_out;
wire busy;
wire rx_valid;
wire tx;

wire tx_busy;
wire tx_done;

uart_tx uut (
.clk(clk),
.rst(rst),
.data_in(data_in),
.start(start),
.tx(tx),
.busy(tx_busy),
.done(tx_done)
);


uart_rx dut (
.clk(clk),
.rst(rst),
.data_out(data_out),
.rx(tx),//this is where loopback happens 
.busy(busy),
.rx_valid(rx_valid)
);


initial 
clk=0;

always #5 clk=~clk;

initial begin 

rst=1;
start=0;
data_in= 8'h00;


#20 ;
rst=0;


#20;


data_in =8'hA5;
start=1;

#10;
start=0;

//wait(tx_done);

////CHECK SIMULTANEOUSLY BOTH ARE GIVING THE CORRECT RESULTS
//wait(rx_valid);

#100000;
$finish;




end 


endmodule
