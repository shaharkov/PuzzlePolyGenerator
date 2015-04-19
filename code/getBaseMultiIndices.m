%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Supplemental code for the paper "A Global Approach for Solving Edge-Matching Puzzles"
% Disclaimer: The code is provided as-is for academic use only and without any guarantees. 
%             Please contact the authors to report any bugs.
% Written by Shahar Kovalsky (http://www.wisdom.weizmann.ac.il/~shaharko/)
%        and Daniel Glasner   (https://sites.google.com/site/dglasner/)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function mi_base = getBaseMultiIndices(base_degs)
%
% this function gets a vector of maximal degrees base_degs, and outputs all
% <= non-mixing multi-indices

mi_base = zeros(size(base_degs));
col = 1;
for n = 1:size(base_degs,1),
    mi_base(n,col+(1:base_degs(n))) = 1:base_degs(n);
    col = col + base_degs(n);
end;