library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity vgatest is
  port (
    clk12mhz  : in     std_logic;
    LED1      : out    std_logic;
    VGA_VSYNC : out    std_logic;
    VGA_HSYNC : out    std_logic;
    VGA_R     : out    std_logic;
    VGA_G     : out    std_logic;
    VGA_B     : out    std_logic);
end vgatest;

architecture rtl of vgatest is

  signal cnt    : natural range 0 to 7;   --subpixel count
  signal pcnt   : natural range 0 to 799; --pixel    count (160 is 1st visible)
  signal lcnt   : natural range 0 to 524; --line     count (0 is 1st visible)
  signal fcnt   : natural range 0 to 127;  --frame    count
  signal i_clk  : std_logic;

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
          if (cnt < 7) then
            cnt <= cnt + 1;
          else
            cnt <= 0;
            if (pcnt < 799) then
              pcnt <= pcnt + 1;
            else
              pcnt <= 0;
              if (lcnt < 524) then
                lcnt <= lcnt + 1;
              else
                lcnt <= 0;
                if (fcnt < 127) then
                  fcnt <= fcnt + 1;
                else
                  fcnt <= 0;
                end if;
              end if;
            end if;
          end if;
        end if;
    end process;

    process (lcnt) is
      begin
      if (lcnt = 480+10) then
        VGA_VSYNC <= '1';
      end if;
      if (lcnt = 480+10+2) then
        VGA_VSYNC <= '0';
      end if;
    end process;

    process (pcnt) is
      begin
      if (pcnt = 16) then
        VGA_HSYNC <= '1';
      end if;
      if (pcnt = 16+96) then
        VGA_HSYNC <= '0';
      end if;
    end process;

    process (pcnt) is
      begin
      if (pcnt > 160 and lcnt < 480) then
        if (((pcnt - fcnt + lcnt) / 64 ) mod 2 = 0) then
          VGA_R <= '0';
        else
          VGA_R <= '1';
        end if;
        if (((pcnt - fcnt - lcnt) / 64 ) mod 2 = 0) then
          VGA_G <= '0';
        else
          VGA_G <= '1';
        end if;
        if (((pcnt + fcnt) / 32 ) mod 2 = 0) then
          VGA_B <= '0';
        else
          VGA_B <= '1';
        end if;
      else
        VGA_R <= '1';
        VGA_G <= '1';
        VGA_B <= '1';
      end if;
    end process;

end rtl;
