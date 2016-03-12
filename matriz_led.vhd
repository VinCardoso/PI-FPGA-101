library ieee;
use ieee.std_logic_1164.all;

entity matriz_led is
  port(
    clk_in        : in    std_logic;
    led_8         : out   std_logic_vector(7 downto 0);
    led_5         : out   std_logic_vector(4 downto 0);
    num_efect     : in    integer
  );
end matriz_led;

architecture controller of matriz_led is

begin

  process(clk_in)

    variable div_cloc     : integer := 0;
    variable cont         : integer range 0 to 30 := 0;
    variable max_div_cloc : integer := 1000000;
    variable alteracoes   : integer := 25;
  
  begin

  if(clk_in'event and clk_in= '1') then

    if (div_cloc < max_div_cloc) then
      div_cloc := div_cloc + 1;
    else

        if(cont < alteracoes) then
          cont := cont + 1;
        end if;

        if(cont = alteracoes) then
          cont := 0;
        end if;

        case cont is
          when 1        => led_8 <= "00000001"; led_5 <= "00001";
          when 2        => led_8 <= "00000011"; led_5 <= "00001";
          when 3        => led_8 <= "00000111"; led_5 <= "00001";
          when 4        => led_8 <= "00001111"; led_5 <= "00001";
          when 5        => led_8 <= "00011111"; led_5 <= "00001";
          when 6        => led_8 <= "00111111"; led_5 <= "00001";
          when 7        => led_8 <= "01111111"; led_5 <= "00001";
          when 8        => led_8 <= "11111111"; led_5 <= "00001";
          when 9        => led_8 <= "11111111"; led_5 <= "00010";
          when 10       => led_8 <= "11111111"; led_5 <= "00100";
          when 11       => led_8 <= "11111111"; led_5 <= "01000";
          when 12       => led_8 <= "11111111"; led_5 <= "10000";
          when 13       => led_8 <= "11111111"; led_5 <= "10000";
          when 14       => led_8 <= "01111111"; led_5 <= "10000";
          when 15       => led_8 <= "00111111"; led_5 <= "10000";
          when 16       => led_8 <= "00011111"; led_5 <= "10000";
          when 17       => led_8 <= "00001111"; led_5 <= "10000";
          when 18       => led_8 <= "00000111"; led_5 <= "10000";
          when 19       => led_8 <= "00000011"; led_5 <= "10000";
          when 20       => led_8 <= "00000001"; led_5 <= "10000";
          when 21       => led_8 <= "00000001"; led_5 <= "01000";
          when 22       => led_8 <= "00000001"; led_5 <= "00100";
          when 23       => led_8 <= "00000001"; led_5 <= "00010";
          when 24       => led_8 <= "00000001"; led_5 <= "00001";
          when others   => led_8 <= "00000001"; led_5 <= "00001";
        end case;

        div_cloc := 0;

    end if;

  end if;
    
  end process;

end controller;
