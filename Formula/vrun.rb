class Vrun < Formula
  desc "Verilog workflow helper — compile, simulate, view waveforms, synthesize"
  homepage "https://github.com/enzomarioaiello/homebrew-vrun"
  url "https://github.com/enzomarioaiello/homebrew-vrun/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "29ae5b53b2e624c0c878e3690fe5ca4818ae0f3128e2aaf89f8f0b3397bbddaa"
  license "MIT"
  version "0.1.0"

  # Runtime dependencies — all available in core Homebrew
  depends_on "bash"           # ensures bash 5.x, not macOS's 3.2
  depends_on "icarus-verilog" # iverilog + vvp
  depends_on "yosys"          # synthesis
  depends_on "verible"        # LSP + formatter for Neovim
  depends_on "surfer"         # waveform viewer

  def install
    bin.install "vrun"
  end

  def caveats
    <<~EOS
      vrun is now installed. Quick start:

        vrun sim        compile + simulate all .v files in cwd
        vrun wave       open wave.vcd in Surfer
        vrun synth      synthesize with Yosys
        vrun clean      remove build artefacts
        vrun all        run the full workflow in one shot

      For Neovim LSP support, add to your lspconfig:
        require('lspconfig').verible.setup{
          filetypes = { "verilog", "systemverilog" },
          cmd = { "verible-verilog-ls" },
        }
    EOS
  end

  test do
    # Write a minimal counter design
    (testpath/"counter.v").write <<~VERILOG
      module counter(input clk, output reg [3:0] count);
        always @(posedge clk) count <= count + 1;
      endmodule
    VERILOG

    # Write a minimal testbench
    (testpath/"tb_counter.v").write <<~VERILOG
      `timescale 1ns/1ps
      module tb_counter;
        reg clk; wire [3:0] count;
        counter dut(.clk(clk), .count(count));
        initial clk = 0;
        always #5 clk = ~clk;
        initial begin
          $dumpfile("wave.vcd");
          $dumpvars(0, tb_counter);
          #50 $finish;
        end
      endmodule
    VERILOG

    # vrun sim should compile and simulate without error
    system "#{bin}/vrun", "sim", "counter.v", "tb_counter.v"

    # VCD file should be produced
    assert_predicate testpath/"wave.vcd", :exist?
  end
end
