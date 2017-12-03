library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Modular_Multiplier is
    port(
        x           : in std_logic_vector(7 downto 0);
        y           : in std_logic_vector(7 downto 0);
        m           : in std_logic_vector(7 downto 0);
        result      : out std_logic_vector(7 downto 0);
        clk         : in std_logic;
        start       : in std_logic;
        reset       : in std_logic;
        done        : out std_logic;
        busy        : out std_logic
    );
end Modular_Multiplier;

architecture internal of Modular_Multiplier is

    component Wallace_Multiplier is
        port(
            a          : in std_logic_vector(7 downto 0);
            b          : in std_logic_vector(7 downto 0);
            product    : out std_logic_vector(15 downto 0)
        );
    end component;

    --State Machine Variables
    type State is  (S_START,
                    MULTIPLICATION,
                    COMPUTE_PROD_MOD,
                    REDUCTION,
                    CONV_REMAINDER,
                    S_DONE);

    signal curr_state       : State;
    signal next_state       : State;

    signal num1             : std_logic_vector(7 downto 0):= "00000000";
    signal num2             : std_logic_vector(7 downto 0):= "00000000";
    signal product          : std_logic_vector(15 downto 0);
    signal int_product      : integer:= 0;
    signal int_modulus      : integer:= 0;
    signal int_remainder    : integer:= 0;
    signal remainder        : std_logic_vector(7 downto 0);
    
begin

    Mulitplier: Wallace_Multiplier 
        port map(
            num1,
            num2,
            product
        );

    Register_Section: process (clk, reset, next_state)
        begin
            if rising_edge(clk) then
                if reset = '0' then
                    curr_state <= S_START;
                else
                    curr_state <= next_state;
                end if;
            end if;
            --if (reset = '0') then
            --    curr_state <= A;
            --elsif (rising_edge(clk)) then 
            --    curr_state <= next_state;
            --else
            --    curr_state <= curr_state;
            --end if;
        end process Register_Section;

    Transition_Section: process(clk, curr_state)
        begin
            case curr_state is
                when S_START =>
                    num1 <= "00000000";
                    num2 <= "00000000";

                    if (start = '1') then
                        next_state <= MULTIPLICATION;
                    else 
                        next_state <= S_START;
                    end if;
                
                when MULTIPLICATION =>
                    num1 <= x;
                    num2 <= y;

                    if (product = "0000000000000000") then 
                        if (x = "00000000") then
                            next_state <= COMPUTE_PROD_MOD;
                        elsif (y = "00000000") then 
                            next_state <= COMPUTE_PROD_MOD;
                        else
                            next_state <= MULTIPLICATION;
                        end if;
                    else
                        next_state <= COMPUTE_PROD_MOD;
                    end if;
                
                when COMPUTE_PROD_MOD =>
                    int_product <= to_integer(unsigned(product));
                    int_modulus <= to_integer(unsigned(m));

                    next_state <= REDUCTION;
                
                when REDUCTION =>
                    int_remainder <= int_product mod int_modulus;

                    next_state <= CONV_REMAINDER;

                when CONV_REMAINDER =>
                    remainder <= std_logic_vector(to_unsigned(int_remainder, 8));

                    next_state <= S_DONE;
                
                when S_DONE =>
                    if (reset = '0') then 
                        next_state <= S_START;
                    else 
                        next_state <= S_DONE;
                    end if;
                
                when others =>
                    next_state <= S_START; 

            end case;

        end process Transition_Section;

    Decoder_Section: process(curr_state)
        begin
            case curr_state is 
                when S_START =>
                    result <= "00000000";
                    done <= '0';
                    busy <= '0';
                
                when MULTIPLICATION =>
                    result <= "00000000";
                    done <= '0';
                    busy <= '1';
                
                when COMPUTE_PROD_MOD =>
                    result <= "00000000";
                    done <= '0';
                    busy <= '1';
                
                when REDUCTION =>
                    result <= "00000000";
                    done <= '0';
                    busy <= '1';

                when CONV_REMAINDER =>
                    result <= "00000000";
                    done <= '0';
                    busy <= '1';

                when S_DONE =>
                    result <= remainder;
                    done <= '1';
                    busy <= '0';
                    
                when others =>
                    result <= "00000000";
                    done <= '0';
                    busy <= '0';
            end case;
        end process Decoder_Section;
                
end architecture;