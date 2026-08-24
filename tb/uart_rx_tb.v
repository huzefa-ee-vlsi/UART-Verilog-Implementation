`timescale 1ns / 1ps



module uart_rx_tb(

    );
    
    reg clk;
    reg rst;
    reg rx;
    
    wire [7:0] data_out;
    wire busy;
    wire rx_valid;
    
    uart_rx uut (
    .clk(clk),
    .rst(rst),
    .rx(rx),
    .data_out(data_out),
    .busy(busy),
    .rx_valid(rx_valid)
);

always #5 clk =~clk;

task send_bit;

input bit_value;
begin
rx=bit_value;
#8680;//the bit period is clock_freq/baud_rate now for 10ns (one bit period*10ns) this is the time it takes to verify that rx is valid or not ofc 
end
endtask

task send_byte;
    input [7:0] data;
    integer i;

    begin
        
        send_bit(1'b0);//START

        
        for (i = 0; i < 8; i = i + 1)begin
            send_bit(data[i]);
end
        
        send_bit(1'b1);//STOP
    end
endtask
   

initial begin

    clk = 0;
    rst = 1;
    rx = 1;

    #20;
    rst = 0;

    #100;

    send_byte(8'hA5);

    
    
    send_byte(8'h3C);


   send_byte(8'hFF);


   send_byte(8'h00);


   send_byte(8'h55);


    

    #100;

    $finish;

end




    
endmodule
