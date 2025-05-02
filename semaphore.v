module Semaphore #(
    parameter CLK_FREQ = 100_000_000
) (
    input wire clk,
    input wire rst_n,

    input wire pedestrian,

    output wire green,
    output wire yellow,
    output wire red
);

localparam VERMELHO=2'b01;
localparam AMARELO=2'b10;
localparam VERDE=2'b11;
 
localparam CICLO_VERMELHO   = (CLK_FREQ * 5) - 1;
localparam CICLO_AMARELO    = (CLK_FREQ / 2) - 1;
localparam CICLO_VERDE      = (CLK_FREQ * 7) - 1;

reg [31:0]cont;
reg [1:0] estado;

assign green    = (estado == VERDE);
assign yellow   = (estado == AMARELO);
assign red      = (estado == VERMELHO);

always @(posedge clk or negedge rst_n) 
begin
    if(rst_n==0)
    begin
        estado = VERMELHO;
        cont = 0;
    end
    else
    begin
        case(estado)

        VERMELHO: 
        begin
            if(cont >= CICLO_VERMELHO)
            begin
                estado <= VERDE;
                cont <= 0; 
            end
            else
            begin
                cont <= cont + 1;
            end
        end 

        AMARELO: 
        begin
            if(cont >= CICLO_AMARELO)
            begin
                estado <= VERMELHO;
                cont = 0;
            end
            else
            begin
                cont <= cont + 1;
            end
        end 

        VERDE: 
        begin
            if(pedestrian || (cont >= CICLO_VERDE))
            begin
                estado <= AMARELO;
                cont <= 0;
            end
            else
            begin
                cont <= cont + 1;
            end
        end
        default:
        begin
            estado <= VERMELHO;
            cont = 0;
        end 
    endcase
    end
end

endmodule
