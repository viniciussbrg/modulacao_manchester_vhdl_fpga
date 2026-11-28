library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_Manchester is
end tb_Manchester;

architecture sim of tb_Manchester is
    constant CLK_PERIOD     : time    := 10 ns;
    constant CYCLES_PER_BIT : integer := 10;
    constant BIT_PERIOD     : time    := CYCLES_PER_BIT * CLK_PERIOD;  
    constant SW_VAL : std_logic_vector(15 downto 0) := x"B2A5"; 

    signal clk       : std_logic := '0';
    signal btnc      : std_logic := '1';
    signal sw        : std_logic_vector(15 downto 0) := (others => '0');
    signal led       : std_logic_vector(15 downto 0);
    signal pmod_enc, pmod_data : std_logic;
    signal vga_r, vga_g, vga_b : std_logic_vector(3 downto 0);
    signal vga_hs, vga_vs      : std_logic;
    signal done : boolean := false;
begin
    uut : entity work.Manchester
        generic map (CYCLES_PER_BIT => CYCLES_PER_BIT)
        port map (clk => clk, btnc => btnc, sw => sw, led => led,
                  pmod_enc => pmod_enc, pmod_data => pmod_data,
                  vga_r => vga_r, vga_g => vga_g, vga_b => vga_b,
                  vga_hs => vga_hs, vga_vs => vga_vs);

    clk_proc : process
    begin
        while not done loop
            clk <= '0'; wait for CLK_PERIOD / 2;
            clk <= '1'; wait for CLK_PERIOD / 2;
        end loop;
        wait;
    end process;

    stim : process
        variable idx     : integer;
        variable b       : std_logic;
        variable exp_vec : std_logic_vector(15 downto 0);
    begin
        btnc <= '1';
        sw   <= SW_VAL;
        wait for 3 * CLK_PERIOD;
        assert led = x"0000" and pmod_enc = '0'
            report "Saida nao esta em nivel baixo durante o reset" severity error;

        wait until falling_edge(clk);
        btnc <= '0';                                   
        wait for 2 * CLK_PERIOD + CLK_PERIOD / 2;    

        for i in 0 to 31 loop                      
            idx := 15 - (i mod 16);
            b   := SW_VAL(idx);

            
            wait for BIT_PERIOD / 4;
            exp_vec := (others => '0');
            exp_vec(idx) := not b;
            assert led = exp_vec
                report "LED incorreto na 1a metade do bit " & integer'image(idx) severity error;
            assert pmod_enc = (not b)
                report "PMOD incorreto na 1a metade do bit " & integer'image(idx) severity error;

            
            wait for BIT_PERIOD / 2;
            exp_vec(idx) := b;
            assert led = exp_vec
                report "LED incorreto na 2a metade do bit " & integer'image(idx) severity error;
            assert pmod_enc = b
                report "PMOD incorreto na 2a metade do bit " & integer'image(idx) severity error;

            wait for BIT_PERIOD / 4;
        end loop;

        report "Simulacao Manchester concluida." severity note;
        done <= true;
        wait;
    end process;
end sim;