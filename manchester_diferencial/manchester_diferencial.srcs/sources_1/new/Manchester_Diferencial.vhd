library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Manchester_Diferencial is
    generic (
        CYCLES_PER_BIT : integer := 100_000_000  
    );
    port (
        clk       : in  std_logic;
        btnc      : in  std_logic;
        sw        : in  std_logic_vector(15 downto 0);
        led       : out std_logic_vector(15 downto 0);
        pmod_enc  : out std_logic;
        pmod_data : out std_logic;
        vga_r     : out std_logic_vector(3 downto 0);
        vga_g     : out std_logic_vector(3 downto 0);
        vga_b     : out std_logic_vector(3 downto 0);
        vga_hs    : out std_logic;
        vga_vs    : out std_logic
    );
end Manchester_Diferencial;

architecture rtl of Manchester_Diferencial is
    constant HALF : integer := CYCLES_PER_BIT / 2;

    signal sync1, sync2 : std_logic := '1';
    signal rst          : std_logic;

    signal cnt      : integer range 0 to CYCLES_PER_BIT - 1 := 0;
    signal idx      : integer range 0 to 15 := 15;
    signal cur_bit  : std_logic := '0';
    signal lvl      : std_logic := '0';   
    signal data_reg : std_logic := '0';
    signal led_reg  : std_logic_vector(15 downto 0) := (others => '0');

    signal pix_div : unsigned(1 downto 0) := (others => '0');
    signal hc      : integer range 0 to 799 := 0;
    signal vc      : integer range 0 to 524 := 0;
begin
    process(clk)
    begin
        if rising_edge(clk) then
            sync1 <= btnc;
            sync2 <= sync1;
        end if;
    end process;
    rst <= sync2;

    process(clk)
        variable v : std_logic;
    begin
        if rising_edge(clk) then
            if rst = '1' then
                cnt      <= 0;
                idx      <= 15;
                cur_bit  <= sw(15);
                lvl      <= '0';
                data_reg <= '0';
                led_reg  <= (others => '0');
            else
                if cnt = CYCLES_PER_BIT - 1 then
                    cnt <= 0;
                    if idx = 0 then
                        idx     <= 15;
                        cur_bit <= sw(15);
                    else
                        idx     <= idx - 1;
                        cur_bit <= sw(idx - 1);
                    end if;
                else
                    cnt <= cnt + 1;
                end if;

                v := lvl;
                if cnt = 0 then
                    if cur_bit = '0' then v := not v; end if; 
                elsif cnt = HALF then
                    v := not v;                                
                end if;

                lvl      <= v;
                data_reg <= cur_bit;
                led_reg  <= (others => '0');
                led_reg(idx) <= v;
            end if;
        end if;
    end process;

    led       <= led_reg;
    pmod_enc  <= lvl;
    pmod_data <= data_reg;

    
    process(clk)
    begin
        if rising_edge(clk) then
            if pix_div = 3 then
                pix_div <= (others => '0');
                if hc = 799 then
                    hc <= 0;
                    if vc = 524 then vc <= 0; else vc <= vc + 1; end if;
                else
                    hc <= hc + 1;
                end if;
            else
                pix_div <= pix_div + 1;
            end if;

            if hc < 640 and vc < 480 then
                if lvl = '1' then
                    vga_r <= x"0"; vga_g <= x"F"; vga_b <= x"0";
                else
                    vga_r <= x"0"; vga_g <= x"0"; vga_b <= x"F";
                end if;
            else
                vga_r <= x"0"; vga_g <= x"0"; vga_b <= x"0";
            end if;

            if hc >= 656 and hc < 752 then vga_hs <= '0'; else vga_hs <= '1'; end if;
            if vc >= 490 and vc < 492 then vga_vs <= '0'; else vga_vs <= '1'; end if;
        end if;
    end process;
end rtl;