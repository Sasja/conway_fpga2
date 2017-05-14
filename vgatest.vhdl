library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity vgatest is
  port (
    clk12mhz  : in     std_logic;
    LED1      : out    std_logic;
    VGA_VSYNC : out    std_logic);
end vgatest;

architecture rtl of vgatest is

  signal cnt  : natural range 0 to 1000000;
  signal led  : std_logic;
  signal i_clk: std_logic;

  begin

    vgatest_pll_inst: entity work.vgatest_pll
    port map(
              REFERENCECLK => clk12mhz,
              PLLOUTCORE => open,
              PLLOUTGLOBAL => i_clk,
              RESET => '1'
            );

    process (i_clk) is
      begin
        if rising_edge(i_clk) then
          if (cnt = 999999) then
            cnt <= 0;
            if (led = '0') then
              led <= '1';
            else
              led <= '0';
            end if;
          else
            cnt <= cnt + 1;
          end if;
        end if;
    end process;

    LED1      <= led;
    VGA_VSYNC <= led;

end rtl;
