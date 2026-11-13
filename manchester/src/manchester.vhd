library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity manchester is
    generic (
        CYCLES_PER_BIT : positive := 100_000_000  -- deve ser par; 1 s por bit
    );
    port (
        clk      : in  std_logic;
        rst      : in  std_logic;
        data_in  : in  std_logic_vector(15 downto 0);
        data_out : out std_logic;
        data_raw : out std_logic;
        led      : out std_logic_vector(15 downto 0)
    );
end manchester;

architecture rtl of manchester is
    constant HALF : positive := CYCLES_PER_BIT / 2;

    signal rst_meta, rst_s : std_logic := '1';
    signal cnt     : integer range 0 to CYCLES_PER_BIT - 1 := CYCLES_PER_BIT - 1;
    signal idx     : unsigned(3 downto 0) := (others => '0');
    signal nxt_idx : unsigned(3 downto 0);
    signal cur_bit : std_logic := '0';
    signal enc     : std_logic := '0';
begin
    assert CYCLES_PER_BIT mod 2 = 0
        report "CYCLES_PER_BIT deve ser par" severity failure;

    nxt_idx <= idx - 1;  -- 0 - 1 = 15

    sync_rst : process(clk)
    begin
        if rising_edge(clk) then
            rst_meta <= rst;
            rst_s    <= rst_meta;
        end if;
    end process;

    main : process(clk)
    begin
        if rising_edge(clk) then
            if rst_s = '1' then
                cnt     <= CYCLES_PER_BIT - 1;
                idx     <= (others => '0');
                cur_bit <= '0';
                enc     <= '0';
            else
                if cnt = CYCLES_PER_BIT - 1 then
                    cnt     <= 0;
                    idx     <= nxt_idx;
                    cur_bit <= data_in(to_integer(nxt_idx));
                    enc     <= not data_in(to_integer(nxt_idx));
                else
                    cnt <= cnt + 1;
                    if cnt = HALF - 1 then
                        enc <= cur_bit;
                    end if;
                end if;
            end if;
        end if;
    end process;

    data_out <= enc;
    data_raw <= cur_bit;

    led_out : process(idx, enc)
    begin
        led <= (others => '0');
        led(to_integer(idx)) <= enc;
    end process;
end rtl;