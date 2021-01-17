entity and0 is
end and0;

architecture a of and0 is

  signal x : bit;
  signal y : bit;
  signal z : bit;


  begin

    z <= x and y;

    process
      begin
        x <= '0'; y <= '0';
        wait for 10 ns;
        x <= '0'; y <= '1';
        wait for 10 ns;
        x <= '1'; y <= '0';
        wait for 10 ns;
        x <= '1'; y <= '1';
        wait for 10 ns;
      end process;

  end;
