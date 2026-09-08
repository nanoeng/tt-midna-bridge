## How it works

This is a three-block analog readout channel on sky130A: a
charge-sensitive amplifier (CSA) feeding a StrongARM dynamic latch
comparator, with an on-chip current-mirror bias generator supplying
all internal reference voltages. 25 transistors total.

**CSA (5 transistors):** a single-stage cascoded common-source amplifier
(NMOS input + NMOS cascode, PMOS cascode + PMOS current source) with an
NMOS reset switch across the feedback path. Charge injected at `ua[0]`
(qin) integrates onto the feedback capacitance and produces a voltage
step at the amplifier's output proportional to the injected charge.
`ui_in[1]` (rst) closes the reset switch to re-zero the amplifier
between events.

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

**Bias generator (9 transistors):** an on-chip current-mirror reference
stack generates `bias_p`, `bias_pcasc`, and `bias_ncasc` for the CSA's
PMOS load/cascode and NMOS cascode devices, using a long-channel
diode-connected NMOS to set a compact ~1.5uA reference current (a
physical resistor at this value would need an impractically long trace
at this PDK's sheet resistance). No external bias pins are required.

Functional operation was verified in transient simulation against
real sky130A BSIM models (not an ideal/behavioral model), with all
three blocks connected together as one circuit: the bias generator
holds its operating point (`bias_p`~0.75-0.78V, `bias_pcasc`~0.14V,
`bias_ncasc`~0.57V) under real circuit loading, and the comparator
resolves cleanly to rail-to-rail values following a charge injection
and clock edge.

## How to test

1. Drive `ui_in[1]` (rst) high briefly to reset the CSA, then release it.
2. Inject a charge pulse at `ua[0]` (qin) -- e.g. via a fast current
   pulse or a small capacitor driven by a voltage step -- and let the
   CSA output settle.
3. Set `ua[1]` (vinn) to the desired comparison threshold.
4. Pulse `ui_in[0]` (clk) high; read the resolved decision on
   `uo_out[0]`/`uo_out[1]`.

No external bias voltages are needed -- all internal references are
generated on-chip.

## External hardware

None required -- all inputs/outputs are accessible directly via the
chip's digital and analog pins. A function generator or similar capable
of injecting a fast current/charge pulse on `ua[0]` is useful for
characterizing the CSA's charge-to-voltage gain.
