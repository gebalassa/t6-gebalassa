----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07.10.2018 23:10:10
-- Design Name: 
-- Module Name: mux - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity mux is
    Port ( A : in STD_LOGIC_vector(7 downto 0);
           B : in STD_LOGIC_vector(7 downto 0);
           C : in STD_LOGIC_vector(7 downto 0);
           D : in STD_LOGIC_vector(7 downto 0);
           c1 : in STD_LOGIC;
           c2 : in STD_LOGIC;
           Q : out STD_LOGIC_vector(7 downto 0));
end mux;

architecture Behavioral of mux is

signal s1 : std_logic;
signal s2 : std_logic;
signal s3 : std_logic_vector(7 downto 0);
signal s4 : std_logic_vector(7 downto 0);
signal s5 : std_logic_vector(7 downto 0);
signal s6 : std_logic_vector(7 downto 0);

begin

s1 <= not c1;
s2 <= not c2;
s3(0) <= A(0) and s1 and s2;
s3(1) <= A(1) and s1 and s2;
s3(2) <= A(2) and s1 and s2;
s3(3) <= A(3) and s1 and s2;
s3(4) <= A(4) and s1 and s2;
s3(5) <= A(5) and s1 and s2;
s3(6) <= A(6) and s1 and s2;
s3(7) <= A(7) and s1 and s2;
s4(0) <= B(0) and c1 and s2;
s4(1) <= B(1) and c1 and s2;
s4(2) <= B(2) and c1 and s2;
s4(3) <= B(3) and c1 and s2;
s4(4) <= B(4) and c1 and s2;
s4(5) <= B(5) and c1 and s2;
s4(6) <= B(6) and c1 and s2;
s4(7) <= B(7) and c1 and s2;
s5(0) <= C(0) and s1 and c2;
s5(1) <= C(1) and s1 and c2;
s5(2) <= C(2) and s1 and c2;
s5(3) <= C(3) and s1 and c2;
s5(4) <= C(4) and s1 and c2;
s5(5) <= C(5) and s1 and c2;
s5(6) <= C(6) and s1 and c2;
s5(7) <= C(7) and s1 and c2;
s6(0) <= D(0) and c1 and c2;
s6(1) <= D(1) and c1 and c2;
s6(2) <= D(2) and c1 and c2;
s6(3) <= D(3) and c1 and c2;
s6(4) <= D(4) and c1 and c2;
s6(5) <= D(5) and c1 and c2;
s6(6) <= D(6) and c1 and c2;
s6(7) <= D(7) and c1 and c2;
Q <= s3 or s4 or s5 or s6;

end Behavioral;
