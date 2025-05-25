module fifo(
    input   clk,
    input   rst_n,

    // Write interface
    input   wr_en,
    input   [7:0] data_in,
    output  full,

    // Read interface
    input   rd_en,
    output  reg [7:0] data_out,
    output  empty,

    // status
    output reg [3:0] fifo_words  // Current number of elements
);
    //insira seu código aqui

/*
 * OBS: Seguindo a fifo do L16, mantendo apenas um bloco always para todas as operações,
 *      a implementação não passava nos testes. Separar cada operação em um bloco always foi
 *      suficiente para atenter os arquivos de teste do presente exercício.
*/
    localparam BUFFER_BIT_LEN = 8;
    localparam BUFFER_LEN     = 8;
    reg [BUFFER_BIT_LEN-1:0] buffer_data [0:BUFFER_LEN-1];
    reg [BUFFER_BIT_LEN-1:0] w_ptr, r_ptr;

    assign full       = (w_ptr == r_ptr-1) || (w_ptr == BUFFER_LEN && r_ptr == 0);
    assign empty      = (w_ptr == r_ptr);

    always @(posedge clk) begin
        if(!rst_n) begin
            w_ptr      = 8'd0;
        end else begin
            if (wr_en && !full) begin
                buffer_data[w_ptr] = data_in;
                w_ptr <= w_ptr + 1;
            end
        end
    end

    always @(posedge clk) begin
        if(!rst_n) begin
            r_ptr      = 8'd0;
        end else begin
            if (rd_en && !empty) begin
                data_out = buffer_data[r_ptr];
                r_ptr <= r_ptr + 1;
            end
        end
    end

    always @(w_ptr or r_ptr) begin
        fifo_words = w_ptr-r_ptr;
    end
endmodule