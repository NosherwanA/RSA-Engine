library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_RSA is

end tb_RSA;

architecture test of tb_RSA is 

    component RSA is
        port(
            clk                 : in std_logic;
            reset               : in std_logic;
            start               : in std_logic;
            busy                : out std_logic;
            done                : out std_logic;
            instruction         : in std_logic_vector(1 downto 0);
            message             : in std_logic_vector(7 downto 0);
            key                 : in std_logic_vector(7 downto 0);
            in_modulus          : in std_logic_vector(7 downto 0);
            result              : out std_logic_vector(7 downto 0)
        );
    end component;

    signal in_clk               : std_logic;
    signal in_reset             : std_logic;
    signal in_start             : std_logic;
    signal out_busy             : std_logic;
    signal out_done             : std_logic;
    signal in_instruction       : std_logic_vector(1 downto 0);
    signal in_message           : std_logic_vector(7 downto 0);
    signal in_key               : std_logic_vector(7 downto 0);
    signal in_in_modulus        : std_logic_vector(7 downto 0);
    signal out_result           : std_logic_vector(7 downto 0);

    constant TIME_PERIOD        : time := 20 ns; 

begin

    DUT: RSA
        port map(
            in_clk,
            in_reset,
            in_start,
            out_busy,
            out_done, 
            in_instruction,
            in_message,
            in_key,
            in_in_modulus,
            out_result
        );

    clock_process: process
    begin
        in_clk <= '0';
        wait for (TIME_PERIOD/2);
        in_clk <= '1';
        wait for (TIME_PERIOD/2);
    end process;

    simulation_process: process
    begin
        in_reset <= '0';

        wait for (TIME_PERIOD/2);
        -- test for "00" instruction set
        in_instruction <= "00";

        wait until (out_done = '1');

        wait for (TIME_PERIOD/2);
        --encryption
        in_instructions <= "01";
        in_message <= "01011101";
        in_key <= "10000110";
        in_in_modulus <= "11001101";
        in_start <= '1';

        wait fot (3*(TIME_PERIOD/2));
        in_start <= '0';

        wait until (out_done = '1');
        
        wait for (TIME_PERIOD/2);
        -- decryption
        in_instruction <= "10";
        in_message <= "10110110";
        in_key <= "00110011";
        in_in_modulus <= "11000010"
        in_start <= '1';

        wait fot (3*(TIME_PERIOD/2));
        in_start <= '0';

        wait until (out_done = '1');

        wait for (TIME_PERIOD/2);
        -- Prime number generation
        in_instructions <= "11";
        in_start <= '1';

        wait fot (3*(TIME_PERIOD/2));
        in_start <= '0';

        wait until (out_done = '1');


    end process;

end architecture; 

-- p: 139
-- q: 97

-- n = pq = 139*97 = 13483

-- phi of n = (p-1)(q-1) = 13248

--