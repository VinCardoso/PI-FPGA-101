-- Bibliotecas
  library ieee;
  use ieee.std_logic_1164.all;
  use ieee.std_logic_arith.all;
  use ieee.std_logic_unsigned.all;

-- Entidade
  entity luminosidade is
    port(
      clock_in                                  : in    std_logic;                      -- Entrade de 12MHz 
      light_in                                  : in    std_logic_vector(7 downto 0);   -- Entrada luminosidade em biário
      buttom_plus, buttom_minus                 : in    std_logic;                      -- Botões p/ Aumentar e Diminuir Nível
      lum_asc, lvl_lum_asc                      : out   character;                      -- Saída de lumiosidade e level em ASCII 
      turn_on_matriz                            : out   std_logic                       -- Ligar ou Desligar Matriz
    );
  end luminosidade;

architecture behavior of luminosidade is

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

process(clock_in)

-- Variáveis
  variable  light_int             : integer;
  variable  light_turn_on_matriz  : integer := 4; 

begin

if(clock_in'event and clock_in= '1') then

-- Calculos Luminosidade Binário para Níveis (de 0 a 9)
  light_int     := conv_integer(light_in);
  light_int     := light_int / 26;

  lum_asc       <= int_to_asc(light_int);
  lvl_lum_asc   <= int_to_asc(light_turn_on_matriz);

-- Comparar Luminosidade c/ Nível p/ Ligar Matriz
  if(light_int < light_turn_on_matriz or light_int = light_turn_on_matriz) then
    turn_on_matriz <= '1';
  elsif(light_int > light_turn_on_matriz) then
    turn_on_matriz <= '0';
  end if;

-- Alterar Nível
  if(buttom_plus = '0' and light_turn_on_matriz < 9) then
    light_turn_on_matriz := light_turn_on_matriz + 1;
  elsif(buttom_minus = '0' and light_turn_on_matriz > 0) then
    light_turn_on_matriz := light_turn_on_matriz - 1;
  end if;

end if;

end process;

end behavior;
