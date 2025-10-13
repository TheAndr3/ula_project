
// Módulo principal da calculadora RPN com sistema de clock real
// Implementação puramente estrutural

module calculadora_rpn_completa (
    // Entradas físicas da placa
    input  wire [9:0] SW,           // Chaves da placa
    input  wire [1:0] KEY,          // Botões da placa
    input  wire CLOCK_50,           // Clock da placa (50MHz)
    
    // Saídas físicas da placa
    output wire [6:0] HEX0,         // Display unidade
    output wire [6:0] HEX1,         // Display dezena
    output wire [6:0] HEX2,         // Display centena
    output wire [6:0] HEX3,         // Display milhar
    output wire [6:0] HEX4,         // Display operação
    output wire [6:0] HEX5,         // Display base
    output wire [9:0] LEDR          // LEDs indicadores
);

    // Mapeamento de entradas
    wire [7:0] entrada_numero = SW[7:0];        // Entrada de número de 8 bits
    wire [7:0] operacao = SW[7:0];              // Código da operação de 8 bits (mesmo que entrada_numero)
    wire [1:0] base_exibicao = SW[9:8];         // Base de exibição (00=dec, 01=hex, 10=oct)
    wire push_pilha = KEY[0];                   // KEY[0] para dar push na pilha
    wire executar_operacao = KEY[1];            // KEY[1] para executar operação
    
    // Sinais de controle de entrada simplificados
    wire entrada_numero_a, entrada_numero_b, entrada_operacao;
    
    // Código interno da operação (3 bits)
    wire [2:0] codigo_operacao_interno;

    // Fios intermediários
    wire [7:0] resultado_pilha;
    wire [7:0] display_a, display_b;
    wire [7:0] valor_exibicao;
    wire [7:0] resultado_ula;
    wire [7:0] resultado_memoria;
    wire [7:0] valor_memoria;
    
    // Flags
    wire pilha_vazia, pilha_cheia;
    wire overflow, zero, carry_out, erro;
    
    // Clock e controle
    wire clk_sync, clk_numero, clk_operacao, clk_execucao;
    wire rst;
    
    // Constantes
    wire gnd, vcc;
    wire [7:0] gnd_bus;
    
    // Gerar constantes
    and U_GND (gnd, entrada_numero[0], entrada_numero[0]);
    not U_VCC_NOT (vcc, gnd);
    
    // Atribuir GND ao barramento
    buf U_GND_BUF0 (gnd_bus[0], gnd);
    buf U_GND_BUF1 (gnd_bus[1], gnd);
    buf U_GND_BUF2 (gnd_bus[2], gnd);
    buf U_GND_BUF3 (gnd_bus[3], gnd);
    buf U_GND_BUF4 (gnd_bus[4], gnd);
    buf U_GND_BUF5 (gnd_bus[5], gnd);
    buf U_GND_BUF6 (gnd_bus[6], gnd);
    buf U_GND_BUF7 (gnd_bus[7], gnd);


    // Reset (ativo baixo)
    not U_RST (rst, gnd);

    // Controle de entrada simplificado
    controle_entrada_simples U_CONTROLE_ENTRADA (
        .entrada_numero(entrada_numero),
        .push_pilha(push_pilha),
        .executar_operacao(executar_operacao),
        .numero_para_pilha(entrada_numero),
        .codigo_operacao(codigo_operacao_interno),
        .entrada_numero_a(entrada_numero_a),
        .entrada_numero_b(entrada_numero_b),
        .entrada_operacao(entrada_operacao),
        .executar(executar_operacao)
    );

    // Controle de clock
    controle_clock U_CONTROLE_CLK (
        .clk_in(CLOCK_50),
        .rst(rst),
        .entrada_numero(push_pilha),
        .entrada_operacao(push_pilha),
        .executar(executar_operacao),
        .clk_out(clk_sync),
        .clk_numero(clk_numero),
        .clk_operacao(clk_operacao),
        .clk_execucao(clk_execucao)
    );

    // Sistema de pilha RPN
    pilha_rpn U_PILHA (
        .entrada(entrada_numero),
        .operacao(codigo_operacao_interno),
        .entrada_numero(entrada_numero_a),
        .entrada_operacao(entrada_operacao),
        .executar(executar_operacao),
        .clk(clk_sync),
        .rst(rst),
        .resultado(resultado_pilha),
        .display_a(display_a),
        .display_b(display_b),
        .pilha_vazia(pilha_vazia),
        .pilha_cheia(pilha_cheia),
        .resultado_ula(resultado_ula),
        .overflow(overflow),
        .zero(zero),
        .carry_out(carry_out),
        .erro(erro)
    );

    // Sistema de controle de memória
    controle_memoria U_CONTROLE_MEM (
        .operacao(codigo_operacao_interno),
        .resultado_ula(resultado_ula),
        .executar(executar_operacao),
        .clk(clk_sync),
        .rst(rst),
        .carregar_memoria(gnd),
        .valor_memoria(valor_memoria),
        .resultado_final(resultado_memoria)
    );

    // Display de calculadora - mostra número digitando ou resultado
    display_calculadora U_DISPLAY_CALCULADORA (
        .numero_digitando(entrada_numero),
        .resultado_ula(resultado_ula),
        .executar_operacao(executar_operacao),
        .valor_exibicao(valor_exibicao)
    );

    // Conversor de bases
    conversor_bases U_CONVERSOR (
        .valor_binario(valor_exibicao),
        .base_selecionada(base_exibicao),
        .HEX0(HEX0),
        .HEX1(HEX1),
        .HEX2(HEX2),
        .HEX3(HEX3),
        .HEX4(HEX4)
    );

    // Display HEX4 agora mostra número (não operação)
    // Conectado diretamente ao conversor de bases

		
    // Display da base
    base_7seg U_BASE_DISPLAY (
        .seletor(base_exibicao),
        .HEX5(HEX5)
    );

    // LEDs indicadores
    buf U_LED0 (LEDR[0], zero);                 // Flag Zero
    buf U_LED1 (LEDR[1], overflow);             // Flag Overflow
    buf U_LED2 (LEDR[2], carry_out);            // Flag Carry Out
    buf U_LED3 (LEDR[3], erro);                 // Flag Erro
    buf U_LED4 (LEDR[4], pilha_vazia);          // Pilha Vazia
    buf U_LED5 (LEDR[5], pilha_cheia);          // Pilha Cheia
    buf U_LED6 (LEDR[6], entrada_numero_a);     // Indica estágio A (contador 00)
    buf U_LED7 (LEDR[7], entrada_numero_b);     // Indica estágio B (contador 01)
    buf U_LED8 (LEDR[8], entrada_operacao);     // Indica estágio Operação (contador 10)
    buf U_LED9 (LEDR[9], executar_operacao);    // Indica estágio Executar (contador 11)

endmodule
