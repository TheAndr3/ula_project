// Módulo de controle de entrada com contador para calculadora RPN
// Implementação puramente estrutural
// Contador: 00=A, 01=B, 10=Operação, 11=Executar

module controle_entrada_simples (
    input  wire [7:0] entrada_numero,    // Entrada de número de 8 bits
    input  wire push_pilha,              // KEY[0] - Incrementa contador
    input  wire executar_operacao,       // KEY[1] - Executar operação (não usado no contador)
    output wire [7:0] numero_para_pilha, // Número a ser empilhado
    output wire [2:0] codigo_operacao,   // Código da operação (3 bits menos significativos)
    output wire entrada_numero_a,        // Enable para entrada do número A
    output wire entrada_numero_b,        // Enable para entrada do número B
    output wire entrada_operacao,        // Enable para entrada da operação
    output wire executar                 // Enable para executar operação
);

    // Fios intermediários
    wire [1:0] contador_entrada;           // Contador de 2 bits
    wire contador_00, contador_01, contador_10, contador_11;
    
    // Constantes
    wire gnd, vcc;
    
    // Gerar constantes
    and U_GND (gnd, entrada_numero[0], entrada_numero[0]);
    not U_VCC_NOT (vcc, gnd);

    // ========================================
    // CONTADOR DE 2 BITS
    // ========================================
    
    contador_2bits U_CONTADOR_ENTRADA (
        .clk(push_pilha),        // Clock = push_pilha (KEY[0])
        .rst(gnd),               // Reset sempre desabilitado
        .enable(vcc),            // Enable sempre ativo
        .count(contador_entrada)
    );

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
    // NÚMERO PARA PILHA E CÓDIGO DE OPERAÇÃO
    // ========================================
    
    // Número para pilha: sempre a entrada atual
    buf U_NUM0 (numero_para_pilha[0], entrada_numero[0]);
    buf U_NUM1 (numero_para_pilha[1], entrada_numero[1]);
    buf U_NUM2 (numero_para_pilha[2], entrada_numero[2]);
    buf U_NUM3 (numero_para_pilha[3], entrada_numero[3]);
    buf U_NUM4 (numero_para_pilha[4], entrada_numero[4]);
    buf U_NUM5 (numero_para_pilha[5], entrada_numero[5]);
    buf U_NUM6 (numero_para_pilha[6], entrada_numero[6]);
    buf U_NUM7 (numero_para_pilha[7], entrada_numero[7]);

    // Código da operação: 3 bits menos significativos
    buf U_OP0 (codigo_operacao[0], entrada_numero[0]);
    buf U_OP1 (codigo_operacao[1], entrada_numero[1]);
    buf U_OP2 (codigo_operacao[2], entrada_numero[2]);

    // ========================================
    // CONTROLE DE ENTRADA BASEADO NO CONTADOR
    // ========================================
    
    // entrada_numero_a: ativo quando contador = 00
    buf U_ENTRADA_A (entrada_numero_a, contador_00);
    
    // entrada_numero_b: ativo quando contador = 01
    buf U_ENTRADA_B (entrada_numero_b, contador_01);
    
    // entrada_operacao: ativo quando contador = 10
    buf U_ENTRADA_OP (entrada_operacao, contador_10);
    
    // executar: ativo quando contador = 11
    buf U_EXECUTAR (executar, contador_11);

endmodule
