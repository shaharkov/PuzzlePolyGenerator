%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Supplemental code for the paper "A Global Approach for Solving Edge-Matching Puzzles"
% Disclaimer: The code is provided as-is for academic use only and without any guarantees. 
%             Please contact the authors to report any bugs.
% Written by Shahar Kovalsky (http://www.wisdom.weizmann.ac.il/~shaharko/)
%        and Daniel Glasner   (https://sites.google.com/site/dglasner/)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function S = prepareEdgeAssignment(puzzle,rotation_angle_ind,angle,color,prm)
%
% this function computes the assignment of an edge index in {-1,0,1}
%
% input:
% 
% output:
% S - num_edges x 1 trivalued {-1,0,1} assignemnet vector

% keep only the edges which have the right color
col_S = cat(1,puzzle.edges.color) == color;

% get the edge angles and rotate them
rotation_angle = puzzle.rotation_angles(rotation_angle_ind);
edge_angles = cat(1,puzzle.edges(:).angle);
rotated_edge_angles = mod(edge_angles+rotation_angle,2*pi);

% assign rotated edge angles to the equation angle
angle_S = 1*(abs(1-exp(i*(rotated_edge_angles - angle))) < prm.tol) + ...
    (-1)*(abs(1-exp(i*(rotated_edge_angles - angle + pi))) < prm.tol);

% return the product
S = col_S.*angle_S;














