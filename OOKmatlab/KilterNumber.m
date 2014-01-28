function val = KilterNumber( flow,u,l, i, j, zc)
    
    % Concatenated if's, but main idea is to calculate how far from the
    % feasible (optimal) flow we are
    % Best to debug with figure from the book
    if zc < 0 || (zc == 0 && flow(i,j) < l(i,j))
       val = abs(flow(i,j) - l(i,j));
    elseif zc > 0 || (zc == 0 && flow(i,j) > u(i,j))
       val = abs(flow(i,j) - u(i,j));
    else
       val = 0;
    end;  
    
    
    if zc < 0
       val2 = abs(flow(i,j) - l(i,j));
    elseif zc > 0
       val2 = abs(flow(i,j) - u(i,j));
    elseif zc == 0 && flow(i,j) > u(i,j)
       val2 = abs(flow(i,j) - u(i,j));
    elseif zc == 0 && flow(i,j) < l(i,j)
       val2 = abs(flow(i,j) - l(i,j));
    else
       val2 = 0;
    end; 
    
    if val ~= val2
        fprintf('FAIL: %d vs %d\n',val, val2);
    end;
    
end

