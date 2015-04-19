%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Supplemental code for the paper "A Global Approach for Solving Edge-Matching Puzzles"
% Disclaimer: The code is provided as-is for academic use only and without any guarantees. 
%             Please contact the authors to report any bugs.
% Written by Shahar Kovalsky (http://www.wisdom.weizmann.ac.il/~shaharko/)
%        and Daniel Glasner   (https://sites.google.com/site/dglasner/)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function puzzle = rescalePuzzle(puzzle, edge_pitch)

% update puzzle edge_pitch
puzzle.edge_pitch = puzzle.edge_pitch * edge_pitch;

% rescale all edges
for n = 1:length(puzzle.edges),
    puzzle.edges(n).offset = puzzle.edges(n).offset * edge_pitch;
end;

% rescale default ordering
puzzle.t0 = puzzle.t0 * edge_pitch;

% rescale the boundary location
puzzle.boundary_location = puzzle.boundary_location * edge_pitch;




