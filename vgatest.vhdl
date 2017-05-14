library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity vgatest is
  port (
    i_clk     : in     std_logic;
    LED1      : out    std_logic;
    VGA_VSYNC : out    std_logic);
end vgatest;

architecture rtl of vgatest is

  signal cnt : natural range 0 to 1000000;
  signal led : std_logic;

  begin

    process (i_clk) is
      begin
        if rising_edge(i_clk) then
          cnt <= cnt + 1;
          if (cnt = 0) then
            if (led = '0') then
              led <= '1';
            else
              led <= '0';
            end if;
          end if;
        end if;
    end process;

    LED1      <= led;
    VGA_VSYNC <= led;

end rtl;
