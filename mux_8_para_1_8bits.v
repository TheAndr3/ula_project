// Arquivo: mux_8_para_1_5bits.v
module mux_8_para_1_8bits (
    input  wire [4:0] D0, D1, D6,
	 input D2, D3,  D5, 
	 input wire [7:0] D4, D7,
    input  wire [2:0] S,
    output wire [7:0] Y
);

	wire gnd = 1'b0;

    // Instancia um MUX de 8 para 1 para cada um dos 4 bits
    mux_8_para_1 MUX_BIT0 (
        .D0(D0[0]), .D1(D1[0]), .D2(D2), .D3(D3),
        .D4(D4[0]), .D5(D5), .D6(D6[0]), .D7(D7[0]),
        .S(S), .Y(Y[0])
    );
    mux_8_para_1 MUX_BIT1 (
        .D0(D0[1]), .D1(D1[1]), .D2(gnd), .D3(gnd),
        .D4(D4[1]), .D5(gnd), .D6(D6[1]), .D7(D7[1]),
        .S(S), .Y(Y[1])
    );
    mux_8_para_1 MUX_BIT2 (
        .D0(D0[2]), .D1(D1[2]), .D2(gnd), .D3(gnd),
        .D4(D4[2]), .D5(gnd), .D6(D6[2]), .D7(D7[2]),
        .S(S), .Y(Y[2])
    );
    mux_8_para_1 MUX_BIT3 (
        .D0(D0[3]), .D1(D1[3]), .D2(gnd), .D3(gnd),
        .D4(D4[3]), .D5(gnd), .D6(D6[3]), .D7(D7[3]),
        .S(S), .Y(Y[3])
    );
	 mux_8_para_1 MUX_BIT4 (
        .D0(D0[4]), .D1(D1[4]), .D2(gnd), .D3(gnd),
        .D4(D4[4]), .D5(gnd), .D6(D6[4]), .D7(D7[4]),
        .S(S), .Y(Y[4])
    );
	 mux_8_para_1 MUX_BIT5 (
        .D0(gnd), .D1(gnd), .D2(gnd), .D3(gnd),
        .D4(D4[5]), .D5(gnd), .D6(gnd), .D7(D7[4]),
        .S(S), .Y(Y[5])
    );
	 mux_8_para_1 MUX_BIT6 (
        .D0(gnd), .D1(gnd), .D2(gnd), .D3(gnd),
        .D4(D4[6]), .D5(gnd), .D6(gnd), .D7(D7[4]),
        .S(S), .Y(Y[6])
    );
	 mux_8_para_1 MUX_BIT7 (
        .D0(gnd), .D1(gnd), .D2(gnd), .D3(gnd),
        .D4(D4[7]), .D5(gnd), .D6(gnd), .D7(D7[4]),
        .S(S), .Y(Y[7])
    );

endmodule