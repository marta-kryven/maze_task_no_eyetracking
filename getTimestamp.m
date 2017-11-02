function t= getTimestamp() 
  c = clock;
  t = sprintf('%d/%d/%d %d:%d:%d:%3.0f', c(1), c(2), c(3), c(4), c(5), ...
       floor(c(6)), round(  (c(6) - floor(c(6)))*1000   ) );
end