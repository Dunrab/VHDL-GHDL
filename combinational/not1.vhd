entity not1 is
  port(
         data_in :  in bit; 
        data_out : out bit
      );
end not1;

architecture a of not1 is
  begin
       data_out <= not data_in;
  end;

