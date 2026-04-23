# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.0] - 2026-04-23

### Added

- `vrun sim` — compile and simulate Verilog files with Icarus Verilog
- `vrun wave` — open VCD waveforms in Surfer
- `vrun synth` — synthesize design files with Yosys
- `vrun clean` — remove build artifacts
- `vrun all` — run full sim → wave → synth pipeline
- `vrun doctor` — verify all dependencies are installed
- `.vrun` project config file support
- Environment variable overrides
- Automatic testbench detection (`tb_` prefix / `_tb` suffix)
