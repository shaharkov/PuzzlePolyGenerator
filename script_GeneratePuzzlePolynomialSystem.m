%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Supplemental code for the paper "A Global Approach for Solving Edge-Matching Puzzles"
% Disclaimer: The code is provided as-is for academic use only and without any guarantees. 
%             Please contact the authors to report any bugs.
% Written by Shahar Kovalsky (http://www.wisdom.weizmann.ac.il/~shaharko/)
%        and Daniel Glasner   (https://sites.google.com/site/dglasner/)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%
clear all;
close all;
addpath('./code')


%% user parameters
% puzzle
rseed = 4; % random seed <--------------- change to randomize
n_dims = 2; % dimension [2] -- do not change
size_x = 6; % x dimension
size_y = 5; % y dimension
n_colors  = 8; % number of colors
n_rots = 4; % number of rotations {1,2,4}
zero_border_flag = false; % make a uniform border
mark_first_piece_flag = false; % mark the first piece
permute_random = true; % scamble piece locations
rotate_random = true; % scamble piece rotations

% backtracking solver
prm.solve_backtracking = true;
backtracking_find_single_solution = false;
backtracking_timeout = 20;

% representation + polynomial system
edge_pitch = 0.1; % length of edges
boundary_location = [1.2;1.2]; % position of corner
prm.tol = 1e-8; % construction tolerance
base_degs = [8;8]; % maximal polynomial degree

% visualization
prm.visualize_boundary = false;
prm.visualize_rotations = true;
prm.visualize_all_solutions = true;


%% generate random puzzle
% set seed
rng(rseed);
% generate random puzzle
[pieces_orig, border] = generateRandomPuzzle2d(size_x, size_y, n_colors, zero_border_flag, mark_first_piece_flag);
% generate random piece ordering (location + rotation)
piece_ord = randperm(size(pieces_orig,2));
piece_rot = randi(4,size(pieces_orig,2),1);


%% prepare puzzle representation
% rotate pieces at random
pieces_rot = pieces_orig;
if rotate_random,
    for n=1:size(pieces_orig,2)
        pieces_rot(:,n) = circshift(pieces_orig(:,n),piece_rot(n));
    end;
end;
% permute pieces at random
pieces = pieces_rot;
if permute_random
    pieces = pieces_rot(:, piece_ord);
end;
% convert to an algerbraic puzzle structure
puzzle = preparePuzzle(n_dims,pieces,border,n_rots,edge_pitch,boundary_location,prm);


%% visualize
% visualize puzzle (default raster ordering)
figure;
visualizePuzzleSolution2d(puzzle,[],[],prm);
% colors histogram
figure;
hist([puzzle.edges.color],1:n_colors);
xlabel('Color');
ylabel('Frequency');
title('Histogram of edge colors')


%% solve using backtracking - count number of solutions
if prm.solve_backtracking && (n_dims==2)
    solutions = solvePuzzleBacktracking2d(pieces, border, n_rots, backtracking_find_single_solution, backtracking_timeout);
    solution_count = size(solutions,3);
end;


%% compute polynomial system
% set basic monomials 
mi_base = getBaseMultiIndices(base_degs);
% expand to get a closed set of multi_indices
[mi, mi_mat_ind] = spanAllMultiIndices(mi_base, puzzle.rotations, true, prm);
% generate linear equations
color_list = unique(cat(2,puzzle.edges.color));
mi_ind_list = 1:size(mi,2);
angle_list = unique(cat(2,puzzle.edges.angle)); angle_list = angle_list(angle_list < pi);
eqs = generateEquations(color_list,mi_ind_list,angle_list);
[A,b] = prepareLinearSystem(puzzle,mi,eqs,prm);
fprintf('Generated a polynomial (exp) system of %d equations.\n', size(A,1));


%% verify that puzzle solutions (obtained with backtracking) satisfy the polynomial system
fprintf('Verifying polynomial system:\n');
n_pieces = size_x*size_y;
for ii = 1:solution_count
    % compute t_hat corresponding to solutions (obtained with backtracking)
    curr_solution = solutions(:,:,ii);
    curr_rotations = floor((curr_solution-1)/n_pieces);
    curr_inds = curr_solution - n_pieces*curr_rotations;
    t_hat = zeros(n_dims,n_pieces);
    for jj = 1:n_pieces
        t_hat(:, curr_inds(jj)) = puzzle.rotations{curr_rotations(jj)+1}'*puzzle.t0(:,jj);
    end
    % calculate corresponding exp-monomials
    T_hat = exp(t_hat);
    T_hat_lifted = getLiftedValues(T_hat,mi);
    % evaluate all polynomial equations -- encoded by the linear system (A,b) in lifted variables
    resid = A*T_hat_lifted(:)-b;
    fprintf('Solution #%d -- residual = %g\n', ii, norm(resid));
    % visualize solution
    if prm.visualize_all_solutions
        figure;
        visualizePuzzleSolution2d(puzzle,t_hat,[],prm);
    end
end