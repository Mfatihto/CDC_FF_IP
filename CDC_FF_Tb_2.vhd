library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity CDC_FF_Tb_2 is
end CDC_FF_Tb_2;

architecture Behavioral of CDC_FF_Tb_2 is

    -- Constants for the testbench
    constant N : integer := 5;              -- Number of flip-flops in the chain
    constant PERIOD : time := 10 ns;        -- Period of the clock signal in ns

    -- Signal declarations
    signal D   : STD_LOGIC := '0';          -- Data input
    signal Clk : STD_LOGIC := '0';          -- Clock signal
    signal Rst : STD_LOGIC := '0';          -- Reset signal
    signal Q   : STD_LOGIC := '0';          -- Output from the DUT
    signal Expected_Q : STD_LOGIC := '0';   -- Expected output
    constant ASYNC_RST_VALUE : boolean := false;     -- Set this to test asynchronous or synchronous reset

    -- Instantiate the flip-flop array as the DUT
    component CDC_FF_IP
        generic (
            N : integer := 5;
            ASYNC_RST : boolean := true
        );
        Port (
            D   : in  STD_LOGIC;
            Clk : in  STD_LOGIC;
            Rst : in  STD_LOGIC;
            Q   : out STD_LOGIC
        );
    end component;

    -- Procedure to apply reset and check result
    procedure apply_reset(signal Rst: out std_logic; signal Q: in std_logic; expected_value: std_logic) is
    begin
		-- Async Reset Test
		Rst <= '1';
		wait for PERIOD * 2;		-- Applying non-clock period wait
		if Q /= expected_value then
			report "Test failed: Async Reset did not set Q to " & std_logic'image(expected_value) severity error;
		end if;
		-- Deassert reset
		Rst <= '0';
    end procedure;

begin
    -- Instantiate the DUT (Design Under Test)
    DUT: CDC_FF_IP
        generic map (
            N => N,               -- Set the number of flip-flops
            ASYNC_RST => ASYNC_RST_VALUE -- Set the reset type (asynchronous or synchronous)
        )
        port map (
            D   => D,
            Clk => Clk,
            Rst => Rst,
            Q   => Q
        );

    -- Clock generation: PERIOD ns
    Clk_Process : process
    begin
        while true loop
            Clk <= '0';
            wait for PERIOD / 2;
            Clk <= '1';
            wait for PERIOD / 2;
        end loop;
    end process;

   -- Stimulus and self-checking with loops
    Stimulus_Process : process
        type boolean_array is array (0 to 1) of boolean;  		-- Define a boolean array
        variable i : integer := 0;  							-- Loop variable
    begin
        -- Initialize inputs
        D <= '0';
        Expected_Q <= '0';
        wait for PERIOD * 2;

		if ASYNC_RST_VALUE = true then
			report "Testing asynchronous reset";
		else
			report "Testing synchronous reset";
		end if;
		
		-- Assert D and wait enough for Q to be set
		D <= '1';
		wait for PERIOD * N;
		Expected_Q <= '1';

		-- Test reset
		apply_reset(Rst, Q, '0');
		
		if Q /= Expected_Q then
			report "Test failed: Q did not capture D=1 correctly" severity error;
		end if;

		-- Apply stimulus: set D to '1' and check propagation
		D <= '1';
		wait for N * PERIOD;  -- Wait enough time for Q to update
		Expected_Q <= '1';
		if Q /= Expected_Q then
			report "Test failed: Q did not capture D=1 correctly" severity error;
		end if;

		-- Set D to '0' and wait for it to propagate through the flip-flop chain
		D <= '0';
		for i in 1 to N loop
			wait for PERIOD;
			Expected_Q <= '0';  -- After N cycles, Q should return to 0
			if Q /= Expected_Q then
				report "Test failed: Q did not capture D=0 correctly after " & integer'image(i) & " clock cycles" severity error;
			end if;
		end loop;

		-- Check reset after propagating values
		report "Applying reset after propagation test";
		apply_reset(Rst, Q, '0');	-- since apply_reset procdure should be resetting the FFs making the Q -> '0', expected_value should be '0'


        -- End the simulation
        report "All tests passed successfully." severity note;
        wait;
    end process;

end Behavioral;
