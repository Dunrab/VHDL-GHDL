entity a2 is
end;

architecture a of a2 is
  signal x : bit_vector(3 downto 0);
  type arr is array (0 to 3) of bit_vector(3 downto 0);
  signal y : arr;
  begin
    y(0) <= "1010";
    x <= y(0);
    process
      begin
        wait for 100 ns;
      end process;
  end;
