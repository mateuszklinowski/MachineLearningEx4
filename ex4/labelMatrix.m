function m = labelMatrix(y,k)
  m = length(y);  m = repmat(y,1,k) == repmat(1:k,m,1);
endfunction
