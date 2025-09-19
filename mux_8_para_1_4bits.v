// Arquivo: mux_8_para_1_4bits.v
module mux_8_para_1_4bits (
    input  wire [3:0] D0, D1, D2, D3, D4, D5, D6, D7,
    input  wire [2:0] S,
    output wire [3:0] Y
);

    // Instancia um MUX de 8 para 1 para cada um dos 4 bits
    mux_8_para_1 MUX_BIT0 (
        .D0(D0[0]), .D1(D1[0]), .D2(D2[0]), .D3(D3[0]),
        .D4(D4[0]), .D5(D5[0]), .D6(D6[0]), .D7(D7[0]),
        .S(S), .Y(Y[0])
    );
    mux_8_para_1 MUX_BIT1 (
        .D0(D0[1]), .D1(D1[1]), .D2(D2[1]), .D3(D3[1]),
        .D4(D4[1]), .D5(D5[1]), .D6(D6[1]), .D7(D7[1]),
        .S(S), .Y(Y[1])
    );
    mux_8_para_1 MUX_BIT2 (
        .D0(D0[2]), .D1(D1[2]), .D2(D2[2]), .D3(D3[2]),
        .D4(D4[2]), .D5(D5[2]), .D6(D6[2]), .D7(D7[2]),
        .S(S), .Y(Y[2])
    );
    mux_8_para_1 MUX_BIT3 (
        .D0(D0[3]), .D1(D1[3]), .D2(D2[3]), .D3(D3[3]),
        .D4(D4[3]), .D5(D5[3]), .D6(D6[3]), .D7(D7[3]),
        .S(S), .Y(Y[3])
    );

endmodule
