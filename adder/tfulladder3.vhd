entity tfulladder3 is
  generic (
           n : integer := 8
          );
end;

architecture a of tfulladder3 is
  signal cin, a, b : bit_vector(n-1 downto 0);
  signal sum, cout : bit_vector(n-1 downto 0);
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
    f: fulladder port map ( cin(0), a(0), b(0), sum(0), cout(0));
    g: for i in 1 to n-1 generate 
         fi : fulladder port map (cout(i-1), a(i), b(i), sum(i), cout(i));
       end generate;
    process
      begin
        cin <= "00000000"; a <= "01010101"; b <= "10101010";
        wait for 10 ns;
        cin <= "00000000"; a <= "01111111"; b <= "10101010";
        wait for 10 ns;
      end process;
  end;
