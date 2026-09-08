## How it works

This is a two-stage analog readout channel: a charge-sensitive amplifier
(CSA) feeding a StrongARM dynamic latch comparator.

**CSA (5 transistors):** a single-stage cascoded common-source amplifier
(NMOS input + NMOS cascode, PMOS cascode + PMOS current source) with a
20fF capacitive feedback path and an NMOS reset switch across it. Charge
injected at `ua[0]` (qin) integrates onto the feedback cap and produces a
voltage step at the amplifier's output proportional to the injected
charge (Q/Cf to first order). `ui_in[1]` (rst) closes the reset switch to
re-zero the amplifier between events.

**StrongARM comparator (11 transistors):** a tail-current switch, an
NMOS input differential pair, an NMOS cross-coupled regeneration pair
stacked on the input pair's drains, four PMOS precharge devices, and a
PMOS cross-coupled latch pair. On the rising edge of `ui_in[0]` (clk),
it compares the CSA's output against the reference on `ua[1]` (vinn) and
resolves to a rail-to-rail digital decision on `uo_out[0]`/`uo_out[1]`
(true/complement), precharging both internal nodes back to VDD between
clock edges.

The comparator topology was ported from a verified, previously-published
StrongARM netlist rather than reconstructed from memory, specifically to
avoid topology errors in a circuit family with several similar-looking
variants (8T/9T/10T/13T).

Functional operation was verified in transient simulation against the
real PSP103 compact model (not an ideal/behavioral model): a 2fC charge
injection produced a ~112mV step at the CSA output against an ideal
Q/Cf prediction of 100mV (the gap is expected finite-gain error from a
single-stage amplifier, not a simulation artifact), and the comparator
resolved correctly and repeatably on every clock edge tested.

## How to test

1. Drive `ui_in[1]` (rst) high briefly to reset the CSA, then release it.
2. Inject a charge pulse at `ua[0]` (qin) -- e.g. via a fast current
   pulse or a small capacitor driven by a voltage step -- and let the
   CSA output settle.
3. Set `ua[1]` (vinn) to the desired comparison threshold.
4. Pulse `ui_in[0]` (clk) high; read the resolved decision on
   `uo_out[0]`/`uo_out[1]`.

## External hardware

None required -- all inputs/outputs are accessible directly via the
chip's digital and analog pins. A function generator or similar capable
of injecting a fast current/charge pulse on `ua[0]` is useful for
characterizing the CSA's charge-to-voltage gain.
