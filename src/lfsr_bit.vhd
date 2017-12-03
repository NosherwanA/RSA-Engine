library ieee;
use ieee.std_logic_1164.all;

entity lfsr_bit is port (

	reset		: in std_logic;
	clk			: in std_logic;
	en			: in std_logic;
	seed		: in std_logic_vector(9 downto 0);
	rbit_out	: out std_logic

);
end lfsr_bit;

architecture rtl of lfsr_bit is

	signal lfsr 	: std_logic_vector (9 downto 0);
	signal feedback: std_logic;

begin

	-- option for LFSR size 4
   feedback <= not(lfsr(9) xor lfsr(2)); 

	
	--Shift register implementation
	sr_pr : process (clk)
	
		begin
		
		  if (rising_edge(clk)) then
		  
			 if (reset = '1') then
			 
				lfsr <= seed;
				
			 elsif (en = '1') then
			 
				lfsr <= lfsr(8 downto 0) & feedback;
				
			 end if; 
			 
		  end if;
		  
   end process sr_pr;

   rbit_out <= lfsr(9);


end architecture;