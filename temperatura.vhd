-- Bibliotecas
  library ieee;
  use ieee.std_logic_1164.all;
  use ieee.std_logic_arith.all;
  use ieee.std_logic_unsigned.all;

-- Entidade
  entity temperatura is
    port(
      clock_in                                  : in    std_logic;                      -- Entrade de 12MHz 
      temperature_in                            : in    std_logic_vector(7 downto 0);   -- Entrada temperatura em biário
      buttom_plus, buttom_minus                 : in    std_logic;                      -- Botões p/ Aumentar e Diminuir Nível
      temp_cem_asc, temp_dez_asc, temp_um_asc   : out   character;                      -- Saída de númeres temperatura em ASCII 
      lvl_cem_asc, lvl_dez_asc, lvl_um_asc      : out   character;                      -- Saída de númeres level em ASCII
      turn_on_cooler                            : out   std_logic                       -- Ligar ou Desligar Cooler
    );
  end temperatura;

architecture behavior of temperatura is

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
  variable  temperature_int, temp_cem_int, temp_dez_int, temp_um_int  : integer;
  variable  lvl_cem_int, lvl_dez_int, lvl_um_int                      : integer;
  variable  temp_turn_cool_on                                         : integer := 25; 

begin

if(clock_in'event and clock_in= '1') then

-- Calculos Temperatura
  -- Binário p/ Inteiro
  temperature_int     := conv_integer(temperature_in);
  temperature_int     := temperature_int / 2;
  -- Dividir Decimal
  temp_cem_int        := temperature_int / 100;         
  temp_dez_int        := (temperature_int mod 100) / 10;
  temp_um_int         := (temperature_int mod 100) mod 10;
  -- Decimal p/ Binário
  temp_cem_asc        <= int_to_asc(temp_cem_int);
  temp_dez_asc        <= int_to_asc(temp_dez_int);
  temp_um_asc         <= int_to_asc(temp_um_int);

-- Cálculos Nível de Temperatura
  -- Dividir Decimal Nível
  lvl_cem_int         := temp_turn_cool_on / 100;         
  lvl_dez_int         := (temp_turn_cool_on mod 100) / 10;
  lvl_um_int          := (temp_turn_cool_on mod 100) mod 10;
  -- Decimal p/ Binário Nível
  lvl_cem_asc         <= int_to_asc(lvl_cem_int);
  lvl_dez_asc         <= int_to_asc(lvl_dez_int);
  lvl_um_asc          <= int_to_asc(lvl_um_int);

-- Comparar Temperatura c/ Nível p/ Ligar Cooler
  if(temperature_int > temp_turn_cool_on or temperature_int = temp_turn_cool_on) then
    turn_on_cooler <= '1';
  elsif(temperature_int < temp_turn_cool_on) then
    turn_on_cooler <= '0';
  end if;

-- Alterar Temperatura
  if(buttom_plus = '0' and temp_turn_cool_on < 128) then
    temp_turn_cool_on := temp_turn_cool_on + 1;
  elsif(buttom_minus = '0' and temp_turn_cool_on > 0) then
    temp_turn_cool_on := temp_turn_cool_on - 1;
  end if;

end if;

end process;

end behavior;
