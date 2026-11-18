-- MANCHESTER DIFERENCIAL
-- Bit 0: inverte o nivel no INICIO do bit.
-- Bit 1: mantem o nivel anterior no INICIO do bit.
-- No MEIO de qualquer bit: sempre inverte o nivel.
-- Reset: saida baixa. Ordem: 15 ate 0, repetidamente.

library ieee;
use ieee.std_logic_1164.all;

entity manchester_dif is
    generic (
        -- 1 segundo por bit a 100 MHz.
        -- O testbench substitui este valor por 10 ciclos.
        CYCLES_PER_BIT : positive := 100_000_000
    );
    port (
        clk      : in  std_logic;
        rst      : in  std_logic;
        data_in  : in  std_logic_vector(15 downto 0);
        data_out : out std_logic;
        led      : out std_logic_vector(15 downto 0)
    );
end entity manchester_dif;

architecture rtl of manchester_dif is
    constant HALF_CYCLES : natural := CYCLES_PER_BIT / 2;

    signal cycle_count : natural range 0 to CYCLES_PER_BIT - 1 := 0;
    signal bit_index   : natural range 0 to 15 := 15;

    -- Dado capturado e metade atual, para acompanhar no waveform.
    signal current_bit : std_logic := '0';
    signal half_bit    : std_logic := '0';

    -- Este registrador memoriza o ultimo nivel transmitido.
    -- Essa memoria e essencial para o Manchester Diferencial.
    signal encoded_reg : std_logic := '0';
    signal started     : std_logic := '0';
begin
    assert CYCLES_PER_BIT >= 2 and CYCLES_PER_BIT mod 2 = 0
        report "CYCLES_PER_BIT deve ser par e maior ou igual a 2."
        severity failure;

    data_out <= encoded_reg;

    process (clk)
        variable next_index : natural range 0 to 15;
    begin
        if rising_edge(clk) then
            -- Reset sincrono e prioritario.
            if rst = '1' then
                cycle_count <= 0;
                bit_index   <= 15;
                current_bit <= '0';
                half_bit    <= '0';
                encoded_reg <= '0';
                started     <= '0';

            elsif started = '0' then
                -- Inicio do primeiro bit depois do reset.
                cycle_count <= 0;
                bit_index   <= 15;
                current_bit <= data_in(15);
                half_bit    <= '0';
                started     <= '1';

                -- Le diretamente a entrada nesta borda.
                -- current_bit ainda possui o valor anterior no processo.
                if data_in(15) = '0' then
                    encoded_reg <= not encoded_reg;
                end if;

                -- Se o dado for 1, nao ha atribuicao:
                -- o registrador conserva o nivel anterior.

            elsif cycle_count = CYCLES_PER_BIT - 1 then
                -- Fim do bit atual: escolhe a proxima posicao.
                if bit_index = 0 then
                    next_index := 15;
                else
                    next_index := bit_index - 1;
                end if;

                cycle_count <= 0;
                bit_index   <= next_index;
                current_bit <= data_in(next_index);
                half_bit    <= '0';

                -- Inicio do novo bit: 0 inverte; 1 mantem.
                -- O nivel anterior e preservado inclusive na volta 0 -> 15.
                -- Nao devemos zerar encoded_reg ao recomecar a sequencia.
                if data_in(next_index) = '0' then
                    encoded_reg <= not encoded_reg;
                end if;

            else
                cycle_count <= cycle_count + 1;

                -- A comparacao usa o valor antigo do contador.
                -- Com 10 ciclos: antigo 4 -> novo 5, meio do bit.
                if cycle_count = HALF_CYCLES - 1 then
                    half_bit <= '1';

                    -- No meio, SEMPRE inverte, para qualquer dado.
                    -- A entrada nao e consultada novamente aqui.
                    encoded_reg <= not encoded_reg;
                end if;
            end if;
        end if;
    end process;

    -- Aplica o sinal somente ao LED da posicao atual.
    process (bit_index, encoded_reg)
        variable leds_value : std_logic_vector(15 downto 0);
    begin
        leds_value := (others => '0');
        leds_value(bit_index) := encoded_reg;
        led <= leds_value;
    end process;
end architecture rtl;