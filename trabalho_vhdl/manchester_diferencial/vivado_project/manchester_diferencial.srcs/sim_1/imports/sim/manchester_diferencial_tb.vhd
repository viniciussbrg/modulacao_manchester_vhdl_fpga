library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.env.all;

entity manchester_diferencial_tb is
  generic (CYCLES_PER_BIT : positive := 10);
end entity;
architecture test of manchester_diferencial_tb is
  constant CLK_PERIOD : time := 10 ns;
  constant BIT_PERIOD : time := CYCLES_PER_BIT * CLK_PERIOD;
  constant DIFFERENTIAL : boolean := true;
  signal clk : std_logic := '0';
  signal rst : std_logic := '1';
  signal sw, led : std_logic_vector(15 downto 0) := (others => '0');
  signal encoded, data_bit, half_bit, active : std_logic;
  signal bit_index : unsigned(3 downto 0);
begin
  clk <= not clk after CLK_PERIOD/2;
  dut : entity work.line_encoder
    generic map(CYCLES_PER_BIT => CYCLES_PER_BIT, DIFFERENTIAL => DIFFERENTIAL)
    port map(clk => clk, rst => rst, sw => sw, led => led,
      encoded_out => encoded, data_out => data_bit,
      bit_index => bit_index, half_bit => half_bit, active => active);

  stimulus : process
    procedure check_reset is
    begin
      assert encoded = '0' and data_bit = '0' and led = x"0000"
        and bit_index = 15 and active = '0' and half_bit = '0'
        report "Reset nao limpou as saidas/indice" severity failure;
    end procedure;
    procedure hold_reset is
    begin
      rst <= '1';
      wait for 1 ns;
      check_reset;
      for n in 1 to 4 loop
        wait until rising_edge(clk); wait for 1 ns; check_reset;
      end loop;
    end procedure;
    procedure check_word(constant pattern : std_logic_vector(15 downto 0);
                         constant mutate : boolean := false) is
      variable live_word : std_logic_vector(15 downto 0);
      variable first_level, expected, sampled, previous_end : std_logic;
      variable expected_led : std_logic_vector(15 downto 0);
      variable index_ref : natural;
    begin
      sw <= pattern;
      hold_reset;
      live_word := pattern;
      previous_end := '0';
      wait until falling_edge(clk);
      rst <= '0';
      -- Tres quadros completos: cobre duas voltas SW0 -> SW15.
      for bit_no in 0 to 47 loop
        index_ref := 15-(bit_no mod 16);
        sampled := live_word(index_ref);
        if DIFFERENTIAL then
          first_level := previous_end xor (not sampled);
        else
          first_level := not sampled;
        end if;
        for phase in 0 to CYCLES_PER_BIT-1 loop
          wait until rising_edge(clk);
          wait for 1 ns;
          if phase < CYCLES_PER_BIT/2 then expected := first_level;
          else expected := not first_level; end if;
          expected_led := (others => '0');
          expected_led(index_ref) := expected;
          assert encoded = expected report "Nivel codificado incorreto" severity failure;
          assert data_bit = sampled report "Bit capturado mudou durante intervalo" severity failure;
          assert to_integer(bit_index) = index_ref report "Ordem dos switches incorreta" severity failure;
          assert led = expected_led report "LED incorreto ou LED extra aceso" severity failure;
          assert active = '1' report "Transmissao inativa" severity failure;
          if phase < CYCLES_PER_BIT/2 then
            assert half_bit = '0' severity failure;
          else
            assert half_bit = '1' severity failure;
          end if;
          -- Alterar o vetor APOS a captura: o bit atual deve permanecer.
          -- SW15 alterado so deve reaparecer no quadro seguinte.
          if mutate and bit_no = 0 and phase = 0 then
            live_word := not pattern;
            sw <= live_word;
          end if;
          wait until falling_edge(clk);
        end loop;
        previous_end := not first_level;
      end loop;
    end procedure;
  begin
    assert CYCLES_PER_BIT >= 2 and CYCLES_PER_BIT mod 2 = 0 severity failure;
    assert BIT_PERIOD = CYCLES_PER_BIT*CLK_PERIOD severity failure;
    check_word(x"0000");
    check_word(x"FFFF");
    check_word(x"AAAA");
    check_word(x"5555");
    check_word(x"B2C9");
    check_word(x"8001", true);
    -- Reset interrompendo cada fase possivel de um bit.
    for offset in 0 to CYCLES_PER_BIT-1 loop
      sw <= x"B2C9";
      hold_reset;
      wait until falling_edge(clk); rst <= '0';
      for n in 0 to offset loop wait until rising_edge(clk); end loop;
      wait for 2 ns;
      hold_reset;
      wait until falling_edge(clk); rst <= '0';
      wait until rising_edge(clk); wait for 1 ns;
      assert bit_index = 15 and data_bit = '1' and encoded = '0' and half_bit = '0'
        report "Reinicio incorreto depois do reset" severity failure;
    end loop;
    report "PASS: manchester_diferencial_tb; CYCLES_PER_BIT=" & integer'image(CYCLES_PER_BIT) severity note;
    finish;
    wait;
  end process;
end architecture;
