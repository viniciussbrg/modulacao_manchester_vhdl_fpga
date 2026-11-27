library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity manchester is
    generic (
        CYCLES_PER_BIT : integer := 100_000_000
    );
    port (
        clk      : in  std_logic;
        rst      : in  std_logic;
        data_in  : in  std_logic_vector(15 downto 0);
        data_out : out std_logic;
        data_nrz : out std_logic;
        led      : out std_logic_vector(15 downto 0)
    );
end manchester;
architecture rtl of manchester is
    constant HALF_BIT : integer := CYCLES_PER_BIT / 2;
    signal rst_meta  : std_logic := '1';
    signal rst_sync  : std_logic := '1';
    signal cnt       : integer range 0 to CYCLES_PER_BIT - 1 := 0;
    signal idx       : integer range 0 to 15 := 15;
    signal pos       : integer range 0 to 15 := 15;
    signal bit_atual : std_logic := '0';
    signal metade    : std_logic := '1';
    signal codigo    : std_logic;
    signal out_reg   : std_logic := '0';
    signal nrz_reg   : std_logic := '0';
    signal led_reg   : std_logic_vector(15 downto 0) := (others => '0');
begin
    process(clk)
    begin
        if rising_edge(clk) then
            rst_meta <= rst;
            rst_sync <= rst_meta;
        end if;
    end process;
    process(clk)
    begin
        if rising_edge(clk) then
         if rst_sync = '1' then
                cnt       <= 0;
                idx       <= 15;
                pos       <= 15;
                bit_atual <= '0';
                metade    <= '1';
            else
                if cnt = 0 then
                    pos       <= idx;
                    bit_atual <= data_in(idx);
                    metade    <= '0';
                elsif cnt = HALF_BIT then
                    metade    <= '1';
                end if;
                if cnt = CYCLES_PER_BIT - 1 then
                    cnt <= 0;
                    if idx = 0 then
                        idx <= 15;
                    else
                        idx <= idx - 1;
                    end if;
                else
                    cnt <= cnt + 1;
                end if;
            end if;
        end if;
    end process;
    codigo <= bit_atual xnor metade;
    process(clk)
        variable v : std_logic_vector(15 downto 0);
    begin
        if rising_edge(clk) then
            if rst_sync = '1' then
                out_reg <= '0';
                nrz_reg <= '0';
                led_reg <= (others => '0');
            else
                v      := (others => '0');
                v(pos) := codigo;
                out_reg <= codigo;
                nrz_reg <= bit_atual;
                led_reg <= v;
            end if;
        end if;
    end process;
    data_out <= out_reg;
    data_nrz <= nrz_reg;
    led      <= led_reg;
end rtl;