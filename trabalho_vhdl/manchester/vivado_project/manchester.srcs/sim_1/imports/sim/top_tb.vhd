library ieee;
use ieee.std_logic_1164.all;
use std.env.all;
entity top_tb is end entity;
architecture test of top_tb is
  constant CPB : positive := 10;
  constant DIFFERENTIAL : boolean := false;
  signal clk : std_logic := '0';
  signal btn : std_logic := '1';
  signal sw : std_logic_vector(15 downto 0) := x"B2C9";
  signal led : std_logic_vector(15 downto 0);
  signal code,data_bit,hs,vs : std_logic;
  signal r,g,b : std_logic_vector(3 downto 0);
begin
  clk <= not clk after 5 ns;
  dut : entity work.manchester_top
    generic map(CYCLES_PER_BIT => CPB)
    port map(clk,btn,sw,led,code,data_bit,r,g,b,hs,vs);
  process
    variable first_level,previous_end,expected,sampled : std_logic;
    variable expected_led : std_logic_vector(15 downto 0);
    variable word_ref : std_logic_vector(15 downto 0);
    variable index_ref : natural;
    procedure step is
    begin wait until rising_edge(clk); wait for 1 ns; end procedure;
  begin
    for scenario in 0 to 1 loop
      btn <= '1'; sw <= x"B2C9";
      for n in 1 to 6 loop
        step;
        assert code = '0' and data_bit = '0' and led = x"0000" severity failure;
      end loop;
      wait until falling_edge(clk); btn <= '0';
      for n in 1 to 2 loop
        step;
        assert code = '0' and led = x"0000" report "Liberacao prematura do reset" severity failure;
      end loop;
      previous_end := '0'; word_ref := x"B2C9";
      for bit_no in 0 to 32 loop
        index_ref := 15-(bit_no mod 16); sampled := word_ref(index_ref);
        if DIFFERENTIAL then first_level := previous_end xor (not sampled);
        else first_level := not sampled; end if;
        for phase in 0 to CPB-1 loop
          step;
          if phase < CPB/2 then expected := first_level; else expected := not first_level; end if;
          expected_led := (others => '0'); expected_led(index_ref) := expected;
          assert code = expected and data_bit = sampled and led = expected_led
            report "Integracao top/PMOD/sincronizadores incorreta" severity failure;
          if bit_no = 0 and phase = 2 then
            word_ref := not word_ref; sw <= word_ref;
          end if;
        end loop;
        previous_end := not first_level;
      end loop;
      -- Reset fora da borda de clock, durante transmissao.
      wait for 2 ns; btn <= '1'; wait for 1 ns;
      assert code = '0' and data_bit = '0' and led = x"0000"
        report "BTNC nao interrompeu a transmissao" severity failure;
    end loop;
    report "PASS: top_tb; PMOD, LEDs, captura e reset sincronizado" severity note;
    finish; wait;
  end process;
end architecture;
