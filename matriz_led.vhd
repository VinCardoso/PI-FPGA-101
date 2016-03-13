library ieee;
use ieee.std_logic_1164.all;

-- Entidade
  entity matriz_led is
    port(
      clk_in                      : in    std_logic;
      buttom_plus, buttom_minus   : in    std_logic;
      turn_on_matriz              : in    std_logic;  
      led_8                       : out   std_logic_vector(7 downto 0);
      led_5                       : out   std_logic_vector(4 downto 0);
      num_effect_asc              : out   character
    );
  end matriz_led;

architecture controller of matriz_led is

-- Função Int to ASCII
  function int_to_asc (int : integer) return character is
    variable asc : character;
    begin
    case int is
      when 0 => asc := '0';
      when 1 => asc := '1';
      when 2 => asc := '2';
      when 3 => asc := '3';
      when 4 => asc := '4';
      when 5 => asc := '5';
      when 6 => asc := '6';
      when 7 => asc := '7';
      when 8 => asc := '8';
      when 9 => asc := '9';
      when others => asc := '0';
    end case;
    return asc;
  end int_to_asc;

begin

process(clk_in)

-- Variáveis
  variable div_cloc     : integer := 0;
  variable cont         : integer range 0 to 30 := 0;
  variable max_div_cloc : integer := 1000000;
  variable alteracoes   : integer := 25;
  variable num_effect   : integer := 0;
  
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

    if(turn_on_matriz = '1') then

      case num_effect is
      -- Efeito Número 1
        when 1 =>
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

      -- Efeito Número 2
        when 2 =>
          case cont is
            when 1        => led_8 <= "00000001"; led_5 <= "00100";
            when 2        => led_8 <= "00000011"; led_5 <= "00100";
            when 3        => led_8 <= "00000111"; led_5 <= "00100";
            when 4        => led_8 <= "00001111"; led_5 <= "00100";
            when 5        => led_8 <= "00011111"; led_5 <= "00100";
            when 6        => led_8 <= "00111111"; led_5 <= "00100";
            when 7        => led_8 <= "01111111"; led_5 <= "00100";
            when 8        => led_8 <= "11111111"; led_5 <= "00100";
            when 9        => led_8 <= "11111110"; led_5 <= "00100";
            when 10       => led_8 <= "11111100"; led_5 <= "00100";
            when 11       => led_8 <= "11111000"; led_5 <= "00100";
            when 12       => led_8 <= "11110000"; led_5 <= "00100";
            when 13       => led_8 <= "11100000"; led_5 <= "00100";
            when 14       => led_8 <= "11000000"; led_5 <= "00100";
            when 15       => led_8 <= "10000000"; led_5 <= "00100";
            when 16       => led_8 <= "10000000"; led_5 <= "01010";
            when 17       => led_8 <= "10000000"; led_5 <= "10001";
            when 18       => led_8 <= "01000000"; led_5 <= "10001";
            when 19       => led_8 <= "00100000"; led_5 <= "10001";
            when 20       => led_8 <= "00010000"; led_5 <= "10001";
            when 21       => led_8 <= "00001000"; led_5 <= "10001";
            when 22       => led_8 <= "00000100"; led_5 <= "10001";
            when 23       => led_8 <= "00000010"; led_5 <= "10001";
            when 24       => led_8 <= "00000001"; led_5 <= "10001";
            when others   => led_8 <= "00000001"; led_5 <= "00001";
          end case;

      -- Efeito Número 3
        when 3 =>
          case cont is
            when 1        => led_8 <= "00000001"; led_5 <= "11111";
            when 2        => led_8 <= "00000011"; led_5 <= "11111";
            when 3        => led_8 <= "00000111"; led_5 <= "11111";
            when 4        => led_8 <= "00001111"; led_5 <= "11111";
            when 5        => led_8 <= "00011111"; led_5 <= "11111";
            when 6        => led_8 <= "00111111"; led_5 <= "11111";
            when 7        => led_8 <= "01111111"; led_5 <= "11111";
            when 8        => led_8 <= "11111111"; led_5 <= "11111";
            when 9        => led_8 <= "11111111"; led_5 <= "00000";

            when 10       => led_8 <= "10101010"; led_5 <= "11111";
            when 11       => led_8 <= "00000000"; led_5 <= "11111";
            when 12       => led_8 <= "01010101"; led_5 <= "11111";
            when 13       => led_8 <= "00000000"; led_5 <= "11111";
            when 14       => led_8 <= "11111111"; led_5 <= "10101";
            when 15       => led_8 <= "11111111"; led_5 <= "00000";
            when 16       => led_8 <= "11111111"; led_5 <= "01010";

            when 17       => led_8 <= "10000000"; led_5 <= "11111";
            when 18       => led_8 <= "01000000"; led_5 <= "11111";
            when 19       => led_8 <= "00100000"; led_5 <= "11111";
            when 20       => led_8 <= "00010000"; led_5 <= "11111";
            when 21       => led_8 <= "00001000"; led_5 <= "11111";
            when 22       => led_8 <= "00000100"; led_5 <= "11111";
            when 23       => led_8 <= "00000010"; led_5 <= "11111";
            when 24       => led_8 <= "00000001"; led_5 <= "11111";
            when others   => led_8 <= "00000000"; led_5 <= "11111";
          end case;

        when others =>
          led_8 <= "00000000"; led_5 <= "00000";

      end case;

    elsif(turn_on_matriz = '0') then
      led_8 <= "00000000"; led_5 <= "00000";
    end if;


    div_cloc := 0;

  end if;

  if(buttom_plus = '0' and num_effect < 3) then
    num_effect := num_effect + 1;
  elsif(buttom_minus = '0' and num_effect > 1) then
    num_effect := num_effect - 1;
  end if;

  num_effect_asc <= int_to_asc(num_effect);

end if;

end process;

end controller;
