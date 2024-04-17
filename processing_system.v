`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/03/30 23:40:12
// Design Name: 
// Module Name: processing_system
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module processing_system(
    inout scl,
    inout sda,
    input reset,
    input sys_clk1
    );
   
    
  /*  wire clk_100;
    reg tvalid;
    assign tvaild=1;
    reg tlast;
    reg [10:0]counter=0;
    wire tready;
    reg [1:0]trans_state;//00 idle 11 send 10 finish
    always@(posedge clk_100 )
    begin
    if(adcDataReady & trans_state==00)
    begin
    tvalid<=1;
    trans_state<=11;
    end
    else if (tready & trans_state==11)
    begin
    tlast<=1;
    tvalid<=0;
    trans_state<=10;
    end
    else if (adcDataReady==0 )
    trans_state<=00;
    else 
    begin
    trans_state<=trans_state;
    tvalid<=tvalid;
    tlast<=tlast;
    end
    end
    
   


    design_1_wrapper DMA_wrapper(
    .S_AXIS_0_tdata(adcOutputData),
    .S_AXIS_0_tready(tready),
    .S_AXIS_0_tvalid(tvalid),
    .S_AXIS_0_tkeep(2'b11),
    .S_AXIS_0_tlast(tlast),
    .clk_100(clk_100)
    
    );
    */
reg [15:0]adcData;
always@( posedge   sys_clk1)
if (adcDataReady)
adcData<=adcOutputData;
else
adcData<=adcData;

    
design_2_wrapper gpio(
.gpio_rtl_0_tri_i(adcData)
//.gpio_rtl_1_tri_o(adcEnable)
);

wire [1:0] i2cInstruction;
wire [7:0] i2cByteToSend;
wire [7:0] i2cByteReceived;
wire i2cComplete;
wire i2cEnable;

wire sdaIn;
wire sdaOut;
wire isSending;
assign sda = (isSending & !sdaOut) ? 1'b0 : 1'bz;
assign sdaIn = sda ? 1'b1 : 1'b0;
wire [2:0]state;
i2c c(
sys_clk1,
sdaIn,
sdaOut,
isSending,
scl,
i2cInstruction,
i2cEnable,
i2cByteToSend,
i2cByteReceived,
i2cComplete,
state
);

wire [1:0] adcChannel = 0;
wire [15:0] adcOutputData;
wire [4:0]state;
wire adcDataReady;

reg adcEnable = 1;

reg [9:0]temp_counter2;
always @( posedge sys_clk1)
if (adcDataReady  & temp_counter2==10'b0000111111)
begin
adcEnable<=0;
temp_counter2<=0;
end
else if(adcDataReady)
begin
adcEnable<=1;
temp_counter2<=temp_counter2+1;
end
else 
begin
adcEnable<=adcEnable;
temp_counter2<=temp_counter2;
end

adc_controller #(7'b1001000) a(
sys_clk1,
adcChannel,
adcOutputData,
adcDataReady,
adcEnable,
i2cInstruction,
i2cEnable,
i2cByteToSend,
i2cByteReceived,
i2cComplete,
);

    
    
    
/*   ila_0 ila(
   .clk(sys_clk1),
   //.probe0(adcEnable),
   //.probe1(adcOutputData),
   .probe5(adcDataReady),
   .probe2(adcOutputData),
   .probe0(scl),
   .probe1(sda),
   //.probe2(i2cByteReceived),
   .probe3(state),
   .probe4(i2cByteToSend)
   );*/
endmodule
