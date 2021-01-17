entity fulladder is
  port(
         cin :  in bit;
           a :  in bit;
           b :  in bit;
         sum : out bit;
        cout : out bit
      );
end;

architecture a of fulladder is
  begin
    sum <= cin xor a xor b;
    cout <= (a and b) or (a and cin) or (b and cin);
  end;
