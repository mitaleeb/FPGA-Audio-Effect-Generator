/**
 * Top-level entity for audio FX generator.
 *
 * ECE 385 Spring 2018 at the University of Illinois
 *
 * Dean Biskup and Mitalee Bharadwaj
 *
 * xd
 */
module audi_efx_gen (
  // 50 MHz Clock input
  input CLOCK_50,  
  input CLOCK2_50,

  // PUSH BUTTONS
  input logic [3:0] KEY,

  // Switches
  input logic [17:0] SW, 

  // HEX Displays
  output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7,

  // LEDs
  output [8:0] LEDG, 
  output [17:0] LEDR, 

  // I2C connections
  inout I2C_SDAT, 
  output I2C_SCLK, 

  // Audio Codec Signals
  inout AUD_ADCLRCK, // ADC LR Clock
  input AUD_ADCDAT, // ADC DATA
  inout AUD_DACLRCK, // DAC LR Clock
  output AUD_DACDAT, // DAC DATA
  inout AUD_BCLK, // Bit-Stream Clock
  output AUD_XCK // Chip Clock
);

  // Do some connections for debugging
  assign LEDR = SW;
  assign LEDG = 8'b0;
  
  // Create some local connections
  logic DLY_RESET;
  logic [3:0] filter_select;
  assign filter_select = SW[4:1];

  logic AUD_CTRL_CLK; // For Audio Controller

  // Assign the easy clocks to what they need to be
  assign AUD_ADCLRCK = AUD_DACLRCK;
  assign AUD_XCK = AUD_CTRL_CLK;

  // Audio signals 
  logic [15:0] audio_inL, audio_inR;
  logic [15:0] audio_outL, audio_outR, DSP_outL, DSP_outR;

  // Update audio signals
  always_ff @ (negedge AUD_DACLRCK) begin
    audio_outR <= DSP_outR;
  end

  always_ff @ (posedge AUD_DACLRCK) begin
    audio_outL <= DSP_outL;
  end 
  
  audio_modifier amod(.*, .DSP_enable(SW[0]), .vol_up(~KEY[1]), .vol_down(~KEY[0]));

  ////////// AUDIO IO //////////

  // Initialize the VGA_Audio_PLL provided by Altera
  Reset_Delay r0 (.iCLK(CLOCK_50), .oRESET(DLY_RESET));
  VGA_Audio_PLL vgapll(.areset(~DLY_RESET), .inclk0(CLOCK2_50), .c1(AUD_CTRL_CLK));

  I2C_AV_Config i2ccontroller (
    // Host Side
    .iCLK(CLOCK_50), .iRST_N(KEY[0]), 
    // I2C side
    .I2C_SCLK(I2C_SCLK),
    .I2C_SDAT(I2C_SDAT));  

  audio_clock aclock (
    // Audio Side
    .oAUD_BCK (AUD_BCLK), .oAUD_LRCK(AUD_DACLRCK), 
    // Control Signals
    .iCLK_18_4(AUD_CTRL_CLK), .iRST_N(DLY_RESET));

  audio_converter aconvert (
    // Audio side
    .AUD_BCK(AUD_BCLK), .AUD_LRCK(AUD_DACLRCK),
    .AUD_ADCDAT(AUD_ADCDAT), .AUD_DATA(AUD_DACDAT), 
    // Controller Side 
    .iRST_N(DLY_RESET), 
    .AUD_outL(audio_outL), 
    .AUD_outR(audio_outR), 
    .AUD_inL(audio_inL), 
    .AUD_inR(audio_inR));

  // Always ff block to make things readable
  int counterxd;
  //assign LEDR = counterxd[17:0];
  logic [3:0] hi0, hi1, hi2, hi3, hi4, hi5, hi6, hi7;
  always_ff @ (posedge CLOCK_50) begin 
    if (counterxd == 5000000) begin
      hi0 <= audio_outR[3:0];
      hi1 <= audio_outR[7:4];
      hi2 <= audio_outR[11:8];
      hi3 <= audio_outR[15:12];
      hi4 <= audio_outL[3:0];
      hi5 <= audio_outL[7:4];
      hi6 <= audio_outL[11:8];
      hi7 <= audio_outL[15:12];
		counterxd <= 0;
	end else begin
		hi0 <= hi0;
      hi1 <= hi1;
      hi2 <= hi2;
      hi3 <= hi3;
      hi4 <= hi4;
      hi5 <= hi5;
      hi6 <= hi6;
      hi7 <= hi7;
		counterxd <= counterxd + 1;
	end
  end

  // Hex Drivers
  HexDriver h0(.In0(hi0), .Out0(HEX0));
  HexDriver h1(.In0(hi1), .Out0(HEX1));
  HexDriver h2(.In0(hi2), .Out0(HEX2));
  HexDriver h3(.In0(hi3), .Out0(HEX3));
  HexDriver h4(.In0(hi4), .Out0(HEX4));
  HexDriver h5(.In0(hi5), .Out0(HEX5));
  HexDriver h6(.In0(hi6), .Out0(HEX6));
  HexDriver h7(.In0(hi7), .Out0(HEX7));

endmodule