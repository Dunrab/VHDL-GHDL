entity tfulladder is
end;

architecture a of tfulladder is
  signal cin0, a0, b0 : bit;
  signal cin1, a1, b1 : bit;
  signal sum0, cout0 : bit;
  signal sum1, cout1 : bit;
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
    fa0 : fulladder port map (cin0, a0, b0, sum0, cout0);
    fa1 : fulladder port map (cout0, a1, b1, sum1, cout1);
    process
      begin
        cin0 <= '0'; a0 <= '1'; b0 <= '0';
        cin1 <= '0'; a1 <= '0'; b1 <= '1';
        wait for 50 ns;
        cin0 <= '1'; a0 <= '1'; b0 <= '1';
        cin1 <= '0'; a1 <= '1'; b1 <= '0';
        wait for 50 ns;
      end process;
  end;
