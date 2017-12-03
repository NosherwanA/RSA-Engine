library ieee;
use ieee.std_logic_1164.all;
use work.lfsr_pkg.all;

entity prng_10_bit is port(

	clk		: in std_logic;
	rst		: in std_logic;
	enable	: in std_logic;
	output	: out std_logic_vector(9 downto 0)

);
end prng_10_bit;

architecture internal of prng_10_bit is
	
	component lfsr_bit is port (

		reset		: in std_logic;
		clk		: in std_logic;
		en			: in std_logic;
		seed		: in std_logic_vector(9 downto 0);
		rbit_out	: out std_logic

	);
	end component;
	
	--From Random.org
	
	signal seed0:		std_logic_vector(9 downto 0):= "0000111010";
	signal seed1:		std_logic_vector(9 downto 0):= "1111011100";
	signal seed2:		std_logic_vector(9 downto 0):= "0100100101";
	signal seed3:		std_logic_vector(9 downto 0):= "0110110101";
	signal seed4:		std_logic_vector(9 downto 0):= "0101110111";
	signal seed5:		std_logic_vector(9 downto 0):= "1001110110";
	signal seed6:		std_logic_vector(9 downto 0):= "1111111011";
	signal seed7:		std_logic_vector(9 downto 0):= "1101001001";
	signal seed8:		std_logic_vector(9 downto 0):= "1110011110";
	signal seed9:		std_logic_vector(9 downto 0):= "0000001100";
	


begin
	
	lfsr0	: lfsr_bit port map( rst, clk, enable, seed0, output(9));
	lfsr1	: lfsr_bit port map( rst, clk, enable, seed2, output(8));
	lfsr2	: lfsr_bit port map( rst, clk, enable, seed7, output(7));
	lfsr3	: lfsr_bit port map( rst, clk, enable, seed1, output(6));
	lfsr4	: lfsr_bit port map( rst, clk, enable, seed9, output(5));
	lfsr5	: lfsr_bit port map( rst, clk, enable, seed4, output(4));
	lfsr6	: lfsr_bit port map( rst, clk, enable, seed6, output(3));
	lfsr7	: lfsr_bit port map( rst, clk, enable, seed3, output(2));
	lfsr8	: lfsr_bit port map( rst, clk, enable, seed8, output(1));
	lfsr9	: lfsr_bit port map( rst, clk, enable, seed5, output(0));


end architecture;