library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity manchester_dif_tb is
end manchester_dif_tb;
architecture sim of manchester_dif_tb is
    constant CLK_PERIOD     : time    := 10 ns;
    constant CYCLES_PER_BIT : integer := 20;
    constant BIT_PERIOD     : time    := CYCLES_PER_BIT * CLK_PERIOD;
    constant LATENCIA       : time    := 3 * CLK_PERIOD + CLK_PERIOD / 2;
    constant SEQ_A : std_logic_vector(15 downto 0) := "1011001011100010";
    constant SEQ_B : std_logic_vector(15 downto 0) := "0101010100001111";
    signal clk      : std_logic := '0';
    signal rst      : std_logic := '1';
    signal data_in  : std_logic_vector(15 downto 0) := SEQ_A;
    signal data_out : std_logic;
    signal data_nrz : std_logic;
    signal led      : std_logic_vector(15 downto 0);
    signal erros    : integer := 0;
    signal fim      : boolean := false;
begin
    clk <= not clk after CLK_PERIOD / 2 when not fim else '0';
    dut : entity work.manchester_dif
        generic map (
            CYCLES_PER_BIT => CYCLES_PER_BIT
        )
        port map (
            clk      => clk,
            rst      => rst,
            data_in  => data_in,
            data_out => data_out,
            data_nrz => data_nrz,
            led      => led
        );
    process
        procedure confere(esperado : std_logic; i : integer; metade : string) is
            variable led_esp : std_logic_vector(15 downto 0);
             begin
            led_esp    := (others => '0');
            led_esp(i) := esperado;
            assert data_out = esperado
                report "data_out errado no bit " & integer'image(i) & " (" & metade & ")"
                severity error;
            assert led = led_esp
                report "led errado no bit " & integer'image(i) & " (" & metade & ")"
                severity error;
            if data_out /= esperado or led /= led_esp then
                erros <= erros + 1;
            end if;
        end procedure;
        variable nivel : std_logic := '0';
        procedure transmite(seq : std_logic_vector(15 downto 0); troca_no_fim : boolean) is
        begin
            for i in 15 downto 0 loop
                if seq(i) = '0' then
                    nivel := not nivel;
                end if;
                wait for BIT_PERIOD / 4;
                confere(nivel, i, "1a metade");
                nivel := not nivel;
                wait for BIT_PERIOD / 2;
                confere(nivel, i, "2a metade");
                if troca_no_fim and i = 0 then
                    data_in <= SEQ_B;
                end if;
                wait for BIT_PERIOD / 4;
            end loop;
        end procedure;
    begin
        wait for 10 * CLK_PERIOD;
        assert data_out = '0' and led = x"0000"
            report "saida deveria estar em nivel baixo durante o reset" severity error;
        wait until falling_edge(clk);
        rst <= '0';
        wait for LATENCIA;
        transmite(SEQ_A, false);
        transmite(SEQ_A, true);
        transmite(SEQ_B, false);
        wait for 3 * BIT_PERIOD + BIT_PERIOD / 3;
        rst <= '1';
        wait for 5 * CLK_PERIOD;
        assert data_out = '0' and led = x"0000"
            report "reset nao zerou a saida" severity error;
        wait for 2 * BIT_PERIOD;
        data_in <= SEQ_A;
        nivel   := '0';
        wait until falling_edge(clk);
        rst <= '0';
        wait for LATENCIA;
        transmite(SEQ_A, false);
        if erros = 0 then
            report "SIMULACAO OK: todas as verificacoes passaram" severity note;
              else
            report "SIMULACAO COM ERROS: " & integer'image(erros) severity error;
        end if;
        fim <= true;
        wait;
    end process;
end sim;