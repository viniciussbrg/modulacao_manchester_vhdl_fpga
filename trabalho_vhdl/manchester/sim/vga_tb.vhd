library ieee;
use ieee.std_logic_1164.all;
use std.env.all;
entity vga_tb is end entity;
architecture test of vga_tb is
  signal clk : std_logic := '0';
  signal encoded : std_logic := '0';
  signal r,g,b : std_logic_vector(3 downto 0);
  signal hs,vs : std_logic;
begin
  clk <= not clk after 5 ns;
  dut : entity work.vga_colors port map(clk,encoded,r,g,b,hs,vs);
  process
    variable exp_hs,exp_vs : std_logic;
    variable exp_r,exp_g,exp_b : std_logic_vector(3 downto 0);
    variable x,y,active_count,hs_count,vs_count : natural;
  begin
    -- Dois quadros completos e inicio do terceiro: sincronismos, blanking,
    -- contagem de pixels e as duas cores em todos os pixels ativos.
    for frame in 0 to 1 loop
      active_count := 0; hs_count := 0; vs_count := 0;
      if frame = 0 then encoded <= '0'; else encoded <= '1'; end if;
      for pixel in 0 to 800*525-1 loop
        for cycle in 1 to 4 loop wait until rising_edge(clk); end loop;
        wait for 1 ns;
        x := pixel mod 800; y := pixel / 800;
        exp_hs := '1'; exp_vs := '1';
        if x >= 656 and x < 752 then exp_hs := '0'; hs_count := hs_count+1; end if;
        if y >= 490 and y < 492 then exp_vs := '0'; vs_count := vs_count+1; end if;
        exp_r := x"0"; exp_g := x"0"; exp_b := x"0";
        if x < 640 and y < 480 then
          active_count := active_count+1;
          if frame = 0 then exp_b := x"F"; else exp_g := x"F"; end if;
        end if;
        assert hs = exp_hs and vs = exp_vs report "Sincronismo VGA incorreto" severity failure;
        assert r = exp_r and g = exp_g and b = exp_b report "RGB/blanking VGA incorreto" severity failure;
      end loop;
      assert active_count = 640*480 and hs_count = 96*525 and vs_count = 2*800
        report "Geometria VGA incorreta" severity failure;
    end loop;
    for cycle in 1 to 4 loop wait until rising_edge(clk); end loop;
    wait for 1 ns;
    assert hs = '1' and vs = '1' and g = x"F" and b = x"0" severity failure;
    report "PASS: vga_tb; dois quadros 800x525 e retorno ao inicio" severity note;
    finish; wait;
  end process;
end architecture;
