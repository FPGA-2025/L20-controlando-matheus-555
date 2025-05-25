module fsm(
    input   clk,
    input   rst_n,

    output reg wr_en,

    output [7:0] fifo_data,
    
    input [3:0] fifo_words
);

    // insira seu código aqui
    localparam QTDE_PALAVARAS = 5;
    localparam RESET   = 2'd0;
    localparam ESREVER = 2'd1;
    localparam LER     = 2'd2;

    reg [1:0] estado, proximo_estado;
    reg [7:0] _fifo_data;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n && estado !== RESET) begin
            estado <= RESET;
        end else begin
            estado <= proximo_estado;
        end
    end

    always @(*) begin
        case (estado)
            RESET: begin
                proximo_estado <= ESREVER;
            end

            ESREVER: begin
                proximo_estado <= (fifo_words >= QTDE_PALAVARAS) ? LER : ESREVER;
            end

            LER: begin
                proximo_estado <= (fifo_words <= 2) ? ESREVER : LER;
            end
        endcase
    end

    always @(*) begin
        _fifo_data <= 8'hAA;

        case (estado)
            RESET: begin

            end

            ESREVER: begin
                wr_en <= 1;
            end

            LER: begin
                wr_en <= 0;
            end
        endcase
    end

    assign fifo_data = _fifo_data;
endmodule
               



