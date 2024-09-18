----------------------------------------------------------------------------------
-- Company: Personal Work
-- Engineer: Mehmet Fatih Turkoglu
-- 
-- Create Date: 25.08.2024 01:00:44
-- Design Name: Chained FF Design IP
-- Module Name: CDC_FF_IP - Behavioral
-- Project Name: Generic Chained FF
-- Target Devices: --
-- Tool Versions: --
-- Description: --
-- 
-- Dependencies: --
-- 
-- Revision: --
-- Revision 0.01 - File Created
-- Additional Comments: --
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity CDC_FF_IP is
    generic  (
        N : integer := 2;						-- Number of flip-flops in the chain
		ASYNC_RST : boolean := true				-- true --> async rst, false --> sync rst
	);
    Port ( Clk : in STD_LOGIC;
           D : in STD_LOGIC;                    -- Input of the first FF in the chain
           Q : out STD_LOGIC;                   -- Output of the last FF in the chain
           Rst : in STD_LOGIC);                 -- Reset input that resets every FF in the chain
end CDC_FF_IP;

architecture Behavioral of CDC_FF_IP is
    signal FFs : STD_LOGIC_VECTOR(N-1 downto 0); -- Intermediate flip-flop states
begin

process(Clk, Rst) begin
    if (ASYNC_RST = true and Rst = '1') then
        FFs <= (others => '0');  		-- Asynchronous reset all flip-flops
    elsif rising_edge(Clk) then
        if (ASYNC_RST = false and Rst = '1') then
            FFs <= (others => '0');  	-- Synchronous reset on clock edge
        else
            FFs(0) <= D;  				-- First flip-flop takes the input D
            for i in 1 to N-1 loop
                FFs(i) <= FFs(i-1);  	-- Each flip-flop takes the output of the previous one
            end loop;
        end if;
    end if;
end process;

Q <= FFs(N-1);                          -- Assignment of the Q to the last chain FFs Q output

end Behavioral;


