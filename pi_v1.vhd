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

ENTITY pi IS
  PORT(
      clk, change_buttom    : IN    STD_LOGIC;                      -- Clock e Botão de troca
      rw, rs, e             : OUT   STD_LOGIC;                      --read/write, setup/data, and enable for lcd
      lcd_data              : OUT   STD_LOGIC_VECTOR(7 DOWNTO 0));  --data signals for lcd

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
BEGIN

  --instantiate the lcd controller
  dut: lcd_controller
    PORT MAP(clk => clk, reset_n => '1', lcd_enable => lcd_enable, lcd_bus => lcd_bus, busy => lcd_busy, rw => rw, rs => rs, e => e, lcd_data => lcd_data);
  
  PROCESS(clk)
    VARIABLE char  :  INTEGER RANGE 0 TO 30 := 0;
    
  BEGIN
    IF(clk'EVENT AND clk = '1') THEN
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
          WHEN 7    =>  lcd_bus   <=  "10" & conv_std_logic_vector(character'pos('3'),8);
          WHEN 8    =>  lcd_bus   <=  "10" & conv_std_logic_vector(character'pos('2'),8);
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
          WHEN 23   =>  lcd_bus   <=  "10" & conv_std_logic_vector(character'pos('4'),8);
          WHEN 24   =>  lcd_bus   <=  "10" & conv_std_logic_vector(character'pos('5'),8);
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
