entity and2 is
  port(
         x :  in bit_vector (1 downto 0); 
         y : out bit 
      );
end and2;

architecture behavior of and2 is
  function a (x : bit_vector) return bit is
    variable y : bit;
    begin
      y := '1';
      for i in 0 to 1 loop 
        y := y and x(i);
      end loop;
      return y;
    end;
  
  begin
    y <= a (x);
  end;

