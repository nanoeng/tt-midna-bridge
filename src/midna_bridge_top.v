// =============================================================
// tt_um_midna_bridge -- 1x1 TT digital tile
// Thermometer->binary bridge + coincidence for the 3-PCB plan.
//   ui_in[2:0] = thermo A {QPL,QPM,QPH}   ui_in[5:3] = thermo B
//   ui_in[6]   = conv_echo (sample qualifier)
//   uo_out[1:0]=codeA [3:2]=codeB [4]=vldA [5]=vldB
//   uo_out[6]  = coincidence (both codes >= 2)
//   uo_out[7]  = heartbeat
// =============================================================
`default_nettype none
module tt_um_midna_bridge (
    input  wire [7:0] ui_in,
    output wire [7:0] uo_out,
    input  wire [7:0] uio_in,
    output wire [7:0] uio_out,
    output wire [7:0] uio_oe,
    input  wire       ena,
    input  wire       clk,
    input  wire       rst_n
);
    function [1:0] th2bin(input [2:0] t);
        th2bin = {1'b0,t[0]} + {1'b0,t[1]} + {1'b0,t[2]};
    endfunction

    reg [1:0] codeA_q, codeB_q;
    reg       vldA_q, vldB_q, coin_q;
    reg [23:0] hb;

    always @(posedge clk) begin
        if (!rst_n) begin
            codeA_q <= 2'd0; codeB_q <= 2'd0;
            vldA_q  <= 1'b0; vldB_q  <= 1'b0;
            coin_q  <= 1'b0; hb      <= 24'd0;
        end else if (ena) begin
            hb <= hb + 24'd1;
            if (ui_in[6]) begin
                codeA_q <= th2bin(ui_in[2:0]);
                codeB_q <= th2bin(ui_in[5:3]);
                vldA_q  <= |ui_in[2:0];
                vldB_q  <= |ui_in[5:3];
                coin_q  <= (th2bin(ui_in[2:0]) >= 2'd2) &&
                           (th2bin(ui_in[5:3]) >= 2'd2);
            end else begin
                vldA_q <= 1'b0; vldB_q <= 1'b0; coin_q <= 1'b0;
            end
        end
    end

    assign uo_out  = {hb[23], coin_q, vldB_q, vldA_q, codeB_q, codeA_q};
    assign uio_out = 8'h00;
    assign uio_oe  = 8'h00;
    wire _unused = &{uio_in, ui_in[7], 1'b0};
endmodule
`default_nettype wire
