
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity CU is
    Port (
            op           : in   std_logic_vector (16 downto 0);
            status       : in   std_logic_vector (2 downto 0);
            mux_a        : out  std_logic_vector (1 downto 0);
            mux_b        : out  std_logic_vector (1 downto 0);
            load_a       : out  std_logic;
            load_b       : out  std_logic;
            write_ram    : out  std_logic;
            load_out     : out  std_logic;
            mux_datain   : out  std_logic;
            mux_address  : out  std_logic_vector (1 downto 0);
            mux_pc       : out  std_logic;
            alu_sop      : out  std_logic_vector (2 downto 0);
            load_pc      : out  std_logic;          
            sp_up        : out  std_logic;          
            sp_down      : out  std_logic
          );
end CU;

architecture Behavioral of CU is

signal conditional : std_logic;

begin

alu_sop <= op(5 downto 3);
mux_datain <= op(8);
mux_pc <= op(14);
sp_up  <= op(15);
sp_down <= op(16);
mux_address <=  op(7 downto 6);

with op(13) and not op(14) select
    mux_a <= op(10 downto 9) when '0',
             (others => '0') when others ;
    
with op(13) and not op(14) select
    mux_b <= op(12 downto 11) when '0',
              (others => '0') when others ;

with op(2 downto 0)  select
    load_a <= '1' when "001",
             '0' when others ;

with op(2 downto 0)  select
    load_b <= '1' when "010",
             '0' when others ;
             
with op(2 downto 0)  select
    write_ram <=    '1' when "011",
              '0' when others ;

with op(2 downto 0)  select
    load_out <=    '1' when "100",
              '0' when others;

with op(13)  select
    load_pc <= conditional when '1',
          '0' when others ;
          
with op(12 downto 9) select
    conditional <= '1' when "0000",
                   status(0) when "0001",
                   not status(0) when "1001",
                   not status(0) and not status(1) when "0010",
                   not status(1) when "0011",
                   status(1) when "0100",
                   status(0) xor  status(1) when "0101",
                   status(2) when "0111",
                  '0' when others;
                  
end Behavioral;
