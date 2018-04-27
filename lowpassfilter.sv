/**
 * Implementation of a low pass filter
 *
 * @author Dean Biskup and Mitalee Bharadwaj
 */

module lowpassfilter(
  input CLOCK_50, AUD_DACLRCK, 
  input [15:0] audio_inR,
  input [15:0] audio_inL, // 16-bit audio input
  output [15:0] lpf_outputR, lpf_outputL
  );

  // Control signals for the biquad filters
  logic new_sample, new_coefficients;
  logic signed [17:0] a0, a1, a2, b1, b2;

  // Instantiate biquads for both the left and the right sides
  biquad left(.CLOCK_50(CLOCK_50), .Reset(0), .new_sample(new_sample), 
    .new_coefficients(new_coefficients), .sample_in(audio_inL), .a0_load(a0), 
    .a1_load(a1), .a2_load(a2), .b1_load(b1), .b2_load(b2), .sample_out(lpf_outputL));
  biquad right(.CLOCK_50(CLOCK_50), .Reset(0), .new_sample(new_sample), 
    .new_coefficients(new_coefficients), .sample_in(audio_inR), .a0_load(a0), 
    .a1_load(a1), .a2_load(a2), .b1_load(b1), .b2_load(b2), .sample_out(lpf_outputR));
  
  // Always block to signal when a new sample needs to happen
  always_ff @ (posedge AUD_DACLRCK) begin
    if (new_sample)
		new_sample <= 0;
	 else 
		new_sample <= 1;
  end

  enum logic [5:0] {HALT} next_state, state;

endmodule // lowpassfilter