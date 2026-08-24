`timescale 1ns / 1ps



module uart_rx#(
parameter CLOCK_FREQ=100_000_000,
parameter BAUD_RATE= 115_200)
 (
input clk,
input rst,
input rx,

output reg [7:0] data_out,
output reg busy,
output reg rx_valid

    );
   
localparam BAUD_DIV=CLOCK_FREQ/BAUD_RATE;   
    
localparam 

IDLE=2'b00,
START=2'b01,
STOP=2'b11,
DATA= 2'b10;
    
    
reg [2:0]bit_count   ;
reg [$clog2(BAUD_DIV)-1:0] baud_counter;
reg [7:0]temp_data;
reg [1:0] current_state;
 
    
always@(posedge clk)
begin
if(rst) begin 
current_state<=IDLE;
data_out<=0;
busy<=0;
rx_valid<=0;
bit_count<=3'd0;
//temp_data<=8'd0; NO NEED TO WRITE THIS AS WE ARE GOING TO OVERWRITE IT ANYWAY
baud_counter<=0;
end

else begin 

case (current_state)
IDLE: begin
busy<=1'd0;
rx_valid<=0;
bit_count<=3'd0;
temp_data<=8'd0;
baud_counter<=0;

if (rx==1'b0) begin 
busy<=1'd1;
current_state<=START;
baud_counter <= 0;
bit_count <= 3'd0;

end 


end


START:begin

if(baud_counter==(BAUD_DIV/2-1))begin
if(rx==1'b0)begin
baud_counter<=0;
current_state<=DATA;
end
else begin
baud_counter<=0;
busy<=0;
current_state<=IDLE;
end

end
else begin
baud_counter <= baud_counter + 1'b1;
end

end


DATA: begin
if(baud_counter==BAUD_DIV-1) begin 
baud_counter<=0;

//bit storing
temp_data[bit_count]<=rx;

if(bit_count==3'd7)begin
current_state<=STOP;
bit_count<=0;
end


else begin
bit_count<=bit_count+1;

end


end


else begin
baud_counter<=baud_counter+1;
end
end


STOP: begin
if(baud_counter==BAUD_DIV-1)begin

baud_counter<=0;


if(rx==1'b1)begin
data_out<=temp_data;
bit_count<=0;
current_state<=IDLE;
rx_valid<=1'b1;
busy<=1'd0;
baud_counter<=0;

end
else begin 
busy<=1'd0;
rx_valid<=0;
baud_counter<=0;
bit_count<=0;
current_state<=IDLE;
end


end
else begin
baud_counter<=baud_counter+1;
end 

end
endcase


end 
end
    
    
    
endmodule
