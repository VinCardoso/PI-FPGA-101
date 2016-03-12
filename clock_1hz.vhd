library ieee;
use ieee.std_logic_1164.all;

entity clock_1hz is
  port(
    clk_in        : in      std_logic;
    clk_out       : out     std_logic
  );
end clock_1hz;

architecture controller of clock_1hz is

begin

  process(clk_in)
    variable count : integer := 0; --event counter for timing
  begin

  if count < 12000000 then
    clk_out <= '0';
  elsif count > 12000000 then
    clk_out <= '1';
  end if;

  if(clk_in'event and clk_in = '1') then

    count := count + 1;

    if(count = 24000000) then
      count := 0;
    end if;

    end if;
  end process;
end controller;
