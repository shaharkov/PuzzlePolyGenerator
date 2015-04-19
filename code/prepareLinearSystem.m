%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Supplemental code for the paper "A Global Approach for Solving Edge-Matching Puzzles"
% Disclaimer: The code is provided as-is for academic use only and without any guarantees. 
%             Please contact the authors to report any bugs.
% Written by Shahar Kovalsky (http://www.wisdom.weizmann.ac.il/~shaharko/)
%        and Daniel Glasner   (https://sites.google.com/site/dglasner/)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [A,b] = prepareLinearSystem(puzzle,multi_inds,eqs,prm)
% This function computes the linear system
%
% input:
% puzzle - is a struct which contains the information about the puzzle
% multi_inds - a n_dims x number of multi_inds array. Columns correspond to
% multi-indices. The assumtption is that they are union of orbits of the
% rotation group, the elements of this group are stored in
% puzzle.rotations.
% eqs - a column vector of structs with the equation parameters.
% prm - a struct with algorithm parameters
%
% output: 
% A - the linear system

% Allocate A, the size is (number of equations) x (number of pieces x  length(multi_inds))
A = zeros(length(eqs),size(multi_inds,2)*puzzle.n_pieces);

% Go over the rows of A and generate them one at a time
for row = 1:length(eqs);     
    % Each equation involves all pieces and all rotations     
    % Loop over rotations
    for q = 1:length(puzzle.rotations)
        % Apply the rotation to the multi index to figure out which is the
        % current multi index.
        cur_multi_ind = puzzle.rotations{q}'*multi_inds(:,eqs(row).mi_ind);
        % Compute exponent of product of edge offsets with current rotated multi_ind
        E = exp(cat(2,puzzle.edges(:).offset)'*cur_multi_ind);
        % Compute assignemnt of edges to the equations
        S = prepareEdgeAssignment(puzzle,q,eqs(row).angle,eqs(row).color,prm);
        % Sum edges in each piece to get "piece weights"
        W = accumarray(cat(1,puzzle.edges.piece)+1,E.*S,[puzzle.n_pieces,1]);     
        % Update A at the current row and the columns corresponding to the
        % curent multi index.
        col_inds = getColInds(puzzle,cur_multi_ind,multi_inds,prm);
        A(row,col_inds) = A(row,col_inds) + W';
    end
end

% Clear zero equations
row_nrm = sqrt(sum(A.*A,2));
discard = row_nrm < prm.tol;
A(discard,:) = [];

% If the call was for a linear system return A and b otherwise return a
% larger A
if 2 == nargout,
    [A,b] = homogenousToLinear(A,puzzle,multi_inds);    
end       

function col_inds = getColInds(puzzle,cur_multi_ind,multi_inds,prm)
% find the indices ot the columns corresponding the a multi index

ind = matchUpToTolerance(cur_multi_ind,multi_inds,prm.tol,1);
col_inds = (puzzle.n_pieces*(ind-1)+1):puzzle.n_pieces*(ind);

function [A,b] = homogenousToLinear(A,puzzle,multi_inds)

% Indicating the columns corresponding to the boundary varaibles.
is_boundary = false(1,size(A,2));
is_boundary(1:puzzle.n_pieces:size(A,2)) = true;

% figure out the values of the x variables corresponding to the boundary
boundary_x = exp(puzzle.boundary_location);
boundary_x = bsxfun(@power,boundary_x,multi_inds);
boundary_x = prod(boundary_x,1);
b = -A(:,is_boundary)*boundary_x';
% drop the irrelevant columns from A
A = A(:,~is_boundary);


