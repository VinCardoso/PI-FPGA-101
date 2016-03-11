LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.ALL;

ENTITY temperature IS
  PORT(
      clock_in                                                : IN    STD_LOGIC;                      -- Entrade de 1Hz 
      temperature_in                                          : IN    STD_LOGIC_VECTOR(7 DOWNTO 0);   -- Entrade da temperatura em biário
      turn_on_cooler                                          : OUT   STD_LOGIC;                      -- Saída para ligar cooller
      temp_display_cem, temp_display_dez, temp_display_um     : OUT   STD_LOGIC_VECTOR(9 DOWNTO 0);   -- Números para mostrar display temperatura atual
      level_display_cem, level_display_dez, level_display_um  : OUT   STD_LOGIC_VECTOR(9 DOWNTO 0)    -- Números para mostrar display nível de temperatura
    );
END temperature;

ARCHITECTURE behavior OF temperature IS

BEGIN

  PROCESS(clock_in)

  -- Variáveis
    VARIABLE    temp_display_cem, temp_display_dez, temp_display_um       : STD_LOGIC_VECTOR(9 DOWNTO 0);
    VARIABLE    temperature_int, temp_cem_int, temp_dez_int, temp_um_int  : INTEGER;
    VARIABLE    temp_cem_bin, temp_dez_bin, temp_um_bin                   : STD_LOGIC_VECTOR(7 DOWNTO 0);

    VARIABLE    temp_turn_cool_on                                         : INTEGER := 25;
    VARIABLE    lvl_display_cem, lvl_display_dez, lvl_display_um          : STD_LOGIC_VECTOR(9 DOWNTO 0);
    VARIABLE    lvl_cem_int, lvl_dez_int, lvl_um_int                      : INTEGER;
    VARIABLE    lvl_cem_bin, lvl_dez_bin, lvl_um_bin                      : STD_LOGIC_VECTOR(7 DOWNTO 0);
    
  BEGIN

    if(clock_in'EVENT AND clock_in = '1') then

    -- Temperatura
      temperature_int         := conv_integer(temperature_in);
      temperature_int         := temperature_int / 2;
      -- Decimal
      temp_cem_int            := temperature_int / 100;         
      temp_dez_int            := (temperature_int mod 100) / 10;
      temp_um_int             := (temperature_int mod 100) mod 10;
      -- Binário
      temp_cem_bin            := conv_std_logic_vector(temp_cem_int,8);
      temp_dez_bin            := conv_std_logic_vector(temp_dez_int,8);
      temp_um_bin             := conv_std_logic_vector(temp_um_int,8);

      temp_display_cem        := "10" & (conv_std_logic_vector(character'pos('0'),8) + temp_cem_bin);
      temp_display_dez        := "10" & (conv_std_logic_vector(character'pos('0'),8) + temp_dez_bin);
      temp_display_um         := "10" & (conv_std_logic_vector(character'pos('0'),8) + temp_um_bin);

    -- Level da Temperatura
      lvl_cem_int             := temp_turn_cool_on / 100;         
      lvl_dez_int             := (temp_turn_cool_on mod 100) / 10;
      lvl_um_int              := (temp_turn_cool_on mod 100) mod 10;
      -- Binário
      lvl_cem_bin             := conv_std_logic_vector(lvl_cem_int,8);
      lvl_dez_bin             := conv_std_logic_vector(lvl_dez_int,8);
      lvl_um_bin              := conv_std_logic_vector(lvl_um_int,8);

      lvl_display_cem         := "10" & (conv_std_logic_vector(character'pos('0'),8) + lvl_cem_bin);
      lvl_display_dez         := "10" & (conv_std_logic_vector(character'pos('0'),8) + lvl_dez_bin);
      lvl_display_um          := "10" & (conv_std_logic_vector(character'pos('0'),8) + lvl_um_bin);

      if(temperature_int > temp_turn_cool_on) then
        turn_on_cooler <= '0';
      elsif(temperature_int < temp_turn_cool_on) then
        turn_on_cooler <= '1';
      end if;

    end if;
  
  END PROCESS;
END behavior;
