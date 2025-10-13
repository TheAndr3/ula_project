// Sistema RPN completo com contador sincronizado e registradores
// Implementação puramente estrutural

module sistema_rpn_completo (
    input  wire [7:0] entrada_numero,    // Entrada de número de 8 bits
    input  wire push_pilha,              // KEY[0] - Push na pilha
    input  wire executar_operacao,       // KEY[1] - Mostrar resultado
    input  wire clk,                     // Clock da placa
    input  wire rst,                     // Reset
    output wire [7:0] valor_exibicao,    // Valor para exibição
    output wire [1:0] estado_contador,   // Estado atual do contador
    output wire entrada_numero_a,        // Enable para entrada do número A
    output wire entrada_numero_b,        // Enable para entrada do número B
    output wire entrada_operacao,        // Enable para entrada da operação
    output wire [2:0] codigo_operacao,   // Código da operação
    output wire [7:0] resultado_ula,     // Resultado da ULA
    output wire overflow, zero, carry_out, erro
);

    // Fios intermediários
    wire [1:0] contador_entrada;
    wire contador_00, contador_01, contador_10, contador_11;
    wire [7:0] reg_a, reg_b, reg_operacao;
    
    // Constantes
    wire gnd;
    
    // Gerar constantes
    and U_GND (gnd, entrada_numero[0], entrada_numero[0]);

    // ========================================
    // CONTADOR DE 2 BITS SINCRONIZADO
    // ========================================
    
    contador_2bits U_CONTADOR_ENTRADA (
        .clk(clk),                       // Clock sincronizado
        .rst(rst),                       // Reset
        .enable(push_pilha),             // Enable = push_pilha (KEY[0])
        .count(contador_entrada)
    );

    // Saída do contador
    buf U_CONT_OUT0 (estado_contador[0], contador_entrada[0]);
    buf U_CONT_OUT1 (estado_contador[1], contador_entrada[1]);

    // ========================================
    // DETECÇÃO DOS ESTADOS DO CONTADOR
    // ========================================
    
    // contador_00: contador[1] = 0 AND contador[0] = 0
    wire not_contador1, not_contador0;
    not U_NOT_CONT1 (not_contador1, contador_entrada[1]);
    not U_NOT_CONT0 (not_contador0, contador_entrada[0]);
    and U_CONT_00 (contador_00, not_contador1, not_contador0);
    
    // contador_01: contador[1] = 0 AND contador[0] = 1
    and U_CONT_01 (contador_01, not_contador1, contador_entrada[0]);
    
    // contador_10: contador[1] = 1 AND contador[0] = 0
    and U_CONT_10 (contador_10, contador_entrada[1], not_contador0);
    
    // contador_11: contador[1] = 1 AND contador[0] = 1
    and U_CONT_11 (contador_11, contador_entrada[1], contador_entrada[0]);

    // ========================================
    // REGISTRADORES PARA SALVAR VALORES (LÓGICA RPN)
    // ========================================
    
    // Lógica RPN com contador de etapas:
    // Estado 00: Entrada do primeiro número (A) - LEDR[6] acende
    // Estado 01: Entrada do segundo número (B) - LEDR[7] acende  
    // Estado 10: Entrada da operação (000-111) - LEDR[8] acende
    // Estado 11: Execução automática e reset para 00
    
    // Registrador A (salva quando contador = 00 E push_pilha = 1)
    registrador_8bits U_REG_A (
        .D(entrada_numero),
        .clk(clk),
        .rst(rst),
        .enable(contador_00 & push_pilha),
        .Q(reg_a)
    );
    
    // Registrador B (salva quando contador = 01 E push_pilha = 1)
    registrador_8bits U_REG_B (
        .D(entrada_numero),
        .clk(clk),
        .rst(rst),
        .enable(contador_01 & push_pilha),
        .Q(reg_b)
    );
    
    // Registrador Operação (salva quando contador = 10 E push_pilha = 1)
    registrador_8bits U_REG_OP (
        .D(entrada_numero),
        .clk(clk),
        .rst(rst),
        .enable(contador_10 & push_pilha),
        .Q(reg_operacao)
    );

    // ========================================
    // CÓDIGO DA OPERAÇÃO
    // ========================================
    
    // Código da operação: 3 bits menos significativos do registrador
    buf U_OP0 (codigo_operacao[0], reg_operacao[0]);
    buf U_OP1 (codigo_operacao[1], reg_operacao[1]);
    buf U_OP2 (codigo_operacao[2], reg_operacao[2]);

    // ========================================
    // ULA PARA EXECUTAR OPERAÇÕES
    // ========================================
    
    ula_8bits U_ULA (
        .a(reg_a),
        .b(reg_b),
        .operacao(codigo_operacao),
        .clk(clk),
        .rst(rst),
        .resultado(resultado_ula),
        .overflow(overflow),
        .zero(zero),
        .carry_out(carry_out),
        .erro(erro)
    );

    // ========================================
    // LÓGICA DE EXIBIÇÃO
    // ========================================
    
    // Sistema de exibição inteligente:
    // - Durante entrada (KEY[1] = 0): Mostra número sendo digitado em tempo real
    // - Após operação (KEY[1] = 1): Mostra resultado da última operação executada
    // - O resultado fica disponível após o estado 11 (execução automática)
    
    mux_2_para_1_8bits U_MUX_EXIBICAO (
        .D0(entrada_numero),      // Número digitando (tempo real)
        .D1(resultado_ula),       // Resultado da ULA (após operação)
        .S(executar_operacao),    // Seletor = KEY[1] (executar_operacao)
        .Y(valor_exibicao)
    );

    // ========================================
    // SINAIS DE CONTROLE E INDICADORES
    // ========================================
    
    // Sinais de controle para LEDs indicadores:
    // - entrada_numero_a: LEDR[6] - Indica que está no estado de entrada do número A
    // - entrada_numero_b: LEDR[7] - Indica que está no estado de entrada do número B  
    // - entrada_operacao: LEDR[8] - Indica que está no estado de entrada da operação
    
    buf U_ENTRADA_A (entrada_numero_a, contador_00);  // LEDR[6]: Estado A
    buf U_ENTRADA_B (entrada_numero_b, contador_01);  // LEDR[7]: Estado B
    buf U_ENTRADA_OP (entrada_operacao, contador_10); // LEDR[8]: Estado Operação

endmodule
