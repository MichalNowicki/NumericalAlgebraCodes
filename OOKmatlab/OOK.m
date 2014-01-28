function  flow  = OOK( c , u, l )
global visited;

m = size(u,1);

flow = zeros(m,m);
original = ones(m,m);
for i=1:m
    for j=1:m
        if (u(i,j) == l(i,j) && l(i,j) == 0)
            original(i,j) = 0;
        end;
    end;
end;

% if it is not possible, because u > l
if sum(sum( (u - l ) >= 0) ) ~= m*m
    return;
end;

% Starting zc(i,j) = w(i) - w(j) - c(i,j)
% since w(i) = w(j) = 0
zc = - c;


% Kilter numbers
K = zeros(m,m);
for i=1:m
    for j=1:m
        K(i,j) = KilterNumber(flow,u,l,i,j,zc(i,j));
    end;
end;

% main loop
while sum(sum(K)) ~= 0 % if exists one Kilter number > 0
    
   fprintf('Sum of Kilter numbers : %i\n', sum(sum(K)))
   % edge with max Kilter number (Kmax) and it's indexes (p,q)
   [Kmax,ind] = max(K(:));
   [p,q] = ind2sub(size(K),ind);
                
   % Constructing G' - residual network
   G = zeros(size(flow));
   
   % Constructing a residual graph where value of G(i,j) it the value of
   % additional, possible flow through this edge. 
   % Equations made from the figure on p. 575
   % [ can't be one if/elseif/../end since when l<flow<u and zc = 0, we
   % need to make 2 edges in G']
   % [ possible vectorization]
   for i=1:m
       for j=1:m
           % zc >= && flow < u
           if zc(i,j) >= 0 && flow(i,j) < u(i,j)
               G(i,j) = u(i,j) - flow(i,j);
           end;
           
           % zc <= 0 && flow > l
           if zc(i,j) <= 0 && flow(i,j) > l(i,j)
               G(j,i) = flow(i,j) - l(i,j);
           % zc <= 0 && flow < l    
           elseif zc(i,j) < 0 && flow(i,j) < l(i,j)
               G(i,j) = l(i,j) - flow(i,j);
           % zc > 0 && flow > u
           elseif zc(i,j) > 0 && flow(i,j) > u(i,j)
               G(j,i) = flow(i,j) - u(i,j);
           end;
           
       end;
   end;
   G
   input('RESIDUAL');
   
   % Looking for flow from q to p with value Kmax to bring (p,q) in-Kilter
   % state
   % G
   %fprintf('G(p,q): %d, flow(p,q): %d, zc(p,q): %d, u(p,q): %d, l(p,q): %d\n',G(p,q),flow(p,q), zc(p,q), u(p,q), l(p,q));
   %fprintf('G(q,p): %d, flow(q,p): %d, zc(q,p): %d, u(q,p): %d, l(q,p): %d\n',G(q,p),flow(q,p), zc(q,p), u(q,p), l(q,p));
   G(p,q) = 0;
   
   % DFS is a recursion, so global 'visited' helps to keep, that each node
   % is visited only once. [It is not efficient and it is not thread-safe]
   visited = zeros(m,1);
   [maxres, list] = DFS(G,q,p,10000,q);
   
   % if there exists a flow that minimalizes K(p,q)
   if ( sum(list == p) == 1 )
       
       display('Primal phase');
       %fprintf('Kmax: %d, maxres: %d\n',Kmax,maxres);
       % We can enlarge flow by maximal flow of the residual cycle
       flow (p,q) = flow(p,q) + min(Kmax,maxres);
       
       % Recalculating Kilter Number for (p,q) [has to be smaller that
       % previously]
       K(p,q) = KilterNumber(flow,u,l, p, q, zc(p,q));
       %fprintf('New value of Kmax: %d\n',K(p,q));
       
       % Recalculating Kilter numbers for the rest of edges in residual
       % cycle
       for i=1: (length(list)-1)
           a = list(i);
           b = list(i+1);
           if ( original(a,b) == 1)
               flow(a,b) = flow(a,b) + min(Kmax,maxres);
               K(a,b) = KilterNumber(flow,u,l, a, b, zc(a,b));
           else
               flow(b,a) = flow(b,a) - min(Kmax,maxres);
               K(b,a) = KilterNumber(flow,u,l, b, a, zc(b,a));
           end;
       end;
   % if there is no cycle to make K(p,w) lower
   % Dual phase - relaxation of constraints
   else
       display('Dual phase');
       visited
       % Finding X -> set of all nodes accesible from q in residual graph G
       % _
       % X -> rest of nodes
       % Since we kept track of nodes we visit in {0,1} table, we can use
       % it to calculate a set if indeces where we reached in our DFS
       Xlist = find(visited == 1);
       
       % Some large number to represent inf
       % [need to be better implemented for larger networks]
       theta1 = 99999;
       theta2 = 99999;
       for i = 1:m
           for j=1:m
                % checking only indices between node in X and node not in X
                
                % i in X, j not in X, zc(i,j) < 0 and flow(i,j) <= u(i,j)
                if isempty( find(Xlist == i,1) ) == false ... %belongs to X
                    && isempty( find(Xlist == j,1 ) ) == true ...% do not belong to X
                    && zc(i,j) < 0 && flow(i,j) <= u(i,j)
					display('theta1');
					i
					j
                    theta1 = min ( theta1, -zc(i,j));
                    
                % i not in X, i in X, zc(i,j) > 0 and flow(i,j) >= l(i,j)    
                elseif isempty( find(Xlist == i,1) ) == true ... %does not belong to X
                    && isempty( find(Xlist == j,1 ) ) == false ...%belongs to X
                    && zc(i,j) > 0 && flow(i,j) >= l(i,j)
                
                    theta2 = min ( theta2, zc(i,j));

                end;
           end;
       end;
       
       display('thetas');
       theta1
       theta2
       % dual problem has infinite solution -> primal has none
       if theta1 == 99999
           display('No feasible solution to primal problem');
           break;
       else
           theta = min(theta1,theta2);
           
           % Lets relax some w(i)'s -> changing zc -> changing Kilter
           % number's 
           
           % + 0 if i,j in X or i,j not in X
           % + theta if i in X, j not in X
           % - theta if i not in X, j in X
           for i=1:m
               for j=1:m
                   % i in X, j not in X
                   if isempty( find(Xlist == i,1) ) == false ...
                      && isempty ( find(Xlist == j,1)) == true
                  
                        zc(i,j) = zc(i,j) + theta;
                        K(i,j) = KilterNumber(flow,u,l, i, j, zc(i,j));
                   % i not in X, j in X
                   elseif isempty( find(Xlist == i,1) ) == true ...
                      && isempty ( find(Xlist == j,1)) == false 
                  
                        zc(i,j) = zc(i,j) - theta;
                        K(i,j) = KilterNumber(flow,u,l, i, j, zc(i,j));
                   end;
               end;
           end;
       end;
   end; 
   flow
   zc
   input('');
end;


end

