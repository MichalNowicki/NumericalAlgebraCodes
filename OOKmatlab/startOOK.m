% Starting OOK
% Setup appropriate
% C is cost matrix of size mxm
% Upper limit is matrix of size mxm (put only positives numbers or 0)
% Lower limit is matrix of size mxm (put only positives numbers or 0)


c = [0 0 0 0 10 12 13 8 14 19 0;
     0 0 0 0 15 18 12 16 19 20 0;
     0 0 0 0 17 16 13 14 10 18 0;
     0 0 0 0 19 18 20 21 12 13 0;
     0 0 0 0 0 0 0 0 0 0 0;
     0 0 0 0 0 0 0 0 0 0 0;
     0 0 0 0 0 0 0 0 0 0 0;
     0 0 0 0 0 0 0 0 0 0 0;
     0 0 0 0 0 0 0 0 0 0 0;
     0 0 0 0 0 0 0 0 0 0 0;
     0 0 0 0 0 0 0 0 0 0 0
     ];
 
u = [0 0 0 0 18 18 18 18 18 18 0;
     0 0 0 0 22 22 22 22 22 22 0;
     0 0 0 0 39 39 39 39 39 39 0;
     0 0 0 0 14 14 14 14 14 14 0;
     0 0 0 0 0 0 0 0 0 0 10;
     0 0 0 0 0 0 0 0 0 0 11;
     0 0 0 0 0 0 0 0 0 0 13;
     0 0 0 0 0 0 0 0 0 0 20;
     0 0 0 0 0 0 0 0 0 0 24;
     0 0 0 0 0 0 0 0 0 0 15;
     18 22 39 14 0 0 0 0 0 0 0
     ];
  
l = [0 0 0 0 0 0 0 0 0 0 0;
     0 0 0 0 0 0 0 0 0 0 0;
     0 0 0 0 0 0 0 0 0 0 0;
     0 0 0 0 0 0 0 0 0 0 0;
     0 0 0 0 0 0 0 0 0 0 10;
     0 0 0 0 0 0 0 0 0 0 11;
     0 0 0 0 0 0 0 0 0 0 13;
     0 0 0 0 0 0 0 0 0 0 20; 
     0 0 0 0 0 0 0 0 0 0 24;
     0 0 0 0 0 0 0 0 0 0 15;
     18 22 39 14 0 0 0 0 0 0 0];

% The result is the optimal flow matrix for given task
flow = OOK(c,u,l)
koszt = sum(sum(c.*flow))