// Módulo display de calculadora - mostra número digitando ou resultado
// Implementação puramente estrutural

module display_calculadora (
    input  wire [7:0] numero_digitando,  // Número das chaves SW[7:0]
    input  wire [7:0] resultado_ula,     // Resultado da operação
    input  wire executar_operacao,       // KEY[1] - mostra resultado quando pressionado
    output wire [7:0] valor_exibicao     // Valor a ser exibido nos displays
);

    // Constantes
    wire gnd, vcc;
    
    // Gerar constantes
    and U_GND (gnd, numero_digitando[0], numero_digitando[0]);
    not U_VCC_NOT (vcc, gnd);

    // ========================================
    // LÓGICA SIMPLES DE SELEÇÃO
    // ========================================
    
    // Seleção baseada em executar_operacao (KEY[1]):
    // - Se KEY[1] = 0: mostra numero_digitando (tempo real)
    // - Se KEY[1] = 1: mostra resultado_ula
    
    // Multiplexador para cada bit
    mux_2_para_1 U_MUX0 (
        .D0(numero_digitando[0]),
        .D1(resultado_ula[0]),
        .S(executar_operacao),
        .Y(valor_exibicao[0])
    );
    
    mux_2_para_1 U_MUX1 (
        .D0(numero_digitando[1]),
        .D1(resultado_ula[1]),
        .S(executar_operacao),
        .Y(valor_exibicao[1])
    );
    
    mux_2_para_1 U_MUX2 (
        .D0(numero_digitando[2]),
        .D1(resultado_ula[2]),
        .S(executar_operacao),
        .Y(valor_exibicao[2])
    );
    
    mux_2_para_1 U_MUX3 (
        .D0(numero_digitando[3]),
        .D1(resultado_ula[3]),
        .S(executar_operacao),
        .Y(valor_exibicao[3])
    );
    
    mux_2_para_1 U_MUX4 (
        .D0(numero_digitando[4]),
        .D1(resultado_ula[4]),
        .S(executar_operacao),
        .Y(valor_exibicao[4])
    );
    
    mux_2_para_1 U_MUX5 (
        .D0(numero_digitando[5]),
        .D1(resultado_ula[5]),
        .S(executar_operacao),
        .Y(valor_exibicao[5])
    );
    
    mux_2_para_1 U_MUX6 (
        .D0(numero_digitando[6]),
        .D1(resultado_ula[6]),
        .S(executar_operacao),
        .Y(valor_exibicao[6])
    );
    
    mux_2_para_1 U_MUX7 (
        .D0(numero_digitando[7]),
        .D1(resultado_ula[7]),
        .S(executar_operacao),
        .Y(valor_exibicao[7])
    );

endmodule
