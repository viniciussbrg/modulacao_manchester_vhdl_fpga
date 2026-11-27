library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity manchester_dif_pmod is
    port (
        clk      : in  std_logic;
        rst      : in  std_logic;
        data_in  : in  std_logic_vector(15 downto 0);
        led      : out std_logic_vector(15 downto 0);
        pmod_cod : out std_logic;
        pmod_nrz : out std_logic
);
end manchester_dif_pmod;
architecture rtl of manchester_dif_pmod is
begin
u_cod : entity work.manchester_dif
generic map (
CYCLES_PER_BIT => 20_000
)
port map (
    clk => clk,
    rst => rst,
    data_in  => data_in,
    data_out => pmod_cod,
    data_nrz => pmod_nrz,
    led      => led
);
end rtl;