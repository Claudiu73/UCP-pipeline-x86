----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04.12.2023 03:26:54
-- Design Name: 
-- Module Name: X86_Register - Behavioral
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity X86_Register is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           write_enable : in STD_LOGIC; -- avem nevoie si de write si de read enable pentru ca pentru operatie trebuie citata valoarea si cand trebuie salvata trebuie scrisa in registru
           write_data : in STD_LOGIC_VECTOR(31 downto 0);
           read_enable : in STD_LOGIC;
           read_data : out STD_LOGIC_VECTOR(31 downto 0));
end X86_Register;

architecture Behavioral of X86_Register is
    signal reg : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    
    -- aceasta este o desciere generala a unui registru x86. 
    -- functionalitatea unui registru se face prin citire si scriere de date
    -- registrul primeste informatia din ROM si in functie de 
    -- instructiunea curenta, se vor apela registrii. De aici informatiile
    -- se vor trimite in functie de specificatia instructiunii.
    
begin
    process(clk, rst)
    begin
        if rst = '1' then
            reg <= (others => '0');
        elsif rising_edge(clk) then
            if write_enable = '1' then
                reg <= write_data;
            end if;
        end if;
    end process;

    process(read_enable)
    begin
        if read_enable = '1' then
            read_data <= reg;
        end if;
    end process;

end Behavioral;
