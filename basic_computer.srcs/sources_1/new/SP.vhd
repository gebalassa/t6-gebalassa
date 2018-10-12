library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;

entity SP is
    Port ( 
           clock    : in  std_logic;
           up       : in  std_logic;
           down     : in  std_logic;
           dataout  : out std_logic_vector (11 downto 0));
end SP;

architecture Behavioral of SP is

signal sp : std_logic_vector(11 downto 0) := (others => '1');

begin

sp_prosses : process (clock)
    begin
      if (rising_edge(clock)) then
        if (up = '1') then
            sp <= sp + 1;
        elsif (down = '1') then
            sp <= sp - 1;
        end if;
      end if;
    end process;
    
dataout <= sp;

end Behavioral;
