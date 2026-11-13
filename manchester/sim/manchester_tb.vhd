library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity manchester_tb is
end manchester_tb;

architecture Behavioral of manchester_tb is

    constant CLK_PERIOD     : time    := 10 ns;
    constant CYCLES_PER_BIT : integer := 10;
    constant BIT_PERIOD     : time    := CYCLES_PER_BIT * CLK_PERIOD;

    constant DATA_A : std_logic_vector(15 downto 0) := x"B2A5";
    constant DATA_B : std_logic_vector(15 downto 0) := x"5A3C";

    constant T_RELEASE : time := 5 * CLK_PERIOD;
    constant T_START   : time := T_RELEASE + 2 * CLK_PERIOD + CLK_PERIOD / 2;

    signal clk      : std_logic := '0';
    signal rst      : std_logic := '1';
    signal data_in  : std_logic_vector(15 downto 0) := DATA_A;
    signal data_out : std_logic;
    signal data_raw : std_logic;
    signal led      : std_logic_vector(15 downto 0);
    signal sim_done : boolean := false;

begin

    uut: entity work.manchester
        generic map (CYCLES_PER_BIT => CYCLES_PER_BIT)
        port map (
            clk      => clk,
            rst      => rst,
            data_in  => data_in,
            data_out => data_out,
            data_raw => data_raw,
            led      => led
        );

    clk_proc : process
    begin
        while not sim_done loop
            clk <= '0'; wait for CLK_PERIOD / 2;
            clk <= '1'; wait for CLK_PERIOD / 2;
        end loop;
        wait;
    end process;

    -- troca a sequencia no meio do bit SW0 do 1o quadro
    data_proc : process
    begin
        wait for T_START + 15 * BIT_PERIOD + BIT_PERIOD / 2;
        data_in <= DATA_B;
        wait;
    end process;

    stim_proc : process

        procedure check_one(constant b : in std_logic; constant p : in integer) is
            variable exp_led : std_logic_vector(15 downto 0);
        begin
            wait for BIT_PERIOD / 4;
            exp_led := (others => '0'); exp_led(p) := not b;
            assert data_out = not b
                report "Manchester: 1a metade errada no bit SW" & integer'image(p) severity error;
            assert led = exp_led
                report "Manchester: LED errado (1a metade) no bit SW" & integer'image(p) severity error;
            assert data_raw = b
                report "Manchester: data_raw errado no bit SW" & integer'image(p) severity error;

            wait for BIT_PERIOD / 2;
            exp_led := (others => '0'); exp_led(p) := b;
            assert data_out = b
                report "Manchester: 2a metade errada no bit SW" & integer'image(p) severity error;
            assert led = exp_led
                report "Manchester: LED errado (2a metade) no bit SW" & integer'image(p) severity error;

            wait for BIT_PERIOD / 4;
        end procedure;

    begin
        wait for T_RELEASE;
        rst <= '0';
        wait for 2 * CLK_PERIOD + CLK_PERIOD / 2;

        for p in 15 downto 0 loop
            check_one(DATA_A(p), p);
        end loop;

        for p in 15 downto 0 loop
            check_one(DATA_B(p), p);
        end loop;

        for p in 15 downto 13 loop
            check_one(DATA_B(p), p);
        end loop;
        wait for BIT_PERIOD / 4;
        wait until falling_edge(clk);
        rst <= '1';
        wait for 4 * CLK_PERIOD;
        assert data_out = '0'
            report "Manchester: saida deve ficar baixa durante o reset" severity error;
        assert led = x"0000"
            report "Manchester: LEDs devem ficar apagados durante o reset" severity error;

        wait until falling_edge(clk);
        rst <= '0';
        wait for 2 * CLK_PERIOD + CLK_PERIOD / 2;
        check_one(DATA_B(15), 15);
        check_one(DATA_B(14), 14);

        report "Testbench Manchester concluido." severity note;
        sim_done <= true;
        wait;
    end process;

end Behavioral;