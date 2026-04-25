<p align="center">
     <img src=".github/logo.png" width="150" alt="vrun-logo">
</p>

<h1 align="center">vrun</h1>

<p align="center">
A single CLI for compiling, simulating, and synthesizing Verilog on macOS.
</p>

<p align="center">
  <a href="https://github.com/enzomarioaiello/homebrew-vrun/releases"><img src="https://img.shields.io/github/v/release/enzomarioaiello/homebrew-vrun?style=flat-square" alt="Release"></a>
  <a href="LICENSE"><img src="https://img.shields.io/github/license/enzomarioaiello/homebrew-vrun?style=flat-square" alt="License"></a>
  <img src="https://img.shields.io/badge/platform-macOS-lightgrey?style=flat-square" alt="Platform">
  <img src="https://img.shields.io/badge/arch-Apple%20Silicon%20%7C%20Intel-blue?style=flat-square" alt="Architecture">
</p>

---

Vrun wraps [Icarus Verilog](https://github.com/steveicarus/iverilog), [Surfer](https://surfer-project.org/), and [Yosys](https://yosyshq.net/yosys/) into a single and simplified tool.
## Requirements

| Requirement | Minimum |
|---|---|
| macOS | 13 Ventura or later |
| Architecture | Apple Silicon (M1+) or Intel x86_64 |
| Homebrew | 4.0+ |

> vrun is macOS-only. Linux and Windows are not currently supported.

## Install

```bash
brew tap enzomarioaiello/vrun
brew install vrun
```

Verify everything is set up:

```bash
vrun doctor
```

### What gets installed

| Dependency | Purpose |
|---|---|
| `bash` | Ensures Bash 5.x (macOS ships 3.2) |
| `icarus-verilog` | Compiler (`iverilog`) and simulator runtime (`vvp`) |
| `yosys` | Synthesis — converts Verilog to a gate-level netlist |
| `verible` | Language server for editors (lint, format, autocomplete) |
| `surfer` | Waveform viewer — opens `.vcd` files |

## Quick start

```bash
vrun new counter          # generate counter.v + tb_counter.v
vrun sim                  # compile + simulate
vrun wave                 # open waveforms in Surfer
```

## Usage

```bash
vrun sim                  # compile + simulate all .v files in cwd
vrun sim top.v tb_top.v   # compile specific files
vrun wave                 # open wave.vcd in Surfer
vrun wave dump.vcd        # open a specific .vcd file
vrun synth                # synthesize (testbenches auto-excluded)
vrun synth top.v          # synthesize a specific file
vrun new counter          # generate counter.v + tb_counter.v
vrun new alu --no-tb      # generate only alu.v
vrun new fifo --tb-only   # generate only tb_fifo.v
vrun clean                # remove sim_out, wave.vcd, synth_out.v
vrun all                  # run sim -> wave -> synth in one shot
vrun doctor               # check all dependencies are installed
vrun help                 # show all commands
```

## Workflow

```
    vrun new counter  ->  scaffolds counter.v + tb_counter.v
         |
Write .v files in your editor (Verible LSP)
         |
    vrun sim          ->  compiles + runs simulation
         |                  produces wave.vcd
    vrun wave         ->  opens waveform in Surfer
         |
    vrun synth        ->  synthesizes to synth_out.v
```

## Testbench conventions

vrun automatically separates design files from testbenches.
Name your testbench files with a `tb_` prefix or `_tb` suffix:

```
tb_counter.v    -> treated as testbench
counter_tb.v    -> treated as testbench
counter.v       -> treated as design (included in synthesis)
```

## RTL generation

Scaffold new modules and testbenches with `vrun new`:

```bash
vrun new counter            # creates counter.v and tb_counter.v
vrun new alu --no-tb        # module only, no testbench
vrun new fifo --tb-only     # testbench only (for an existing module)
```

Generated modules include a clock and active-low reset. Testbenches come pre-wired with `$dumpfile`/`$dumpvars` so `vrun sim` and `vrun wave` work immediately.

## Project config (`.vrun`)

Drop a `.vrun` file in your project root to configure output paths and defaults.
vrun walks up from the current directory to find it.

```bash
# .vrun
SIM_OUT=build/sim_out
VCD=build/wave.vcd
SYNTH_OUT=build/synth_out.v
TOP_MODULE=counter
```

| Key | Default | Purpose |
|---|---|---|
| `SIM_OUT` | `sim_out` | Simulation binary path |
| `VCD` | `wave.vcd` | VCD waveform path |
| `SYNTH_OUT` | `synth_out.v` | Synthesis output path |
| `TOP_MODULE` | *(auto)* | Top module passed to `yosys synth -top` |

Precedence: **environment variable > `.vrun` file > built-in default**.

## Environment overrides

```bash
VRUN_SIM_OUT=build/sim_out vrun sim
VRUN_VCD=dump.vcd          vrun wave
VRUN_SYNTH_OUT=out.v       vrun synth
VRUN_TOP_MODULE=counter    vrun synth
```

## Editor setup

### Neovim (LSP)

After installing, add Verible to your `lspconfig`:

```lua
require('lspconfig').verible.setup{
  filetypes = { "verilog", "systemverilog" },
  cmd = { "verible-verilog-ls" },
}
```

### VS Code

Install the [Verible extension](https://marketplace.visualstudio.com/items?itemName=CHIPSAlliance.verible) from the marketplace.

## Uninstall

```bash
brew uninstall vrun
brew untap enzomarioaiello/vrun
```

## License

[MIT](LICENSE)
