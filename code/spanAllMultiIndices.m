%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Supplemental code for the paper "A Global Approach for Solving Edge-Matching Puzzles"
% Disclaimer: The code is provided as-is for academic use only and without any guarantees. 
%             Please contact the authors to report any bugs.
% Written by Shahar Kovalsky (http://www.wisdom.weizmann.ac.il/~shaharko/)
%        and Daniel Glasner   (https://sites.google.com/site/dglasner/)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [mi, mi_mat_ind, P3] = spanAllMultiIndices(mi_base, rotations, span_rank_one_flag, prm)
%
% this function expands the basic set of multi-indices mi_base to a set
% that is closed under rotations.
% if rank1_flag is set, it also expandes the set to include all rank one
% relaxation liftings (result of the outter product

% input:
% mi_base - dim x n matrix of degrees of base monomials
% rotation - cell array of rotation group members
% rank1_flag - is rank one matrix expansion required?
% prm - parameters
%
% output:
% mi - expanded list of monomial multi-indices
% mi_mat_ind - matrix referring to the respective elements of mi

%%
n_dims = size(mi_base,1);

%% P2 = [P1; R*P1; R^2*P1; ...]
P2 = [];
for n = 1:length(rotations),
    P2 = [P2, rotations{n}*mi_base];
end;

%% P3 = unique(P2)
P3 = uniqueUpToTolerance(P2', prm.tol)';

if ~span_rank_one_flag,
    mi = P3;
    mi_mat_ind = [];
else
    %% P_mat = P3*P3'
    P_mat_size = size(P3,2);
    P_mat = zeros(P_mat_size, P_mat_size, n_dims);
    for n = 1:n_dims,
        P_mat(:,:,n) = bsxfun(@plus, P3(n,:), P3(n,:)');
    end;
    
    %% P_vec = unique(P_mat)
    temp = reshape(P_mat, [P_mat_size^2 n_dims]);
    [P_vec, P_vec_to_mat, P_mat_to_vec] = uniqueUpToTolerance(temp, prm.tol);
    % P_mat_to_vec = reshape(P_mat_to_vec, P_mat_size, P_mat_size);
    mi = P_vec';
    mi_mat_ind = reshape(P_mat_to_vec, P_mat_size, P_mat_size);   
end;