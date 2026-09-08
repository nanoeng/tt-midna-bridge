/*
 * Copyright (c) 2026 nanoeng
 * SPDX-License-Identifier: Apache-2.0
 *
 * MIDNA-CRYO CSA + StrongARM comparator with on-chip bias generator --
 * analog block, sky130A. The actual circuit lives in the submitted GDS
 * (25 transistors: 5-device charge-sensitive amplifier, 11-device
 * StrongARM dynamic latch comparator, 9-device current-mirror bias
 * generator); this file is the blackbox interface stub used by TT's
 * build tooling, not a behavioral model.
 *
 * ui_in[0]  -> StrongARM comparator clock (routed to the analog block)
 * ui_in[1]  -> CSA reset (closes the feedback switch when high)
 * uo_out[0] <- comparator output, true      (vx)
 * uo_out[1] <- comparator output, complement (vy)
 * ua[0]     -- charge-sensitive amplifier input (qin)
 * ua[1]     -- comparator reference / threshold input (vinn)
 *
 * All bias voltages (bias_p, bias_pcasc, bias_ncasc) are generated
 * on-chip and require no external pins -- earlier design iterations
 * used external bias inputs; the current design does not.
 *
 * All other digital I/O is unused and tied off per the analog design
 * rules (no floating uo_out/uio_out/uio_oe pins).
 */

`default_nettype none

module tt_um_nanoeng_midna_bridge (
    input  wire       VGND,
    input  wire       VDPWR,    // 1.8v power supply
//    input  wire       VAPWR,    // 3.3v power supply
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    inout  wire [7:0] ua,       // Analog pins, only ua[5:0] can be used
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // top-level clock -- unused, the comparator's own
                                 // clock is ui_in[0], routed directly into the analog block
    input  wire       rst_n     // top-level reset_n -- unused, see ui_in[1] above
);

    // uo_out[0]/[1] (vx/vy) are the comparator's real outputs, physically
    // driven by the analog silicon -- this stub value is a simulation-only
    // placeholder (0) so nothing is left undriven in digital lint/sim;
    // it does not represent actual comparator behavior.
    // uo_out[7:2] are unused and tied to GND per the "no floating digital
    // output pins" rule.
    assign uo_out = 8'b0;

    // No bidirectional I/O used in this design.
    assign uio_out = 8'b0;
    assign uio_oe  = 8'b0;

    // Silence unused-signal lint without affecting the analog block.
    wire _unused = &{ena, clk, rst_n, uio_in, 1'b0};

endmodule
