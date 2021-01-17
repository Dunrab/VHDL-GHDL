entity tfulladder2 is
end;

architecture a of tfulladder2 is
  signal cin, a, b : bit_vector(3 downto 0);
  signal sum, cout : bit_vector(3 downto 0);
  component fulladder is
    port(
           cin :  in bit;
             a :  in bit;
             b :  in bit;
          sum : out bit;
          cout : out bit
        );
  end component;
  begin
    fa0 : fulladder port map ( cin(0), a(0), b(0), sum(0), cout(0));
    fa1 : fulladder port map (cout(0), a(1), b(1), sum(1), cout(1));
    fa2 : fulladder port map (cout(1), a(2), b(2), sum(2), cout(2));
    fa3 : fulladder port map (cout(2), a(3), b(3), sum(3), cout(3));
    process
      begin
        cin <= "0000"; a <= "0101"; b <= "1010";
        wait for 50 ns;
        cin <= "0000"; a <= "0111"; b <= "1010";
        wait for 50 ns;
      end process;
  end;
