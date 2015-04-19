%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Supplemental code for the paper "A Global Approach for Solving Edge-Matching Puzzles"
% Disclaimer: The code is provided as-is for academic use only and without any guarantees. 
%             Please contact the authors to report any bugs.
% Written by Shahar Kovalsky (http://www.wisdom.weizmann.ac.il/~shaharko/)
%        and Daniel Glasner   (https://sites.google.com/site/dglasner/)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function feasible_locations = getFeasibleLocations(puzzle)

feasible_locations = [];
for n = 1:length(puzzle.rotations),
    feasible_locations = [feasible_locations puzzle.rotations{n}*puzzle.t0];
end;
