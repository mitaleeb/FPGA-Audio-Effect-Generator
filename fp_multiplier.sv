module fp_multiplier (
	input [15:0] sample_in,
	input signed [17:0] fp_coefficient, // fp: 3.15
	output logic signed [35:0] mult_out // fp: 19.17
);

logic signed [17:0] fp_a;

always_comb
begin
	fp_a = {sample_in, 2'd0}; // fp: 16.2
	mult_out = fp_a * fp_coefficient;
end

endmodule