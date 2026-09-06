<!---

This file is used to generate your project datasheet. Please fill in the information below and delete any unused
sections.

You can also include images in this folder and reference them in the markdown. Each image must be less than
512 kb in size, and the combined size of all images must be less than 1 MB.
-->

## How it works
Popcount thermometer-to-binary decoders for two MIDNA AFE channels plus a
coincidence flag (both codes >= 2 in the same qualified sample).

## How to test
Drive ui[2:0]/ui[5:3] with thermometer codes, pulse ui[6]; read codes on
uo[1:0]/uo[3:2], valids uo[4]/uo[5], coincidence uo[6], heartbeat uo[7].

## External hardware
Two MIDNA AFE devkit boards (thermometer outputs) or any GPIO source.

| # | Input          | Output       | Bidirectional |
|---|----------------|--------------|---------------|
| 0 | thermo A QPL   | code A bit0  |               |
| 1 | thermo A QPM   | code A bit1  |               |
| 2 | thermo A QPH   | code B bit0  |               |
| 3 | thermo B QPL   | code B bit1  |               |
| 4 | thermo B QPM   | valid A      |               |
| 5 | thermo B QPH   | valid B      |               |
| 6 | conv_echo      | coincidence  |               |
| 7 |                | heartbeat    |               |
EOF
