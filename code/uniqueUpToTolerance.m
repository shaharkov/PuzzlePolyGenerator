%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Supplemental code for the paper "A Global Approach for Solving Edge-Matching Puzzles"
% Disclaimer: The code is provided as-is for academic use only and without any guarantees. 
%             Please contact the authors to report any bugs.
% Written by Shahar Kovalsky (http://www.wisdom.weizmann.ac.il/~shaharko/)
%        and Daniel Glasner   (https://sites.google.com/site/dglasner/)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [B_s,I_s,J_s] = uniqueUpToTolerance(X,tol,loc)
% clusters the rows of X up to tolerance 

if nargin < 3,
    loc = 'last';
end

dists = squareform(pdist(X));
connected = abs(dists) < tol;
[S,J] = myGraphConnComp(connected);
S = (1:S)';
B = zeros(size(S,1),size(X,2));
I = zeros(size(S));
for i = 1:size(S,1),
    B(i,:) = mean(X(J==S(i),:),1);
    I(i) = find(J==S(i),1,loc);
end
% sort
[B_s, B_s_ind] = sortrows(B);
[~, B_s_ind_inv] = sort(B_s_ind);
I_s = I(B_s_ind);
J_s = B_s_ind_inv(J);





function [S,C] = myGraphConnComp(A)

[p,dummy,r] = dmperm(A);
S = length(r)-1;
C = zeros(size(A,1),1);

for i = 1:S,
    C(p(r(i):r(i+1)-1)) = i;
end


