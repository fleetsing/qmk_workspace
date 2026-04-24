# Charybdis Nano `fleetsing36` Pin Map

This document is the pin and wiring reference for the current local QMK workspace:

- keyboard: `bastardkb/charybdis/3x5/fleetsing36`
- controller model in firmware: Elite-C-compatible pin metadata converted to `rp2040_ce`
- current hardware intent: right trackball, left rotary encoder, left direct GPIO knob press

It is meant to answer four practical questions:

1. Which controller pin is each feature using right now?
2. What did the older dual-trackball build use?
3. Which names refer to the same pin across QMK, RP2040, BastardKB docs, and PCB silkscreen?
4. Which pins are still free, and where are they actually reachable?

It also captures the final OLED outcome for this workspace, because the board
has now been used with two materially different OLED populations:

- the original BastardKB modules that behaved like `SH1107` `64x128`
- the replacement 4-pin modules that only worked correctly as `SSD1312`
  `128x64`, with a custom SSD1312-specific rotated render path in the OLED
  driver

## Source of truth

Primary local sources:

- `qmk_firmware/keyboards/bastardkb/charybdis/3x5/fleetsing36/keyboard.json`
- `qmk_firmware/keyboards/bastardkb/charybdis/3x5/fleetsing36/config.h`
- `qmk_firmware/keyboards/bastardkb/charybdis/config.h`
- `qmk_firmware/platforms/chibios/converters/elite_c_to_rp2040_ce/_pin_defs.h`
- `qmk_firmware/platforms/chibios/boards/QMK_PM2040/configs/config.h`
- `qmk_userspace/keyboards/bastardkb/charybdis/3x5/fleetsing36/keymaps/fleetsing/rules.mk`
- `qmk_userspace/keyboards/bastardkb/charybdis/3x5/fleetsing36/keymaps/fleetsing/config.h`
- `qmk_userspace/users/fleetsing/fleetsing.c`

External cross-checks:

- BastardKB Splinktegrated pin table: <https://docs.bastardkb.com/hw/pins.html>
- BastardKB RP2040 controller compatibility notes: <https://docs.bastardkb.com/hw/rp2040-community.html>
- BastardKB Charybdis Nano sensor assembly guide: <https://docs.bastardkb.com/bg_cnano/11sensor_assembly.html>
- BastardKB EC11 adapter netlist: <https://github.com/Bastardkb/Charybdis-EC11/blob/main/adapter/adapter.net>
- BastardKB QMK fork historical 3x5 config: <https://raw.githubusercontent.com/Bastardkb/bastardkb-qmk/bkb-master/keyboards/bastardkb/charybdis/3x5/config.h>

## Notation

The same physical pin often appears under several names:

- QMK alias: `B1`, `F0`, `D2`, etc.
- RP2040 GPIO number: `GP22`, `GP16`, `GP1`, etc.
- Splinktegrated / BastardKB PCB label:
  - matrix labels such as `C1`, `R4`
  - trackball labels such as `SS`, `MO`, `SC`, `MI`
  - other labels such as `Serial` and `RGB`
- sensor or trackball PCB silk:
  - `SCLK` / `SCK`
  - `MOSI`
  - `MISO`
  - `CS` / `SS`

For this build, QMK uses the Elite-C-style aliases, then `CONVERT_TO = rp2040_ce` maps those aliases onto RP2040 GPIOs.

## Current active feature map

| Feature | QMK pin(s) | RP2040 GPIO | BastardKB / PCB label | Current status |
| --- | --- | --- | --- | --- |
| Split serial transport | `D2` | `GP1` | `Serial` | In use |
| RGB data | `D3` | `GP0` | `RGB` | In use |
| I2C SDA | `D1` | `GP2` | none documented on Splinktegrated page | In use |
| I2C SCL | `D0` | `GP3` | none documented on Splinktegrated page | In use |
| OLED bus | `D1`, `D0` | `GP2`, `GP3` | 4-pin OLED header, `SDA` / `SCL` | In use |
| Matrix row 1 used by Nano | `F7` | `GP26` | `R2` | In use |
| Matrix row 2 used by Nano | `C6` | `GP5` | `R3` | In use |
| Matrix row 3 used by Nano | `D4` | `GP4` | `R4` | In use |
| Matrix row 4 used by Nano | `B5` | `GP9` | `R5` | In use |
| Matrix col 1 used by Nano | `F5` | `GP28` | `C2` | In use |
| Matrix col 2 used by Nano | `B6` | `GP21` | `C3` | In use |
| Matrix col 3 used by Nano | `D7` | `GP6` | `C4` | In use |
| Matrix col 4 used by Nano | `E6` | `GP7` | `C5` | In use |
| Matrix col 5 used by Nano | `B4` | `GP8` | `C6` | In use |
| Right trackball chip select | `F0` | `GP16` | `SS` / `CS` | In use |
| Left encoder A | `B1` | `GP22` | former `SC` / `SCLK` / `SCK` line | In use |
| Left encoder B | `B3` | `GP20` | former `MI` / `MISO` line | In use |
| Left knob press | `B2` | `GP23` | former `MO` / `MOSI` line | In use |

## At-a-glance modding summary

If the goal is "what is the easiest place to steal a pin for the next mod?", use this order:

| Priority | Pin(s) | Why |
| --- | --- | --- |
| Best keyboard-side free nets | `F4` / `GP29` / `R1`, `F6` / `GP27` / `C1` | Already have BastardKB matrix-side naming and are unused by the Nano |
| Best controller-only free pads | `B7` / `GP12`, `D5` / `GP13`, `C7` / `GP14`, `F1` / `GP15` | Free in the current controller mapping, but likely require direct controller soldering |
| Do not steal casually | `D0`, `D1`, `D2`, `D3` | I2C, split serial, RGB |
| Do not steal casually | `F0`, `B1`, `B2`, `B3` | Right trackball CS plus the current left encoder/press wiring |
| Do not steal casually | `F5`, `B6`, `D7`, `E6`, `B4`, `F7`, `C6`, `D4`, `B5` | Active matrix nets |

## Controller-oriented view

This section follows the exact grouping and order used by `elite_c_to_rp2040_ce/_pin_defs.h`.

### Left side of controller, front view

| Physical group order | QMK | RP2040 | Current use |
| --- | --- | --- | --- |
| 1 | `D3` | `GP0` | RGB |
| 2 | `D2` | `GP1` | Split serial |
| 3 | `D1` | `GP2` | I2C SDA |
| 4 | `D0` | `GP3` | I2C SCL |
| 5 | `D4` | `GP4` | Matrix `R4` |
| 6 | `C6` | `GP5` | Matrix `R3` |
| 7 | `D7` | `GP6` | Matrix `C4` |
| 8 | `E6` | `GP7` | Matrix `C5` |
| 9 | `B4` | `GP8` | Matrix `C6` |
| 10 | `B5` | `GP9` | Matrix `R5` |

Notes:

- The two unlabeled positions between `D2` and `D1` in the converter file are ground pins, not GPIO.
- Nothing on this side is currently free in the assembled keyboard mapping.

### Right side of controller, front view

| Physical group order | QMK | RP2040 | Current use |
| --- | --- | --- | --- |
| 1 | `F4` | `GP29` | Free, matches Splinktegrated `R1` |
| 2 | `F5` | `GP28` | Matrix `C2` |
| 3 | `F6` | `GP27` | Free, matches Splinktegrated `C1` |
| 4 | `F7` | `GP26` | Matrix `R2` |
| 5 | `B1` | `GP22` | Left encoder A, former `SC` / `SCLK` |
| 6 | `B3` | `GP20` | Left encoder B, former `MI` / `MISO` |
| 7 | `B2` | `GP23` | Left knob press, former `MO` / `MOSI` |
| 8 | `B6` | `GP21` | Matrix `C3` |

Notes:

- The four omitted top positions in the converter file are `RAW`, `GND`, `RESET`, and `VCC`, not extra GPIO.
- `F4` and `F6` are the cleanest remaining mod points if you want something already represented on the BastardKB keyboard-side pinout.

### Bottom row of controller

| Physical group order | QMK | RP2040 | Current use |
| --- | --- | --- | --- |
| 1 | `B7` | `GP12` | Free |
| 2 | `D5` | `GP13` | Free |
| 3 | `C7` | `GP14` | Free |
| 4 | `F1` | `GP15` | Free |
| 5 | `F0` | `GP16` | Right trackball chip select / former local `SS` |

Notes:

- These are useful only if you can actually reach the controller pads in your build.
- `F0` is not free in the current build.

## Current bus-level interpretation

### Matrix

The current Nano matrix uses:

- rows: `F7`, `C6`, `D4`, `B5`
- cols: `F5`, `B6`, `D7`, `E6`, `B4`

Mapped through the Splinktegrated matrix labels:

| Matrix net | QMK | RP2040 | Splinktegrated label |
| --- | --- | --- | --- |
| row 0 | `F7` | `GP26` | `R2` |
| row 1 | `C6` | `GP5` | `R3` |
| row 2 | `D4` | `GP4` | `R4` |
| row 3 | `B5` | `GP9` | `R5` |
| col 0 | `F5` | `GP28` | `C2` |
| col 1 | `B6` | `GP21` | `C3` |
| col 2 | `D7` | `GP6` | `C4` |
| col 3 | `E6` | `GP7` | `C5` |
| col 4 | `B4` | `GP8` | `C6` |

Implication:

- `R1` and `C1` exist on the Splinktegrated pinout, but are not used by this Nano matrix.
- In Elite-C/QMK alias form, those two unused Splinktegrated matrix nets are `F4` and `F6`.

### SPI / trackball / encoder area

The PM2040 board defaults for Elite-C-compatible RP2040 builds are:

- `SPI_SCK_PIN = B1`
- `SPI_MISO_PIN = B3`
- `SPI_MOSI_PIN = B2`

This matches both the BastardKB trackball docs and the Splinktegrated `TRCK` pin group:

| Function | QMK | RP2040 | Splinktegrated label | Common PCB silk |
| --- | --- | --- | --- | --- |
| chip select | `F0` | `GP16` | `SS` | `CS`, sometimes `SS` |
| MOSI | `B2` | `GP23` | `MO` | `MOSI` |
| SCLK | `B1` | `GP22` | `SC` | `SCLK`, sometimes `SCK` |
| MISO | `B3` | `GP20` | `MI` | `MISO` |

Current use of those four local former-trackball lines on the left half:

- `F0` / `GP16`: unused by the left mod right now
- `B1` / `GP22`: left encoder A
- `B3` / `GP20`: left encoder B
- `B2` / `GP23`: left knob press, direct GPIO button, active low with pull-up

Current use on the right half:

- the same local `SS` / `MO` / `SC` / `MI` lines still serve the active right PMW3360 trackball

### I2C

The current userspace enables:

- OLED over I2C
- DRV2605L haptics

The PM2040 board defaults set:

- `I2C1_SDA_PIN = D1 = GP2`
- `I2C1_SCL_PIN = D0 = GP3`

So the current I2C bus is:

| Bus signal | QMK | RP2040 | Used by |
| --- | --- | --- | --- |
| SDA | `D1` | `GP2` | OLED and DRV2605L haptic |
| SCL | `D0` | `GP3` | OLED and DRV2605L haptic |

These pins are inherited from the `QMK_PM2040` board defaults, not explicitly redefined in the Charybdis keyboard files.

### OLED modules

The current working replacement OLED configuration is:

- electrical interface: I2C, 4-pin modules labeled `GND VCC SCL SDA`
- purchase listing used for this working batch:
  - <https://www.aliexpress.com/item/1005005004747839.html>
- QMK controller selection: `OLED_IC_SSD1312`
- QMK geometry: `OLED_DISPLAY_128X64`
- per-half keymap rotation:
  - left: `OLED_ROTATION_90`
  - right: `OLED_ROTATION_90`
- panel init flips:
  - `OLED_FLIP_SEGMENT` disabled
  - `OLED_FLIP_COM` disabled

The original BastardKB OLED modules in this build behaved like:

- `OLED_IC_SH1107`
- `OLED_DISPLAY_64X128`
- left rotation `OLED_ROTATION_270`
- right rotation `OLED_ROTATION_180`

Practical implication:

- if you reinstall the original BastardKB OLEDs, the current SSD1312 profile is
  not the right configuration
- if you use the newer replacement batch, the generic upstream QMK SSD1306 /
  SH1106 / SH1107 paths are not sufficient on their own
- similar-looking 4-pin OLEDs may still behave differently, so treat the
  listing above as the known-good reference batch rather than assuming all
  `SSD1312` listings are interchangeable

### Final SSD1312 firmware fix

The replacement modules did not work correctly with configuration-only changes.
They ended up needing both a different OLED controller selection and a custom
rotated render path in `qmk_firmware/drivers/oled/oled_driver.c`.

Final working behavior for `SSD1312 + OLED_ROTATION_90`:

1. Use the `SSD1312` driver family rather than `SH1107`.
2. Treat the module as `128x64`, not `64x128` or `128x128`.
3. Keep the SSD1312 90-degree target tiles in left-to-right order:
   - `ssd1312_rotation_90_target_map[] = {0, 8, 16, 24, 32, 40, 48, 56}`
4. Rotate each 8x8 tile with the opposite direction from QMK's generic 128x64
   path:
   - `rotate_270(...)` instead of `rotate_90(...)`
5. Reverse the 8 output bytes inside each rotated tile before writing them into
   the final temp buffer.

Why this matters:

- earlier states looked "close" but still had one of these remaining issues:
  - mirrored right-to-left text
  - upside-down letters
  - mangled glyphs
- the final SSD1312 path fixed those in this exact combination

Local files that now encode the working OLED path:

- `qmk_userspace/keyboards/bastardkb/charybdis/3x5/fleetsing36/keymaps/fleetsing/config.h`
- `qmk_firmware/drivers/oled/oled_driver.h`
- `qmk_firmware/drivers/oled/oled_driver.c`

If a future OLED batch regresses again, start from this known-good state rather
than re-running the whole SH1107 / SSD1306 / SH1106 search from scratch.

### UART / split transport

The custom board `keyboard.json` sets split serial on:

- `D2 = GP1`

That matches the BastardKB `Serial` pin on the Splinktegrated pin table and the PM2040 UART default `UART_RX_PIN = D2`.

In practice for this build:

- `D2` / `GP1` is a used split-transport pin
- `D3` / `GP0` is the RGB data pin

## Current mod-specific notes

### Left encoder

The working left encoder wiring is:

- A: former trackball `SCLK` / `SC` -> `B1` / `GP22`
- B: former trackball `MISO` / `MI` -> `B3` / `GP20`

The current firmware keeps that as:

- `ENCODER_A_PINS { B1 }`
- `ENCODER_B_PINS { B3 }`

### Left knob press

The current knob press is not in the matrix.

It is wired directly to the former left-trackball `MOSI` / `MO` line:

- `B2` / `GP23`

The current userspace treats it as:

- direct GPIO input
- active low
- internal pull-up enabled
- base-layer test action: `Enter`

That means future mods should assume `B2` is already claimed unless the knob press is moved again.

## Historical mod progression

This sequence is worth preserving because it explains why the current build
looks unusual in both wiring and firmware:

1. Original local build:
   - left trackball
   - right trackball
   - original BastardKB OLEDs behaving like `SH1107` `64x128`
2. First left-side hardware mod:
   - left trackball removed
   - left rotary encoder added
   - encoder confirmed working on former `SCLK` + `MISO`
   - direct knob press moved to former `MOSI`
3. OLED replacement debugging:
   - replacement 4-pin OLED batch initially looked like wrong orientation or
     wrong controller
   - `SH1107` experiments were insufficient
   - `SSD1312` support was ported into the local QMK OLED driver
   - a custom SSD1312 rotated-render branch was needed before text became fully
     correct

This matters because future modding questions may depend on which of those
three hardware generations the board is currently using.

## Legacy dual-trackball map

Before the left-side encoder mod, the former left trackball header used the same four local lines that the right trackball still uses now:

| Legacy left trackball signal | QMK | RP2040 | Splinktegrated label | Common silk |
| --- | --- | --- | --- | --- |
| CS | `F0` | `GP16` | `SS` | `CS`, `SS` |
| MOSI | `B2` | `GP23` | `MO` | `MOSI` |
| SCLK | `B1` | `GP22` | `SC` | `SCLK`, `SCK` |
| MISO | `B3` | `GP20` | `MI` | `MISO` |

The older dual-trackball build therefore consumed:

- left local `F0`, `B2`, `B1`, `B3`
- right local `F0`, `B2`, `B1`, `B3`

Each half used its own local copy of those same logical pins.

## Free pins

This section distinguishes between:

- free on the keyboard PCB / Splinktegrated nets
- free only on the controller pinout

That distinction matters because a pin can be electrically free in QMK, yet still require soldering directly to the controller rather than to an existing keyboard PCB pad.

### Free and already represented in BastardKB keyboard-side naming

These are the cleanest mod targets because they correspond to named Splinktegrated matrix nets that the Nano does not currently use:

| QMK | RP2040 | Splinktegrated label | Reachability | Notes |
| --- | --- | --- | --- | --- |
| `F4` | `GP29` | `R1` | Keyboard PCB / Splinktegrated label exists | Unused matrix row on Nano |
| `F6` | `GP27` | `C1` | Keyboard PCB / Splinktegrated label exists | Unused matrix column on Nano |

### Free in the Elite-C-compatible controller mapping, but not named in BastardKB Nano PCB docs here

These are currently unused in this build, but they are less convenient because they are not part of the documented Splinktegrated `MATRIX`, `TRCK`, `Serial`, or `RGB` groups on the BastardKB pin page:

| QMK | RP2040 | Current status | Notes |
| --- | --- | --- | --- |
| `B7` | `GP12` | Free | Controller-side pad only in this reference |
| `D5` | `GP13` | Free | Controller-side pad only in this reference |
| `C7` | `GP14` | Free | Controller-side pad only in this reference |
| `F1` | `GP15` | Free | Controller-side pad only in this reference |

### Used or reserved, not free

| QMK / GPIO | Why not free |
| --- | --- |
| `D3` / `GP0` | RGB |
| `D2` / `GP1` | Split serial |
| `D1` / `GP2` | I2C SDA |
| `D0` / `GP3` | I2C SCL |
| `D4`, `C6`, `F7`, `B5` | Matrix rows |
| `F5`, `B6`, `D7`, `E6`, `B4` | Matrix cols |
| `F0` | Right trackball CS |
| `B1`, `B3`, `B2` | Left encoder and knob press |

## Non-user pins and caveats

- `GP19` is used by the RP2040 converter layer for USB VBUS detection.
- This document does not treat `GP19` as a free mod pin.
- `GP17`, `GP18`, `GP24`, and `GP25` are not part of the Elite-C-compatible alias set exposed by `elite_c_to_rp2040_ce` in this workspace, so they are intentionally omitted from the practical modding map here.
- The direct knob-press mapping is a userspace behavior, not a board-level matrix definition.
- The I2C pin assignment comes from the `QMK_PM2040` board defaults, not from a BastardKB-specific file.

## Quick alias table

| QMK | RP2040 | BastardKB / PCB name |
| --- | --- | --- |
| `D3` | `GP0` | `RGB` |
| `D2` | `GP1` | `Serial` |
| `D1` | `GP2` | I2C SDA |
| `D0` | `GP3` | I2C SCL |
| `D4` | `GP4` | `R4` |
| `C6` | `GP5` | `R3` |
| `D7` | `GP6` | `C4` |
| `E6` | `GP7` | `C5` |
| `B4` | `GP8` | `C6` |
| `B5` | `GP9` | `R5` |
| `B7` | `GP12` | controller-only in this reference |
| `D5` | `GP13` | controller-only in this reference |
| `C7` | `GP14` | controller-only in this reference |
| `F1` | `GP15` | controller-only in this reference |
| `F0` | `GP16` | `SS`, `CS` |
| `B3` | `GP20` | `MI`, `MISO` |
| `B6` | `GP21` | `C3` |
| `B1` | `GP22` | `SC`, `SCLK`, `SCK` |
| `B2` | `GP23` | `MO`, `MOSI` |
| `F7` | `GP26` | `R2` |
| `F6` | `GP27` | `C1` |
| `F5` | `GP28` | `C2` |
| `F4` | `GP29` | `R1` |

## Confidence notes

High confidence:

- matrix rows and columns
- split serial
- RGB
- SPI signal mapping
- current encoder and knob-press pins
- free `F4` / `F6` as unused Splinktegrated row/column nets

Medium confidence:

- the exact convenience and physical accessibility of `B7`, `D5`, `C7`, `F1` inside the assembled keyboard, since that depends on how much direct access you have to the controller pads in your specific build

If this document is extended later, the most useful additions would be:

- a photo or annotated diagram of the actual pads on your assembled board
- confirmation of which controller-only free pins are realistically solderable in your case
- any future mods that consume `F4`, `F6`, `B7`, `D5`, `C7`, or `F1`
