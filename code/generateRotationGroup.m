%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Supplemental code for the paper "A Global Approach for Solving Edge-Matching Puzzles"
% Disclaimer: The code is provided as-is for academic use only and without any guarantees. 
%             Please contact the authors to report any bugs.
% Written by Shahar Kovalsky (http://www.wisdom.weizmann.ac.il/~shaharko/)
%        and Daniel Glasner   (https://sites.google.com/site/dglasner/)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [R,theta] = generateRotationGroup(n_dims, n_rots)
%
% this function returns a cell array whose elements are the cyclic group of
% n_rots rotations over n_dims dimensions

if n_dims==1,
    if n_rots==1,
        R = {1};
        theta = 0;
    elseif n_rots==2,
        R = {1, -1};
        theta = [0;pi];
    else
        error('genRotationGroup: illegal number of rotations for n_dims=1')
    end;
elseif n_dims==2,
    R = cell(n_rots,1);
    theta = linspace(0, 2*pi, n_rots+1);
    theta = theta(1:end-1)';
    for n = 1:n_rots,
        R{n} = [cos(theta(n)) -sin(theta(n)); sin(theta(n)) cos(theta(n))];
    end;    
else
    error('genRotationGroup: not yet implemented for n_dims~=1,2')
end;

