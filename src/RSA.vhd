library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity RSA is
    port(
        clk                 : in std_logic;
        reset               : in std_logic;
        start               : in std_logic;
        busy                : out std_logic;
        done                : out std_logic;
        instruction         : in std_logic_vector(1 downto 0);
        message             : in std_logic_vector(7 downto 0);
        key                 : in std_logic_vector(7 downto 0);
        modulus             : in std_logic_vector(7 downto 0);
        result              : out std_logic_vector(7 downto 0)
    );
end RSA;

architecture internal of RSA is

    -- COMPONENTS USED
    component Modular_Exponentiator is
        port(
            base            : in std_logic_vector(7 downto 0);
            exponent        : in std_logic_vector(7 downto 0);
            modulus         : in std_logic_vector(7 downto 0);
            clk             : in std_logic;
            reset           : in std_logic;
            start           : in std_logic;
            busy            : out std_logic;
            result          : out std_logic_vector(7 downto 0);
            done            : out std_logic
        );
    end component;

    component MRT is
        port(
            numberToCheck               : in std_logic_vector (7 downto 0);
            clk                         : in std_logic;
            reset                       : in std_logic;
            start                       : in std_logic;
            isPrime                     : out std_logic;
            busy                        : out std_logic;
            done                        : out std_logic
        );
    end component;

    component PRNG is 
        port(
            clk		: in std_logic;
            rst		: in std_logic;
            enable	: in std_logic;
            output	: out std_logic_vector(7 downto 0)
        );
    end component;

    -- SIGNALS USED
    
    type State_Type is (S_RESET,
                        OPERATION_SELECTION,
                        PRIME_GENERATOR_START,
                        PRIME_GENERATOR_WAIT,
                        PRIME_GENERATOR_TEST_NUMBER,
                        PRIME_GENERATOR_TEST_RESULT,
                        IDLE
                        );

    signal curr_state       : State_Type;
    signal next_state       : State_Type;

    -- A) For Prime Number Genereator
    signal number_to_test   : std_logic_vector(7 downto 0);
    
    signal PRNG_output      : std_logic_vector(7 downto 0);
    signal PRNG_reset       : std_logic;

    signal MRT_input_num    : std_logic_vector(7 downto 0);
    signal MRT_reset        : std_logic;
    signal MRT_start        : std_logic;
    signal MRT_busy         : std_logic;
    signal MRT_done         : std_logic;
    signal MRT_isPrime      : std_logic;


begin
    --COMPONENTS TO BE USED
    Prime_Gen: PRNG
        port map(
            clk,
            PRNG_reset,
            clk, -- Generate a new number every clk cycle continuously
            PRNG_output
        );
    
    Test_Num: MRT
        port map(
            MRT_input_num,
            clk,
            MRT_reset,
            MRT_start,
            MRT_isPrime,
            MRT_busy,
            MRT_done 
        );

    --STATE MACHINE ITSELF
    Register_Section: process (clk, reset)
    begin
        if rising_edge(clk) then
            if (reset = '0') then
                curr_state <= S_RESET;
            else
                curr_state <= next_state;
            end if;
        end if;
    end process;
    
    Transition_Section: process(clk, curr_state)
    begin
        case curr_state is
            when S_RESET =>

            when OPERATION_SELECTION =>
            

            when PRIME_GENERATOR_START => 
                MRT_start <= '1';
                MRT_input_num <= PRNG_output;
                number_to_test <= PRNG_output;

                next_state <= PRIME_GENERATOR_WAIT;

            when PRIME_GENERATOR_WAIT =>
                MRT_start <= '0';
                if(MRT_done = '1') then
                    next_state <= PRIME_GENERATOR_TEST_NUMBER;
                else
                    next_state <= PRIME_GENERATOR_WAIT;
                end if;

            when PRIME_GENERATOR_TEST_NUMBER =>
                if(mm_isPrime = '1') then
                    next_state <= ; --TBD
                else
                    next_state <= PRIME_GENERATOR_START;
                end if;

        end case;
    end process;

    Decoder_Section: process(curr_state)
    begin

    end process;

end architecture;