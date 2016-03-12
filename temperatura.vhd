library ieee;
use ieee.std_logic_1164.all;

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

begin

  process(clk_in)


  
  begin

  if(clk_in'event and clk_in= '1') then

    
  end if;
    
  end process;

end behavior;
