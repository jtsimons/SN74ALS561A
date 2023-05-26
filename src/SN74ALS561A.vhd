library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity SN74ALS561A is
	port (
		-- Inputs
		ACLR, ALOAD, SCLR, SLOAD, ENT, ENP, CLK, OE: in std_logic;
		ABCD: in std_logic_vector(3 downto 0);
		-- Outputs
		RCO, CCO: out std_logic;
		Q: out std_logic_vector(3 downto 0)
	);
end SN74ALS561A;

architecture BEHAVIORAL of SN74ALS561A is

	-- Assign counter and temp CO signals
	signal ctr: unsigned(3 downto 0) := (others => '0');
	signal CO: std_logic := '0';

begin

	-- Counter functionality process
	counter: process(CLK, ENP, ENT, SLOAD, SCLR, ABCD, ACLR, ALOAD)
	begin
		-- Async CLR
		if (ACLR = '0') then
			ctr <= (others => '0');
		-- Async LOAD
		elsif (ALOAD = '0') then
			ctr <= unsigned(ABCD);
		-- High CLK cases
		elsif (rising_edge(CLK)) then
			-- Sync CLR
			if (SCLR = '0') then
				ctr <= (others => '0');
			-- Sync LOAD
			elsif (SLOAD = '0') then
				ctr <= unsigned(ABCD);
			-- Counting function enabled
			elsif (ENP = '1' and ENT = '1') then
				ctr <= ctr + 1;
			end if;
		end if;
	end process counter;

	-- RCO/CCO high when count is at max value (15)
	CO <= '1' when (ctr = 15 and (ENP = '1' and ENT = '1')) else '0';
	-- Q contains as many bits as the ctr's value when OE enabled, else in high-impedance state
	Q <= std_logic_vector(ctr) when OE = '0' else (others => 'Z');
	-- Place temp value back into RCO and CCO
	RCO <= CO;
	CCO <= CO and not(CLK);

end BEHAVIORAL;
