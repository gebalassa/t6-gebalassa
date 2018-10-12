library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;

entity Status is
    Port ( 
           clock    : in  std_logic;
           c        : in  std_logic;
           z        : in  std_logic;
           n        : in  std_logic;
           dataout  : out std_logic_vector (2 downto 0));
end Status;

architecture Behavioral of Status is

begin

status_prosses : process (clock)
    begin
      if (rising_edge(clock)) then
        dataout(0) <= z;
        dataout(1) <= n;
        dataout(2) <= c;
      end if;
    end process;
    
end Behavioral;
