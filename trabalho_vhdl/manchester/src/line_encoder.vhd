library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Um unico dominio de clock. Todas as saidas de transmissao sao registradas.
entity line_encoder is
  generic (
    CYCLES_PER_BIT : positive := 100_000_000;
    DIFFERENTIAL  : boolean := false
  );
  port (
    clk, rst : in std_logic;
    sw : in std_logic_vector(15 downto 0);
    led : out std_logic_vector(15 downto 0);
    encoded_out, data_out : out std_logic;
    bit_index : out unsigned(3 downto 0);
    half_bit, active : out std_logic
  );
end entity;

architecture rtl of line_encoder is
  signal count : natural range 0 to CYCLES_PER_BIT-1 := 0;
  signal idx : natural range 0 to 15 := 15;
  signal running, level, bit_latched, half_reg : std_logic := '0';
  signal leds_reg : std_logic_vector(15 downto 0) := (others => '0');
begin
  assert CYCLES_PER_BIT >= 2 and CYCLES_PER_BIT mod 2 = 0
    report "CYCLES_PER_BIT deve ser par e >= 2" severity failure;
  encoded_out <= level;
  data_out <= bit_latched;
  led <= leds_reg;
  bit_index <= to_unsigned(idx, 4);
  half_bit <= half_reg;
  active <= running;

  process(clk, rst)
    variable next_idx : natural range 0 to 15;
    variable next_level : std_logic;
    variable next_leds : std_logic_vector(15 downto 0);
  begin
    if rst = '1' then
      count <= 0;
      idx <= 15;
      running <= '0';
      level <= '0';
      bit_latched <= '0';
      half_reg <= '0';
      leds_reg <= (others => '0');
    elsif rising_edge(clk) then
      if running = '0' or count = CYCLES_PER_BIT-1 then
        -- Primeiro bit apos reset ou inicio do proximo intervalo.
        if running = '0' or idx = 0 then
          next_idx := 15;
        else
          next_idx := idx-1;
        end if;
        if DIFFERENTIAL then
          next_level := level;
          if sw(next_idx) = '0' then
            next_level := not level;
          end if;
        else
          -- IEEE 802.3: 0 = alto/baixo; 1 = baixo/alto.
          next_level := not sw(next_idx);
        end if;
        bit_latched <= sw(next_idx);
        idx <= next_idx;
        count <= 0;
        half_reg <= '0';
        running <= '1';
        level <= next_level;
        next_leds := (others => '0');
        next_leds(next_idx) := next_level;
        leds_reg <= next_leds;
      else
        count <= count+1;
        if count = CYCLES_PER_BIT/2-1 then
          half_reg <= '1';
          level <= not level;
          next_leds := (others => '0');
          next_leds(idx) := not level;
          leds_reg <= next_leds;
        end if;
      end if;
    end if;
  end process;
end architecture;
