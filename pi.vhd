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
      clk_out                                     : out   std_logic;                      -- Clock para conversores (Temperatura e Luminosidade)
      turn_on_cooler                              : out   std_logic;                      -- Sinal para ligar cooler
      led_8                                       : out   std_logic_vector(7 downto 0);   -- Colunas LED
      led_5                                       : out   std_logic_vector(4 downto 0);   -- Linhas LED
      light_in                                    : in    std_logic_vector(7 downto 0)
    );
  end pi;

architecture behavior of pi is

-- Componentes

  -- LCD Controller 
    component lcd_controller is
      port(
        clk                                       : in    std_logic;                        -- Clock
        reset_n                                   : in    std_logic;                        -- active low reinitializes lcd
        lcd_enable                                : in    std_logic;                        -- latches data into lcd controller
        lcd_bus                                   : in    std_logic_vector(9 downto 0);     -- data and control signals
        busy                                      : out   std_logic;                        -- lcd controller busy/idle feedback
        rw, rs, e                                 : out   std_logic;                        -- read/write, setup/data, and enable for lcd
        lcd_data                                  : out   std_logic_vector(7 downto 0)
      );    -- data signals for lcd
    end component;

  -- Clock de 1 Hz
    component clock_1hz is
      port(
        clk_in                                    : in      std_logic;    -- Entrada de 12MHz
        clk_out                                   : out     std_logic     -- Saída de 1Hz
      );
    end component;

  -- Temperatura e Cooler
    component temperatura is
      port(
        clock_in                                  : in    std_logic;                      -- Entrade de 12MHz 
        temperature_in                            : in    std_logic_vector(7 downto 0);   -- Entrada temperatura em biário
        buttom_plus, buttom_minus                 : in    std_logic;                      -- Botões p/ Aumentar e Diminuir Nível
        temp_cem_asc, temp_dez_asc, temp_um_asc   : out   character;                      -- Saída de númeres temperatura em ASCII 
        lvl_cem_asc, lvl_dez_asc, lvl_um_asc      : out   character;                      -- Saída de númeres level em ASCII
        turn_on_cooler                            : out   std_logic                       -- Ligar ou Desligar Cooler
      );
    end component;

  -- Matriz LED
    component matriz_led is
      port(
        clk_in                                    : in    std_logic;
        buttom_plus, buttom_minus                 : in    std_logic;
        turn_on_matriz                            : in    std_logic;  
        led_8                                     : out   std_logic_vector(7 downto 0);
        led_5                                     : out   std_logic_vector(4 downto 0);
        num_effect_asc                            : out   character
      );
    end component;

  -- Luminosidade
    component luminosidade is
      port(
        clock_in                                  : in    std_logic;                      -- Entrade de 12MHz 
        light_in                                  : in    std_logic_vector(7 downto 0);   -- Entrada luminosidade em biário
        buttom_plus, buttom_minus                 : in    std_logic;                      -- Botões p/ Aumentar e Diminuir Nível
        lum_asc, lvl_lum_asc                      : out   character;                      -- Saída de lumiosidade e level em ASCII 
        turn_on_matriz                            : out   std_logic                       -- Ligar ou Desligar Matriz
      );
    end component;

-- Sinais
  signal  lcd_enable                                : std_logic;
  signal  lcd_bus                                   : std_logic_vector(9 downto 0);
  signal  lcd_busy                                  : std_logic;

  signal  temp_cem_asc, temp_dez_asc, temp_um_asc   : character;
  signal  lvl_cem_asc, lvl_dez_asc, lvl_um_asc      : character;
  signal  lum_asc, lvl_lum_asc                      : character;

  signal  buttom_plus_temp, buttom_minus_temp       : std_logic;
  signal  buttom_plus_matriz, buttom_minus_matriz   : std_logic;
  signal  buttom_plus_light, buttom_minus_light     : std_logic;

  signal  turn_on_matriz                            : std_logic;

  signal  num_effect_asc                            : character;

begin

-- Port Map
  lcd_control:  lcd_controller  port map(clk => clk, reset_n => '1', lcd_enable => lcd_enable, lcd_bus => lcd_bus, busy => lcd_busy, rw => rw, rs => rs, e => e, lcd_data => lcd_data);
  clock1:       clock_1hz       port map(clk, clk_out);
  temp:         temperatura     port map(clk, temp_in, buttom_plus_temp, buttom_minus_temp, temp_cem_asc, temp_dez_asc, temp_um_asc, lvl_cem_asc, lvl_dez_asc, lvl_um_asc, turn_on_cooler);
  matriz:       matriz_led      port map(clk, buttom_plus_matriz, buttom_minus_matriz, turn_on_matriz, led_8, led_5, num_effect_asc);
  light:        luminosidade    port map(clk, light_in, buttom_plus_light, buttom_minus_light, lum_asc, lvl_lum_asc, turn_on_matriz);

process(clk)

-- Variáveis

  -- Botões
    constant  buttom_time_clk                                                   : integer := 2000000;
    variable  buttom_change_cont, buttom_plus_cont, buttom_minus_cont           : integer;                                               

  -- Display
    variable  display                                                           : integer := 1;
    variable  char                                                              : integer   range 0 to 34         := 0;
    variable  d1,d2,d3,d4,d5,d6,d7,d8,d9,d10,d11,d12,d13,d14,d15,d16            : character;
    variable  d18,d19,d20,d21,d22,d23,d24,d25,d26,d27,d28,d29,d30,d31,d32,d33   : character := ' ';

begin 

if(clk'event and clk = '1') then

-- Inforações Display p/ Cada Estado
  case display is
  -- Temperatura
    when 1 =>
      d1  := 'T';               d18 := 'N';
      d2  := 'e';               d19 := 'i';
      d3  := 'm';               d20 := 'v';
      d4  := 'p';               d21 := 'e';
      d5  := '.';               d22 := 'l';
      d6  := ' ';               d23 := ' ';
      d7  := ' ';               d24 := ' ';
      d8  := ' ';               d25 := ' ';
      d9  := ' ';               d26 := ' ';
      d10 := ' ';               d27 := ' ';
      d11 := ' ';               d28 := ' ';
      d12 := temp_cem_asc;      d29 := lvl_cem_asc;
      d13 := temp_dez_asc;      d30 := lvl_dez_asc;
      d14 := temp_um_asc;       d31 := lvl_um_asc;
      d15 := '*';               d32 := '*';
      d16 := 'C';               d33 := 'C';
  -- Luminosidade
    when 2 =>
      d1  := 'L';               d18 := 'N';
      d2  := 'u';               d19 := 'i';
      d3  := 'z';               d20 := 'v';
      d4  := ' ';               d21 := 'e';
      d5  := ' ';               d22 := 'l';
      d6  := ' ';               d23 := ' ';
      d7  := ' ';               d24 := ' ';
      d8  := ' ';               d25 := ' ';
      d9  := ' ';               d26 := ' ';
      d10 := ' ';               d27 := ' ';
      d11 := ' ';               d28 := ' ';
      d12 := ' ';               d29 := ' ';
      d13 := ' ';               d30 := ' ';
      d14 := ' ';               d31 := ' ';
      d15 := ' ';               d32 := ' ';
      d16 := lum_asc;           d33 := lvl_lum_asc;
  -- Matriz LED
    when 3 =>
      d1  := 'E'; d18 := num_effect_asc;
      d2  := 'f'; d19 := ' ';
      d3  := 'e'; d20 := ' ';
      d4  := 'i'; d21 := ' ';
      d5  := 't'; d22 := ' ';
      d6  := 'o'; d23 := ' ';
      d7  := ' '; d24 := ' ';
      d8  := 'G'; d25 := ' ';
      d9  := 'r'; d26 := ' ';
      d10 := 'a'; d27 := ' ';
      d11 := 'f'; d28 := ' ';
      d12 := 'i'; d29 := ' ';
      d13 := 'c'; d30 := ' ';
      d14 := 'o'; d31 := ' ';
      d15 := ' '; d32 := ' ';
      d16 := ' '; d33 := ' ';
    when others => d1 := ' ';
  end case;

-- Botões - Mais, Menos e Alterar 

  -- Botão Alterar Display / Estado
    if(buttom_change = '0') then
      buttom_change_cont := buttom_change_cont + 1;
    else
      buttom_change_cont := 0;
    end if;

    if(buttom_change_cont = buttom_time_clk) then
      
      if(display = 3) then
        display := 1;
      else
        display := display + 1;
      end if;

      buttom_change_cont := 0;

    end if;
    
  -- Botão Mais
    if(buttom_plus = '0') then
      buttom_plus_cont := buttom_plus_cont + 1;
    elsif(buttom_plus = '1') then
      buttom_plus_cont := 0;
    end if;

    if(buttom_plus_cont = buttom_time_clk) then

      case display is
        when 1      =>  buttom_plus_temp    <= '0';
        when 2      =>  buttom_plus_light   <= '0';
        when 3      =>  buttom_plus_matriz  <= '0';
        when others =>  buttom_plus_temp    <= '1';
      end case;

      buttom_plus_cont := 0;

    else
      buttom_plus_temp    <=  '1';
      buttom_plus_light   <=  '1';
      buttom_plus_matriz  <=  '1';
    end if;

  -- Botão Menos
    if(buttom_minus = '0') then
      buttom_minus_cont := buttom_minus_cont + 1;
    elsif(buttom_minus = '1') then
      buttom_minus_cont := 0;
    end if;

    if(buttom_minus_cont = buttom_time_clk) then

      case display is
        when 1      =>  buttom_minus_temp     <= '0';
        when 2      =>  buttom_minus_light    <= '0';
        when 3      =>  buttom_minus_matriz   <= '0';
        when others =>  buttom_minus_temp     <= '1';
      end case;

      buttom_minus_cont := 0;

    else
      buttom_minus_temp     <=  '1';
      buttom_minus_light    <=  '1';
      buttom_minus_matriz   <=  '1';
    end if;
    
-- Lógica Display

  if(lcd_busy = '0' and lcd_enable = '0') then
    
    lcd_enable <= '1';

    if(char < 34) then
      char := char + 1;
    end if;

    if(char = 34) then
      char := 0;
    end if;

        case char is
          when 0        =>  lcd_bus     <=  "0010000000"; -- Primeira Linha;
          when 1        =>  lcd_bus     <=  "10" & conv_std_logic_vector(character'pos(d1),8);
          when 2        =>  lcd_bus     <=  "10" & conv_std_logic_vector(character'pos(d2),8);
          when 3        =>  lcd_bus     <=  "10" & conv_std_logic_vector(character'pos(d3),8);
          when 4        =>  lcd_bus     <=  "10" & conv_std_logic_vector(character'pos(d4),8);
          when 5        =>  lcd_bus     <=  "10" & conv_std_logic_vector(character'pos(d5),8);
          when 6        =>  lcd_bus     <=  "10" & conv_std_logic_vector(character'pos(d6),8);
          when 7        =>  lcd_bus     <=  "10" & conv_std_logic_vector(character'pos(d7),8);
          when 8        =>  lcd_bus     <=  "10" & conv_std_logic_vector(character'pos(d8),8);
          when 9        =>  lcd_bus     <=  "10" & conv_std_logic_vector(character'pos(d9),8);
          when 10       =>  lcd_bus     <=  "10" & conv_std_logic_vector(character'pos(d10),8);
          when 11       =>  lcd_bus     <=  "10" & conv_std_logic_vector(character'pos(d11),8);
          when 12       =>  lcd_bus     <=  "10" & conv_std_logic_vector(character'pos(d12),8);
          when 13       =>  lcd_bus     <=  "10" & conv_std_logic_vector(character'pos(d13),8);
          when 14       =>  lcd_bus     <=  "10" & conv_std_logic_vector(character'pos(d14),8);
          when 15       =>   
            if(d15 = '*') then
              lcd_bus   <= "1011011111";
            else
              lcd_bus   <= "10" & conv_std_logic_vector(character'pos(d15),8);
            end if;
          when 16       =>  lcd_bus     <=  "10" & conv_std_logic_vector(character'pos(d16),8);
          when 17       =>  lcd_bus     <=  "0011000000"; -- Segunda Linha;
          when 18       =>  lcd_bus     <=  "10" & conv_std_logic_vector(character'pos(d18),8);
          when 19       =>  lcd_bus     <=  "10" & conv_std_logic_vector(character'pos(d19),8);
          when 20       =>  lcd_bus     <=  "10" & conv_std_logic_vector(character'pos(d20),8);
          when 21       =>  lcd_bus     <=  "10" & conv_std_logic_vector(character'pos(d21),8);
          when 22       =>  lcd_bus     <=  "10" & conv_std_logic_vector(character'pos(d22),8);
          when 23       =>  lcd_bus     <=  "10" & conv_std_logic_vector(character'pos(d23),8);
          when 24       =>  lcd_bus     <=  "10" & conv_std_logic_vector(character'pos(d24),8);
          when 25       =>  lcd_bus     <=  "10" & conv_std_logic_vector(character'pos(d25),8);
          when 26       =>  lcd_bus     <=  "10" & conv_std_logic_vector(character'pos(d26),8);
          when 27       =>  lcd_bus     <=  "10" & conv_std_logic_vector(character'pos(d27),8);
          when 28       =>  lcd_bus     <=  "10" & conv_std_logic_vector(character'pos(d28),8);
          when 29       =>  lcd_bus     <=  "10" & conv_std_logic_vector(character'pos(d29),8);    
          when 30       =>  lcd_bus     <=  "10" & conv_std_logic_vector(character'pos(d30),8);
          when 31       =>  lcd_bus     <=  "10" & conv_std_logic_vector(character'pos(d31),8);
          when 32       =>
            if(d32 = '*') then
              lcd_bus   <= "1011011111";
            else
              lcd_bus   <= "10" & conv_std_logic_vector(character'pos(d32),8);
            end if;
          when 33       =>  lcd_bus     <=  "10" & conv_std_logic_vector(character'pos(d33),8);
          when others   =>  lcd_enable  <= '0';
        end case;

  else
    lcd_enable <= '0';
  end if;

end if;

end process;
  
end behavior;