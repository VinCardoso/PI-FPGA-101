--------------------------------------------------------------------------------
--
--   FileName:         lcd_example.vhd
--   Dependencies:     none
--   Design Software:  Quartus II 32-bit Version 11.1 Build 173 SJ Full Version
--
--   HDL CODE IS PROVIDED "AS IS."  DIGI-KEY EXPRESSLY DISCLAIMS ANY
--   WARRANTY OF ANY KIND, WHETHER EXPRESS OR IMPLIED, INCLUDING BUT NOT
--   LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
--   PARTICULAR PURPOSE, OR NON-INFRINGEMENT. IN NO EVENT SHALL DIGI-KEY
--   BE LIABLE FOR ANY INCIDENTAL, SPECIAL, INDIRECT OR CONSEQUENTIAL
--   DAMAGES, LOST PROFITS OR LOST DATA, HARM TO YOUR EQUIPMENT, COST OF
--   PROCUREMENT OF SUBSTITUTE GOODS, TECHNOLOGY OR SERVICES, ANY CLAIMS
--   BY THIRD PARTIES (INCLUDING BUT NOT LIMITED TO ANY DEFENSE THEREOF),
--   ANY CLAIMS FOR INDEMNITY OR CONTRIBUTION, OR OTHER SIMILAR COSTS.
--
--   Version History
--   Version 1.0 6/13/2012 Scott Larson
--     Initial Public Release
--
--   Prints "123456789" on a HD44780 compatible 8-bit interface character LCD 
--   module using the lcd_controller.vhd component.
--
--------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.ALL;

ENTITY pi IS
  PORT(
      clk                         : IN    STD_LOGIC;                      -- Clock e Botão de troca
      rw, rs, e                   : OUT   STD_LOGIC;                      --read/write, setup/data, and enable for lcd
      lcd_data                    : OUT   STD_LOGIC_VECTOR(7 DOWNTO 0);  --data signals for lcd
      buttom_plus, buttom_minus   : IN    STD_LOGIC;
      TEMP_IN                     : IN    STD_LOGIC_VECTOR(7 DOWNTO 0);
      clk_out                     : OUT   STD_LOGIC
  );
END pi;

ARCHITECTURE behavior OF pi IS

  SIGNAL   lcd_enable : STD_LOGIC;
  SIGNAL   lcd_bus    : STD_LOGIC_VECTOR(9 DOWNTO 0);
  SIGNAL   lcd_busy   : STD_LOGIC;

  COMPONENT lcd_controller IS
    PORT(
       clk        : IN    STD_LOGIC;                        --system clock
       reset_n    : IN    STD_LOGIC;                        --active low reinitializes lcd
       lcd_enable : IN    STD_LOGIC;                        --latches data into lcd controller
       lcd_bus    : IN    STD_LOGIC_VECTOR(9 DOWNTO 0);     --data and control signals
       busy       : OUT   STD_LOGIC;                        --lcd controller busy/idle feedback
       rw, rs, e  : OUT   STD_LOGIC;                        --read/write, setup/data, and enable for lcd
       lcd_data   : OUT   STD_LOGIC_VECTOR(7 DOWNTO 0));    --data signals for lcd
  END COMPONENT;

  COMPONENT clock_1hz IS
    PORT(
      clk_in        : IN    STD_LOGIC;
      clk_out       : OUT    STD_LOGIC
    );
  END COMPONENT;

BEGIN

  --instantiate the lcd controller
  lcd_control: lcd_controller
    PORT MAP(clk => clk, reset_n => '1', lcd_enable => lcd_enable, lcd_bus => lcd_bus, busy => lcd_busy, rw => rw, rs => rs, e => e, lcd_data => lcd_data);
  
  clock1: clock_1hz
    PORT MAP(clk, clk_out);

  PROCESS(clk)

    VARIABLE char                                         :   INTEGER RANGE 0 TO 30 := 0;
    VARIABLE temperatura                                  :   STD_LOGIC_VECTOR(7 DOWNTO 0);
    VARIABLE temp_turn_on_cooler                          :   INTEGER := 30;
    VARIABLE um, dez, cooler_um, cooler_dez               :   STD_LOGIC_VECTOR(7 DOWNTO 0);
    VARIABLE temperatura_int, temp_dez_int, temp_um_int   :   INTEGER;
    VARIABLE cooler_dez_int, cooler_um_int                :   INTEGER;

  BEGIN

    temperatura := TEMP_IN;    

    IF(clk'EVENT AND clk = '1') THEN

    
      -- Converte Temperatura de Entrada
      temperatura_int         := conv_integer(temperatura);
      temperatura_int         := temperatura_int / 2;
      temp_dez_int            := temperatura_int / 10;
      temp_um_int             := temperatura_int mod 10;
      dez                     := conv_std_logic_vector(temp_dez_int,8);
      um                      := conv_std_logic_vector(temp_um_int,8);

      -- Converte Temperatura de Ligar Cooler
      cooler_dez_int           := temp_turn_on_cooler / 10;
      cooler_um_int            := temp_turn_on_cooler  mod 10;
      cooler_dez               := conv_std_logic_vector(cooler_dez_int,8);
      cooler_um                := conv_std_logic_vector(cooler_um_int,8);

      IF(lcd_busy = '0' AND lcd_enable = '0') THEN
        lcd_enable <= '1';
        IF(char < 30) THEN
          char := char + 1;
        END IF;
        CASE char IS
          WHEN 1    =>  lcd_bus   <=  "10" & conv_std_logic_vector(character'pos('T'),8);
          WHEN 2    =>  lcd_bus   <=  "10" & conv_std_logic_vector(character'pos('e'),8);
          WHEN 3    =>  lcd_bus   <=  "10" & conv_std_logic_vector(character'pos('m'),8);
          WHEN 4    =>  lcd_bus   <=  "10" & conv_std_logic_vector(character'pos('p'),8);
          WHEN 5    =>  lcd_bus   <=  "10" & conv_std_logic_vector(character'pos('.'),8);
          WHEN 6    =>  lcd_bus   <=  "0010001100"; -- Mover para fim da linha;
          WHEN 7    =>  lcd_bus   <=  "10" & (conv_std_logic_vector(character'pos('0'),8) + dez);
          WHEN 8    =>  lcd_bus   <=  "10" & (conv_std_logic_vector(character'pos('0'),8) + um);
          WHEN 9    =>  lcd_bus   <=  "1011011111"; -- Bola do ºC;
          WHEN 10   =>  lcd_bus   <=  "10" & conv_std_logic_vector(character'pos('C'),8);
          WHEN 11   =>  lcd_bus   <=  "0011000000"; -- Pular Linha;
          WHEN 12   =>  lcd_bus   <=  "10" & conv_std_logic_vector(character'pos('L'),8);
          WHEN 13   =>  lcd_bus   <=  "10" & conv_std_logic_vector(character'pos('i'),8);
          WHEN 14   =>  lcd_bus   <=  "10" & conv_std_logic_vector(character'pos('g'),8);
          WHEN 15   =>  lcd_bus   <=  "10" & conv_std_logic_vector(character'pos('a'),8);
          WHEN 16   =>  lcd_bus   <=  "10" & conv_std_logic_vector(character'pos(' '),8);
          WHEN 17   =>  lcd_bus   <=  "10" & conv_std_logic_vector(character'pos('c'),8);
          WHEN 18   =>  lcd_bus   <=  "10" & conv_std_logic_vector(character'pos('o'),8);
          WHEN 19   =>  lcd_bus   <=  "10" & conv_std_logic_vector(character'pos('o'),8);
          WHEN 20   =>  lcd_bus   <=  "10" & conv_std_logic_vector(character'pos('l'),8);
          WHEN 21   =>  lcd_bus   <=  "10" & conv_std_logic_vector(character'pos('.'),8);
          WHEN 22   =>  lcd_bus   <=  "0011001100"; -- Mover Final da Segunda Linha
          WHEN 23   =>  lcd_bus   <=  "10" & (conv_std_logic_vector(character'pos('0'),8) + cooler_dez);
          WHEN 24   =>  lcd_bus   <=  "10" & (conv_std_logic_vector(character'pos('0'),8) + cooler_um);
          WHEN 25   =>  lcd_bus   <=  "1011011111"; -- Bola do ºC;
          WHEN 26   =>  lcd_bus   <=  "10" & conv_std_logic_vector(character'pos('C'),8);
          WHEN OTHERS => lcd_enable <= '0';
        END CASE;
      ELSE
        lcd_enable <= '0';
      END IF;
    END IF;
  END PROCESS;
  
END behavior;
