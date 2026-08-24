`timescale 1ns / 1ps



module uart_tx_tb;
//VERY IMPORTANT LESSON SEE FROM TB POV THE REG ARE VALUES CHANGING MATERIAL FOR UART 
//AND OUTPUT WIRES ARE JUST WIRES AS NO CHANGE IN THEIR VALUE IS REQUIRED 
reg clk;
reg rst;
reg start;
reg [7:0]data_in;


wire tx;
wire done;
wire busy;


uart_tx uut
(
    .clk(clk),
    .rst(rst),
    .start(start),
    .data_in(data_in),

    .tx(tx),
    .busy(busy),
    .done(done)
);


//TB WRITING STARTS HERE 

//CLOCK FREQ=100MHZ
initial 
clk=0;

always#5 clk=~clk;
//STIMULUS BEGINS BASICALLY DATA IN GIVEN 

task send_byte ;

input[7:0]data;
begin
 
data_in=data;
@(posedge clk);
start=1;
@(posedge clk);
start=0;
wait(done);//heere see done is usefull if not done then we would have to write time 
//which is ofc not good if baud_rate changes 

 @(posedge clk);

end

endtask

initial
begin

rst=1;
start=0;
data_in=8'h00;

#20;
rst=0;

send_byte(8'hA5);
send_byte(8'h3C);

send_byte(8'hFF);

send_byte(8'h00);

send_byte(8'h55);





$finish;


end
initial 
begin
//$MONITOR TRACKS ALL THE VALUES ON CHANGE BUT DIPLAY ONLY SHOWCASES ONCE THATS THE DIFFERENCE 

$monitor ("TIME=%0t |rst=%b |start=%b | data=0x%h tx=%b busy=%b done=%b",
$time,
rst,
start,
data_in,
tx,
busy,
done);
end
endmodule
