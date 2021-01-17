entity a is
end;

architecture a of a is
  signal nibble1, nibble2, nibble3 : bit_vector (3 downto 0);
  signal a,b,c : bit;
  signal     d : bit_vector (2 downto 0);
  begin
    nibble3 <= nibble1 and nibble2; 
    d <= a & b & c;
    --a <= and nibble1;
    process
      begin
        a <= '1';       b <= '0';       c <= '1'; 
        nibble1 <= "1010";
        nibble2 <= "1111";
        wait for 100 ns;
      end process;
  end;
