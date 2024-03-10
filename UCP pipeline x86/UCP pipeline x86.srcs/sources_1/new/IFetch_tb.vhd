----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 16.12.2023 12:27:12
-- Design Name: 
-- Module Name: IFetch_tb - Behavioral
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

entity IFetch_tb is
-- Test bench-ul nu are porturi
end IFetch_tb;

architecture Behavioral of IFetch_tb is

    -- Instantia?i UUT (Unit Under Test)
    component IFetch is
    Port (
        clk: in std_logic;
        rst: in std_logic;
        en: in std_logic;
        PCinc: out std_logic_vector(31 downto 0)
     );
    end component;
    
    -- Semnale pentru UUT
    signal clk: std_logic := '0';
    signal rst: std_logic := '0';
    signal en: std_logic := '0';
    signal PCinc: std_logic_vector(31 downto 0);

    -- Instantia?i UUT
    begin
        uut: IFetch
        port map (
            clk => clk,
            rst => rst,
            en => en,
            PCinc => PCinc
        );

    -- Genereazã semnalul de ceas
    clk_process :process
    begin
        clk <= '0';
        wait for 10 ns;
        clk <= '1';
        wait for 10 ns;
    end process;

    -- Stimuli de test
    stimuli_process: process
    begin
        -- Reset
        rst <= '1';
        wait for 20 ns;
        rst <= '0';
        
        -- Enable the IFetch
        en <= '1';
        
        -- A?teptãm pentru câteva cicluri de ceas
        wait for 100 ns;
        
    end process;

end Behavioral;