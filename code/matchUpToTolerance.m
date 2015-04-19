%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Supplemental code for the paper "A Global Approach for Solving Edge-Matching Puzzles"
% Disclaimer: The code is provided as-is for academic use only and without any guarantees. 
%             Please contact the authors to report any bugs.
% Written by Shahar Kovalsky (http://www.wisdom.weizmann.ac.il/~shaharko/)
%        and Daniel Glasner   (https://sites.google.com/site/dglasner/)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function ind = matchUpToTolerance(X,x,tol,expected_match_num)
% finds the columns in X for which all the elements are the same as x up to tolerance

dd = abs(bsxfun(@minus,X,x)) < tol;
ind = find(all(dd,1));
if nargin > 3
    if length(ind)~=expected_match_num,
        error('Problem matching the number of matches is %d instead of the expected %d.\n',length(ind),expected_match_num);
    end
end



