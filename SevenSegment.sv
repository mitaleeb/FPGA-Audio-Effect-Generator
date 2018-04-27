/**
 * The SevenSegment module handles the display of the alphanumeric characters 
 * onto the seven segment displays.
 *
 * This is preferred over the HexDriver module since it can also do letters
 * outside of the 6 used in hexadecimal.
 *
 * @author Dean Biskup and Mitalee Bharadwaj
 * @version ECE 385, Spring 2018. University of Illinois at Urbana-Champaign
 */
module SevenSegment(input logic [6:0] in0, 
  output logic [6:0] out0);

  always_comb begin
    /**
     *     1
     * *********
     * *       *
     * *6      *2
     * *       *
     * *********
     * *   7   *
     * *5      *3
     * *       *
     * *********
     *     4
     */
    unique case (in0)
      7'd48 : out0 = 7'b1000000; // '0'
      7'd49 : out0 = 7'b1111001; // '1'
      7'd50 : out0 = 7'b0100100; // '2'
      7'd51 : out0 = 7'b0110000; // '3'
      7'd52 : out0 = 7'b0011001; // '4'
      7'd53 : out0 = 7'b0010010; // '5'
      7'd54 : out0 = 7'b0000010; // '6'
      7'd55 : out0 = 7'b1111000; // '7'
      7'd56 : out0 = 7'b0000000; // '8'
      7'd57 : out0 = 7'b0010000; // '9'
      7'd65 : out0 = 7'b0001000; // 'A'
      7'd66 : out0 = 7'b0000011; // 'b'
      7'd67 : out0 = 7'b1000110; // 'C'
      7'd68 : out0 = 7'b0100001; // 'd'
      7'd69 : out0 = 7'b0000110; // 'E'
      7'd70 : out0 = 7'b0001110; // 'F'
      7'd71 : out0 = 7'b1000010; // 'G'
      7'd72 : out0 = 7'b0001011; // 'h'
      7'd73 : out0 = 7'b1111011; // 'i'
      7'd74 : out0 = 7'b1100001; // 'J'
      7'd75 : out0 = 7'b0000101; // 'k' THIS ONE SUCKS, DO NOT USE
      7'd76 : out0 = 7'b1000111; // 'L'
      7'd77 : out0 = 7'b1101010; // 'M' ALSO SUCKS, AVOID IF POSSIBLE
      7'd78 : out0 = 7'b0101011; // 'n'
      7'd79 : out0 = 7'b0100011; // 'o'
      7'd80 : out0 = 7'b0001100; // 'P'
      7'd81 : out0 = 7'b0011000; // 'q'
      7'd82 : out0 = 7'b0101111; // 'r'
      7'd83 : out0 = 7'b0010010; // 'S'
      7'd84 : out0 = 7'b0000111; // 't'
      7'd85 : out0 = 7'b1100011; // 'u'
      7'd86 : out0 = 7'b1000001; // 'V'
      7'd87 : out0 = 7'b1010101; // 'W' ALSO SUPER SUCKS
      7'd88 : out0 = 7'b0001001; // 'X'
      7'd89 : out0 = 7'b0010001; // 'Y'
      7'd90 : out0 = 7'b0100100; // 'Z'
      default : out0 = 7'b11111111; // Blanks the display
    endcase
  end // always_comb
endmodule // SevenSegment
