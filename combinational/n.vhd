entity not1 is
  port(
         data_in:  in bit; 
        data_out: out bit
      );
end not1;

architecture a of not1 is
  begin
    data_out <= not data_in;
  end;


entity n is
end n;

architecture a of n is

  signal x : bit;
  signal y : bit;

  component not1
    port(
           data_in :  in bit;
          data_out : out bit
        );
  end component;


  begin

    not10: not1 port map(x,y);

    process
      begin
        x <= '0';
        wait for 50 ns;
        x <= '1';
        wait for 50 ns;
      end process;

  end;
