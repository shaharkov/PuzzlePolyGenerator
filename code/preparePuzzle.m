%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Supplemental code for the paper "A Global Approach for Solving Edge-Matching Puzzles"
% Disclaimer: The code is provided as-is for academic use only and without any guarantees. 
%             Please contact the authors to report any bugs.
% Written by Shahar Kovalsky (http://www.wisdom.weizmann.ac.il/~shaharko/)
%        and Daniel Glasner   (https://sites.google.com/site/dglasner/)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function puzzle = preparePuzzle(n_dims,pieces,border,n_rots,edge_pitch,boundary_location,prm)

% This function prepares a puzzle "algebraic" representation from the
% pieces
%
% input:
% n_dims - the puzzle's geometric dimsion
% pieces - each column is a piece
% border - a cell array
%
% output:
% puzzle a struct with the follwoing fields:
% n_dims, n_pieces and edges


% puzzle type
puzzle.type = 'ideal';

% how many pieces
puzzle.n_pieces = size(pieces,2)+1;

% dimension of puzzle
puzzle.n_dims = n_dims;

% puzzle size
puzzle.size = [size(border{2},2) size(border{1},2)];

% edges
puzzle.edges = prepareEdges(n_dims,pieces,border,prm);

% rotations
[puzzle.rotations,puzzle.rotation_angles] = generateRotationGroup(n_dims,n_rots);

% boundary location
puzzle.boundary_location = boundary_location;

% save default (raster) ordering of pieces
if n_dims==1,
    puzzle.t0 = puzzle.boundary_location + 0:(puzzle.n_pieces-2);
elseif n_dims==2,
    [grid_x grid_y] = ndgrid(0:(length(border{2})-1), 0:(length(border{1})-1));
    puzzle.t0 = bsxfun(@plus,puzzle.boundary_location,[grid_x(:) grid_y(:)]');
end;

% rescale puzzle - edge pitch
puzzle.edge_pitch = 1;
puzzle = rescalePuzzle(puzzle, edge_pitch);

% get puzzle bounds (rotations taken into account)
[puzzle.boundary.lb puzzle.boundary.ub] = getPuzzleBounds(puzzle);

% get feasible puzzle locations
puzzle.feasible_locations = getFeasibleLocations(puzzle);


 