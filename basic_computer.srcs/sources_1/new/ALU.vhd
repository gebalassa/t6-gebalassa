library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ALU is
    Port ( a        : in  std_logic_vector (15 downto 0);   -- Primer operando.
           b        : in  std_logic_vector (15 downto 0);   -- Segundo operando.
           sop      : in  std_logic_vector (2 downto 0);    -- Selector de la operación.
           c        : out std_logic;                        -- Señal de 'carry'.
           z        : out std_logic;                        -- Señal de 'zero'.
           n        : out std_logic;                        -- Señal de 'nagative'.
           result   : out std_logic_vector (15 downto 0));  -- Resultado de la operación.
end ALU;

architecture Behavioral of ALU is

component AddSu16 
    Port ( a        : in  std_logic_vector (15 downto 0);
           b        : in  std_logic_vector (15 downto 0);
           ci       : in  std_logic;
           sub      : in  std_logic;
           s        : out std_logic_vector (15 downto 0);
           co       : out std_logic);
    end component;

signal s : std_logic_vector(15 downto 0);
signal alu_result   : std_logic_vector(15 downto 0);
signal sub          : std_logic;
signal co           : std_logic;

begin

sub <= not sop(2) and not sop(1) and sop(0);
          
with sop select
  alu_result <= s when "000",
                s when "001",
                a and b when "010",
                a or  b when "011",
                a xor b when "100",
                not a when "101",
                '0' & a(15 downto 1) when "110",
                a(14 downto 0) & '0' when "111";

with sop select
     c      <=  co when "000",
                co when "001",
                a(0) when "110",
                a(15)when "111",
                '0' when others;

with alu_result select
     z      <=  '1' when "0000000000000000",
                '0' when others;                

with sub select
     n      <=  not co when '1',
                '0' when others;  


result <= alu_result;

inst_AddSu16: AddSu16 port map(
        a      =>a,
        b      =>b,
        ci     =>sub,
        sub    =>sub,
        s      =>s,
        co     =>co
    );
    
end Behavioral;
