entity notv is
  port(
         data_in:  in bit_vector(0 to 3); 
        data_out: out bit_vector(0 to 3)
      );
end notv;

architecture behavior of notv is
  begin
       data_out <= not data_in;
  end;

