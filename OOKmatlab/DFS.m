function [ maxf, maxp ] = DFS( G,p,q,fl, path)
% Returns maximal flow (maxf) from p to q and path for this flow (maxp)
global visited;

m = size(G,1);
visited(p) = 1;
maxp = path;
maxf = 0;

% for all neighbours
for i=1:m
    % if there exist an edge and node has not been yet visited
    if (G(p,i) ~= 0 && visited(i) == 0)
        
        % if we found the path to the end
        if( i == q )
            maxp = [path i];
            maxf = min(fl,G(p,i));
        % if not -> look further
        else
            % it's min, since the flow from (q,p) is the minimal flow of
            % capacity of all edges 
            [f, pa] = DFS(G,i,q,min(fl,G(p,i)),[path i]);
            
            % compare all my descendantes
            if ( f > maxf )
                maxf = f;
                maxp = pa;
            end;
        end;
    end;
end;
end

