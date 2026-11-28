library ieee;
use ieee.std_logic_1164.all;

entity input_conditioner is
  port (
    clk, btnC : in std_logic;
    sw : in std_logic_vector(15 downto 0);
    rst : out std_logic;
    sw_sync : out std_logic_vector(15 downto 0)
  );
end entity;

architecture rtl of input_conditioner is
  signal rst_pipe : std_logic_vector(1 downto 0) := (others => '1');
  signal sw_meta, sw_reg : std_logic_vector(15 downto 0) := (others => '0');
  attribute ASYNC_REG : string;
  attribute ASYNC_REG of rst_pipe, sw_meta, sw_reg : signal is "TRUE";
  attribute SHREG_EXTRACT : string;
  attribute SHREG_EXTRACT of rst_pipe, sw_meta, sw_reg : signal is "NO";
begin
  -- Assercao assincrona: apertar BTNC limpa a transmissao imediatamente.
  -- Liberacao sincronizada: o core inicia no terceiro flanco apos soltar.
  process(clk, btnC)
  begin
    if btnC = '1' then
      rst_pipe <= (others => '1');
    elsif rising_edge(clk) then
      rst_pipe <= rst_pipe(0) & '0';
    end if;
  end process;
  process(clk)
  begin
    if rising_edge(clk) then
      sw_meta <= sw;
      sw_reg <= sw_meta;
    end if;
  end process;
  rst <= rst_pipe(1);
  sw_sync <= sw_reg;
end architecture;
