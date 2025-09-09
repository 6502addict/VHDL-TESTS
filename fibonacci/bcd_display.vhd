library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity bcd_display is
    port (
        data : in  std_logic_vector(23 downto 0);  -- Binary input
        dig0 : out std_logic_vector(7 downto 0);   -- Digit 0 (ones)
        dig1 : out std_logic_vector(7 downto 0);   -- Digit 1 (tens) 
        dig2 : out std_logic_vector(7 downto 0);   -- Digit 2 (hundreds)
        dig3 : out std_logic_vector(7 downto 0);   -- Digit 3 (thousands)
        dig4 : out std_logic_vector(7 downto 0);   -- Digit 4 (ten thousands)
        dig5 : out std_logic_vector(7 downto 0)    -- Digit 5 (hundred thousands)
    );
end bcd_display;

architecture rtl of bcd_display is

    -- Function to convert 4-bit BCD to 7-segment display
    function bcd_to_7seg(bcd : std_logic_vector(3 downto 0)) return std_logic_vector is
        variable seg : std_logic_vector(7 downto 0);
    begin
        case bcd is
            when "0000" => seg := "11000000"; -- 0
            when "0001" => seg := "11111001"; -- 1
            when "0010" => seg := "10100100"; -- 2
            when "0011" => seg := "10110000"; -- 3
            when "0100" => seg := "10011001"; -- 4
            when "0101" => seg := "10010010"; -- 5
            when "0110" => seg := "10000010"; -- 6
            when "0111" => seg := "11111000"; -- 7
            when "1000" => seg := "10000000"; -- 8
            when "1001" => seg := "10010000"; -- 9
            when others => seg := "11111111"; -- Blank for invalid BCD
        end case;
        return seg;
    end function;

    -- Function to convert binary to BCD using double dabble algorithm
    function binary_to_bcd(binary : std_logic_vector(23 downto 0)) return std_logic_vector is
        variable bcd : std_logic_vector(31 downto 0) := (others => '0');
        variable temp : std_logic_vector(55 downto 0); -- 24 binary + 32 BCD bits
        variable i : integer;
    begin
        temp(23 downto 0) := binary;
        temp(55 downto 24) := (others => '0');
        
        for i in 0 to 23 loop
            -- Check each BCD digit and add 3 if >= 5
            if temp(27 downto 24) >= "0101" then
                temp(27 downto 24) := std_logic_vector(unsigned(temp(27 downto 24)) + 3);
            end if;
            if temp(31 downto 28) >= "0101" then
                temp(31 downto 28) := std_logic_vector(unsigned(temp(31 downto 28)) + 3);
            end if;
            if temp(35 downto 32) >= "0101" then
                temp(35 downto 32) := std_logic_vector(unsigned(temp(35 downto 32)) + 3);
            end if;
            if temp(39 downto 36) >= "0101" then
                temp(39 downto 36) := std_logic_vector(unsigned(temp(39 downto 36)) + 3);
            end if;
            if temp(43 downto 40) >= "0101" then
                temp(43 downto 40) := std_logic_vector(unsigned(temp(43 downto 40)) + 3);
            end if;
            if temp(47 downto 44) >= "0101" then
                temp(47 downto 44) := std_logic_vector(unsigned(temp(47 downto 44)) + 3);
            end if;
            if temp(51 downto 48) >= "0101" then
                temp(51 downto 48) := std_logic_vector(unsigned(temp(51 downto 48)) + 3);
            end if;
            if temp(55 downto 52) >= "0101" then
                temp(55 downto 52) := std_logic_vector(unsigned(temp(55 downto 52)) + 3);
            end if;
            
            -- Shift left
            temp := temp(54 downto 0) & '0';
        end loop;
        
        return temp(55 downto 24);
    end function;

    signal bcd_digits : std_logic_vector(31 downto 0);
    
begin
    bcd_digits <= binary_to_bcd(data);
    
    dig0 <= bcd_to_7seg(bcd_digits(3 downto 0));   -- Ones
    dig1 <= bcd_to_7seg(bcd_digits(7 downto 4));   -- Tens
    dig2 <= bcd_to_7seg(bcd_digits(11 downto 8));  -- Hundreds
    dig3 <= bcd_to_7seg(bcd_digits(15 downto 12)); -- Thousands
    dig4 <= bcd_to_7seg(bcd_digits(19 downto 16)); -- Ten thousands
    dig5 <= bcd_to_7seg(bcd_digits(23 downto 20)); -- Hundred thousands
    
end rtl;