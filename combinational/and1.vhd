entity and1 is
  port(
         a :  in bit; 
         b :  in bit;
         c : out bit
      );
end and1;

architecture behavior of and1 is
  begin
      --c <= '0' when a='0' and b='0' else
      c <= '0' when a&b = "00" else
           '0' when a&b = "01" else
           '0' when a&b = "10" else
           '1' when a&b = "11";
  end;

