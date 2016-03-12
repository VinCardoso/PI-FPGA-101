---------------------------------------
  --
  -- Projeto Integrador 1
  -- Vinicius Cardoso e Yuri Soika
  -- Sistemas Eletrônicos
  -- IFSC Florianópolis
  --
  -------------------------------------

-- Bibliotecas
  library ieee;
  use ieee.std_logic_1164.all;
  use ieee.std_logic_arith.all;
  use ieee.std_logic_unsigned.all;

-- Entidade
  entity pi is
    port(
      clk                                         : in    std_logic;                      -- Clock de 12 MHz
      rw, rs, e                                   : out   std_logic;                      -- read/write, setup/data, e enable do LCD
      lcd_data                                    : out   std_logic_vector(7 downto 0);   -- Sinal de dados do Display
      buttom_plus, buttom_minus, buttom_change    : in    std_logic;                      -- Botões +, - e alterar do gabinete
      temp_in                                     : in    std_logic_vector(7 downto 0);   -- Entrada binário da temperatura
      clk_out, turn_on_cooler                     : out   std_logic;                      -- Sinal para ligar cooler
      led_8                                       : out   std_logic_vector(7 downto 0);
      led_5                                       : out   std_logic_vector(4 downto 0)
    );
  end pi;

architecture behavior of pi is

-- Componentes

  -- LCD Controller 
    component lcd_controller is
      port(
        clk        : in    std_logic;                        -- Clock
        reset_n    : in    std_logic;                        -- active low reinitializes lcd
        lcd_enable : in    std_logic;                        -- latches data into lcd controller
        lcd_bus    : in    std_logic_vector(9 downto 0);     -- data and control signals
        busy       : out   std_logic;                        -- lcd controller busy/idle feedback
        rw, rs, e  : out   std_logic;                        -- read/write, setup/data, and enable for lcd
        lcd_data   : out   std_logic_vector(7 downto 0)
      );    -- data signals for lcd
    end component;

  -- Clock de 1 Hz
    component clock_1hz is
      port(
        clk_in    : in      std_logic;    -- Entrada de 12MHz
        clk_out   : out     std_logic     -- Saída de 1Hz
      );
    end component;

  -- Temperatura e Cooler
    --component temperature is
    --  port(
    --    clock_in                                                : in    std_logic;                      -- Entrade de 1Hz 
    --    temperature_in                                          : in    std_logic_vector(7 downto 0);   -- Entrade da temperatura em biário
    --    turn_on_cooler                                          : out   std_logic;                      -- Saída para ligar cooller
    --    temp_display_cem, temp_display_dez, temp_display_um     : out   std_logic_vector(9 downto 0);   -- Números para mostrar display temperatura atual
    --    level_display_cem, level_display_dez, level_display_um  : out   std_logic_vector(9 downto 0)    -- Números para mostrar display nível de temperatura
    --  );
    --end component;

  -- Matriz LED
    component matriz_led is
      port(
        clk_in        : in    std_logic;
        led_8         : out   std_logic_vector(7 downto 0);
        led_5         : out   std_logic_vector(4 downto 0)
      );
    end component;

-- Sinais

  signal  lcd_enable                                              : std_logic;
  signal  lcd_bus                                                 : std_logic_vector(9 downto 0);
  signal  lcd_busy                                                : std_logic;
  signal  temp_display_cem, temp_display_dez, temp_display_um     : std_logic_vector(9 downto 0);
  signal  level_display_cem, level_display_dez, level_display_um  : std_logic_vector(9 downto 0);

begin

-- Port Map
  
  lcd_control:  lcd_controller  port map(clk => clk, reset_n => '1', lcd_enable => lcd_enable, lcd_bus => lcd_bus, busy => lcd_busy, rw => rw, rs => rs, e => e, lcd_data => lcd_data);
  clock1:       clock_1hz       port map(clk, clk_out);
  matriz:       matriz_led      port map(clk, led_8, led_5);

process(clk)

-- Variáveis
  
  -- Display

    variable  char                                                      : integer range 0 to 30 := 0;

  -- Temperatura
    variable  temp_display_cem, temp_display_dez, temp_display_um       : std_logic_vector(9 downto 0);
    variable  lvl_display_cem, lvl_display_dez, lvl_display_um          : std_logic_vector(9 downto 0);
    variable  temperature_int, temp_cem_int, temp_dez_int, temp_um_int  : integer;
    variable  lvl_cem_int, lvl_dez_int, lvl_um_int                      : integer;
    variable  temp_cem_bin, temp_dez_bin, temp_um_bin                   : std_logic_vector(7 downto 0);
    variable  lvl_cem_bin, lvl_dez_bin, lvl_um_bin                      : std_logic_vector(7 downto 0);
    variable  temp_turn_cool_on                                         : integer range 1 to 128 := 25;
    constant  debounce_delay                                            : integer := 2000000;
    variable  debounce_cont_plus, debounce_cont_minus                   : integer := 0;

begin 

if(clk'event and clk = '1') then

-- Cálculos de Temperatura

  -- Calculos e Conversões da Temperatura

    -- Temperatura
      temperature_int     := conv_integer(temp_in);
      temperature_int     := temperature_int / 2;
      -- Dividir Decimal
      temp_cem_int        := temperature_int / 100;         
      temp_dez_int        := (temperature_int mod 100) / 10;
      temp_um_int         := (temperature_int mod 100) mod 10;
      -- Decimal p/ Binário
      temp_cem_bin        := conv_std_logic_vector(temp_cem_int,8);
      temp_dez_bin        := conv_std_logic_vector(temp_dez_int,8);
      temp_um_bin         := conv_std_logic_vector(temp_um_int,8);
      -- Adicionar a ASCII a variável
      temp_display_cem    := "10" & (conv_std_logic_vector(character'pos('0'),8) + temp_cem_bin);
      temp_display_dez    := "10" & (conv_std_logic_vector(character'pos('0'),8) + temp_dez_bin);
      temp_display_um     := "10" & (conv_std_logic_vector(character'pos('0'),8) + temp_um_bin);

    -- Nível de Temperatura
      -- Dividir Decimal Nível
      lvl_cem_int         := temp_turn_cool_on / 100;         
      lvl_dez_int         := (temp_turn_cool_on mod 100) / 10;
      lvl_um_int          := (temp_turn_cool_on mod 100) mod 10;
      -- Decimal p/ Binário Nível
      lvl_cem_bin         := conv_std_logic_vector(lvl_cem_int,8);
      lvl_dez_bin         := conv_std_logic_vector(lvl_dez_int,8);
      lvl_um_bin          := conv_std_logic_vector(lvl_um_int,8);
      -- Adicionar a ASCII a variável
      lvl_display_cem     := "10" & (conv_std_logic_vector(character'pos('0'),8) + lvl_cem_bin);
      lvl_display_dez     := "10" & (conv_std_logic_vector(character'pos('0'),8) + lvl_dez_bin);
      lvl_display_um      := "10" & (conv_std_logic_vector(character'pos('0'),8) + lvl_um_bin);

    -- Lógica ligar cooler
      if(temperature_int > temp_turn_cool_on) then
        turn_on_cooler <= '1';
      elsif(temperature_int < temp_turn_cool_on) then
        turn_on_cooler <= '0';
      end if;

    -- Botões - Alterar Nível de Temperatura
      
      -- Aumentar Temperatura
        if(buttom_plus = '0') then
          debounce_cont_plus := debounce_cont_plus + 1;
        elsif(buttom_plus = '1') then
          debounce_cont_plus := 0;
        end if;

        if(debounce_cont_plus = debounce_delay) then
          temp_turn_cool_on := temp_turn_cool_on + 1;
          debounce_cont_plus := 0;
        end if;

      -- Diminuir Temperatura
        if(buttom_minus = '0') then
          debounce_cont_minus := debounce_cont_minus + 1;
        elsif(buttom_minus = '1') then
          debounce_cont_minus := 0;
        end if;

        if(debounce_cont_minus = debounce_delay) then
          temp_turn_cool_on := temp_turn_cool_on - 1;
          debounce_cont_minus := 0;
        end if;
    
-- Lógica Display

  if(lcd_busy = '0' and lcd_enable = '0') then
    
    lcd_enable <= '1';

    if(char < 30) then
      char := char + 1;
    end if;

    if(char = 30) then
      char := 0;
    end if;

    case char is
      when 1        =>  lcd_bus     <=  "10" & conv_std_logic_vector(character'pos('T'),8);
      when 2        =>  lcd_bus     <=  "10" & conv_std_logic_vector(character'pos('e'),8);
      when 3        =>  lcd_bus     <=  "10" & conv_std_logic_vector(character'pos('m'),8);
      when 4        =>  lcd_bus     <=  "10" & conv_std_logic_vector(character'pos('p'),8);
      when 5        =>  lcd_bus     <=  "10" & conv_std_logic_vector(character'pos('.'),8);
      when 6        =>  lcd_bus     <=  "0010001011"; -- Mover para fim da linha;
      when 7        =>  lcd_bus     <=  temp_display_cem;
      when 8        =>  lcd_bus     <=  temp_display_dez;
      when 9        =>  lcd_bus     <=  temp_display_um;
      when 10       =>  lcd_bus     <=  "1011011111"; -- Bola do ºC;
      when 11       =>  lcd_bus     <=  "10" & conv_std_logic_vector(character'pos('C'),8);
      when 12       =>  lcd_bus     <=  "0011000000"; -- Pular Linha;
      when 13       =>  lcd_bus     <=  "10" & conv_std_logic_vector(character'pos('L'),8);
      when 14       =>  lcd_bus     <=  "10" & conv_std_logic_vector(character'pos('i'),8);
      when 15       =>  lcd_bus     <=  "10" & conv_std_logic_vector(character'pos('g'),8);
      when 16       =>  lcd_bus     <=  "10" & conv_std_logic_vector(character'pos('a'),8);
      when 17       =>  lcd_bus     <=  "10" & conv_std_logic_vector(character'pos(' '),8);
      when 18       =>  lcd_bus     <=  "10" & conv_std_logic_vector(character'pos('c'),8);
      when 19       =>  lcd_bus     <=  "10" & conv_std_logic_vector(character'pos('o'),8);
      when 20       =>  lcd_bus     <=  "10" & conv_std_logic_vector(character'pos('o'),8);
      when 21       =>  lcd_bus     <=  "10" & conv_std_logic_vector(character'pos('l'),8);
      when 22       =>  lcd_bus     <=  "10" & conv_std_logic_vector(character'pos('.'),8);
      when 23       =>  lcd_bus     <=  "0011001011"; -- Mover Final da Segunda Linha
      when 24       =>  lcd_bus     <=  lvl_display_cem;
      when 25       =>  lcd_bus     <=  lvl_display_dez;
      when 26       =>  lcd_bus     <=  lvl_display_um;
      when 27       =>  lcd_bus     <=  "1011011111"; -- Bola do ºC;
      when 28       =>  lcd_bus     <=  "10" & conv_std_logic_vector(character'pos('C'),8);
      when others   =>  lcd_enable  <= '0';
    end case;

  else
    lcd_enable <= '0';
  end if;

end if;

end process;
  
end behavior;