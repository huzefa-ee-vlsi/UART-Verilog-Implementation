`timescale 1ns / 1ps



module uart_tx  #(
parameter CLOCK_FREQ= 100_000_000,
parameter BAUD_RATE= 115_200 // DECLARFE THESE SO WHWENVER WE CHANGE ONLY ONCE CHANGE IS REQUIRED 
)

(
input  wire clk,
input  wire rst,
input wire [7:0] data_in,
input wire start,
output reg tx,
output reg busy,
output reg done


    );
    


localparam integer BAUD_DIV= CLOCK_FREQ/BAUD_RATE;    


localparam 

IDLE=2'b00,
START=2'b01,
STOP=2'b11,
DATA= 2'b10;


reg [7:0] data_reg;
reg [2:0] bit_count;
reg [$clog2(BAUD_DIV)-1:0] baud_counter;
reg[1:0] current_state;



always@(posedge clk)
begin
if(rst) 
begin 
 current_state<=IDLE;
 
 tx<=1'b1;
 busy<=1'b0;
 done<=1'b0;
 bit_count<=3'd0;
 baud_counter<=0;
 end 
 
 else 
 begin 
 //UART LOGIC STARTS NOW 
 
 done<=1'b0;
 case(current_state)
 
 
 IDLE :
 begin 
 tx<=1'b1;
 busy<=1'b0;
 
 
 if(start)
 begin 
 data_reg<=data_in;
 bit_count<=3'd0;
 baud_counter <= 0;
 busy<=1'b1;
 current_state<=START;
 end
 
 
 end 
 
 
 START : 
 begin 
 
 tx<=1'b0;
 
 if(baud_counter==BAUD_DIV-1)
 begin 
 baud_counter<=0;
 current_state<= DATA; 
 end
 else 
 begin
 baud_counter<=baud_counter+1;
 end
 
 
 
 
 
 end 
 
 
 DATA:
 begin
 
 tx<= data_reg[bit_count];
 
 if(baud_counter ==BAUD_DIV-1)
 
 begin
 baud_counter<=0;
 
 if(bit_count==3'd7)
 
 begin
 current_state<=STOP;
 end
 
 
 else
 
 begin
 bit_count<= bit_count+1;
 end
 
 end 
 
 else 
 begin 
 baud_counter<=baud_counter+1;
 
 end 
 end
 
 
 STOP :
 begin
 
 tx<=1'b1;
 
 if(baud_counter==BAUD_DIV-1)
 begin
 baud_counter<=0;
 
 
 busy<=1'b0;
 done<=1'b1;
 
 current_state<=IDLE;
 end
 
 else
 begin
 baud_counter<=baud_counter+1;
 end
 
 end


endcase
end
end
endmodule
