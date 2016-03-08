LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY clock_1hz IS
  PORT(
    clk_in        : IN      STD_LOGIC;
    clk_out       : OUT     STD_LOGIC
  );
END clock_1hz;

ARCHITECTURE controller OF clock_1hz IS

BEGIN

  PROCESS(clk_in)
    VARIABLE count : INTEGER := 0; --event counter for timing
  BEGIN

  if count < 12000000 then
    clk_out <= '0';
  elsif count > 12000000 then
    clk_out <= '1';
  end if;

  IF(clk_in'EVENT and clk_in = '1') THEN

    count := count + 1;

    if(count = 24000000) then
      count := 0;
    end if;

    END IF;
  END PROCESS;
END controller;
