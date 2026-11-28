library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity manchester_top is
  generic (CYCLES_PER_BIT : positive := 100_000_000);
  port (
    clk, btnC : in std_logic;
    sw : in std_logic_vector(15 downto 0);
    led : out std_logic_vector(15 downto 0);
    pmod_encoded, pmod_data : out std_logic;
    vgaRed, vgaGreen, vgaBlue : out std_logic_vector(3 downto 0);
    Hsync, Vsync : out std_logic
  );
end entity;

architecture rtl of manchester_top is
  signal rst : std_logic;
  signal sw_sync : std_logic_vector(15 downto 0);
  signal encoded, data_bit : std_logic;
  signal bit_index : unsigned(3 downto 0);
  signal half_bit, active : std_logic;
begin
  u_inputs : entity work.input_conditioner
    port map(clk => clk, btnC => btnC, sw => sw, rst => rst, sw_sync => sw_sync);
  u_encoder : entity work.line_encoder
    generic map(CYCLES_PER_BIT => CYCLES_PER_BIT, DIFFERENTIAL => false)
    port map(clk => clk, rst => rst, sw => sw_sync, led => led,
      encoded_out => encoded, data_out => data_bit, bit_index => bit_index,
      half_bit => half_bit, active => active);
  pmod_encoded <= encoded;
  pmod_data <= data_bit;
  u_vga : entity work.vga_colors
    port map(clk => clk, encoded => encoded, vgaRed => vgaRed,
      vgaGreen => vgaGreen, vgaBlue => vgaBlue, Hsync => Hsync, Vsync => Vsync);
end architecture;
