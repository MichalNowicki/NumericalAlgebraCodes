n = 3;
J = linspace(0,1,100);
% refset
x = linspace(0,1,n);


ile = 0;
while(1)
    lambda = ones(n,1);
    frefset = myf(x);
    
    for i=1:n
        for j=1:n
            if(i~=j)
                lambda(i) = lambda(i) / (x(i) - x(j));
            end;
        end;
    end;     

    % error
    delta = sign(lambda(1)) * (frefset * lambda) / sum(abs(lambda));
    H = abs(delta);
    
     % constructing lev ref poly
    for i=1:n
        if mod(i,2) == 1
            frefset(i) = myf(x(i)) + delta;
        else
            frefset(i) = myf(x(i)) - delta;
        end;
    end;

    glo = zeros(100,1);
    sgn = zeros(100,1);
    for i=1:100
        var = J(i) == x;
            
        if any(var)
            l = frefset(var);
            m = 1;
        else
            l = sum ( lambda .* frefset' ./ ( J(i) - x' ) ) ;
            m = sum ( lambda ./ ( J(i) - x' ));
        end;

        if l/m >= 0
            sgn(i) = 1;
        end;
        glo(i) = abs(myf(J(i)) - l/m);
    end;

    
    [a,b] = max(glo);
    a
    H
    if a == H
        break;
    else
        value = J(b);
        % sgn(b)
        poz = 0;
        
        if ( value < x(1) )
            if (sgn(b) == 1)
                x(1) = value;    
            else
                x(n) = value;
            end;
        elseif (value > x(n))
            if (mod(n,2) == sgn(b))
                x(n) = value;
            else
                x(1) = value;
            end;
        else
            for i=1:n
                if(x(i) <= value &&  value <= x(i+1))
                    if( mod(i,2) == sgn(b) )
                        x(i) = value;
                    else
                        x(i+1) = value;
                    end;
                    break;
                end;
            end;
        end;
    end;
    
    
    if(ile == 2 )
        break;
    end;
    
    ile = ile + 1;
end;

%max(myf(J) - 