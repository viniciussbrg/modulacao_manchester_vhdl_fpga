#!/usr/bin/env bash
set -euo pipefail
project_dir="$(cd "$(dirname "$0")/.." && pwd)"
work_dir="$project_dir/sim/ghdl_work"
mkdir -p "$work_dir"
cd "$work_dir"
ghdl -a --std=08 "$project_dir/src/input_conditioner.vhd" "$project_dir/src/line_encoder.vhd" "$project_dir/saidas/vga/src/vga_colors.vhd" "$project_dir/src/manchester_top.vhd" "$project_dir/sim/"*.vhd
for cycles in 2 4 10 100; do
  ghdl -r --std=08 manchester_tb -gCYCLES_PER_BIT="$cycles" --assert-level=error
done
ghdl -r --std=08 top_tb --assert-level=error
ghdl -r --std=08 vga_tb --assert-level=error
