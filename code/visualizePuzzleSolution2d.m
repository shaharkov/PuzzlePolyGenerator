%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Supplemental code for the paper "A Global Approach for Solving Edge-Matching Puzzles"
% Disclaimer: The code is provided as-is for academic use only and without any guarantees. 
%             Please contact the authors to report any bugs.
% Written by Shahar Kovalsky (http://www.wisdom.weizmann.ac.il/~shaharko/)
%        and Daniel Glasner   (https://sites.google.com/site/dglasner/)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function visualizePuzzleSolution2d(puzzle, t_pieces, t_border, prm)

% consts
ALPHA.FRAME.BASE = 1;
ALPHA.FRAME.ROT = 0.3;
ALPHA.PIECE.BASE = 0.9;
ALPHA.PIECE.ROT = 0.2;
LINEWIDTH_BOUNDARY = 2;
LINEWIDTH_PIECE = 1;

if puzzle.n_dims~=2,
    error('visualizePuzzleSolution2d: can only visualize 2d puzzles');
end;

if ~exist('t_pieces', 'var') || isempty(t_pieces),
    t_pieces = puzzle.t0;
    
end;

if ~exist('t_border', 'var') || isempty(t_border),
    t_border = puzzle.boundary_location;
end;

if prm.visualize_rotations,
    rotations = puzzle.rotations;
else
    rotations = puzzle.rotations(1);
end;

% plot bounds rectangle
if prm.visualize_boundary,
    rectangle('Position',[puzzle.boundary.lb puzzle.boundary.ub-puzzle.boundary.lb+eps],'LineStyle','--','EdgeColor',[.8 .8 .8]);
end;

% plot puzzle
for r = length(rotations):-1:1, % plot rotated versions first,
    % select transperancy level
    if r==1,
        alpha_frame = ALPHA.FRAME.BASE;
        alpha_piece = ALPHA.PIECE.BASE;
    else
        alpha_frame = ALPHA.FRAME.ROT;
        alpha_piece = ALPHA.PIECE.ROT;
    end;
    
    % plot boundary pieces
    for n = 1:length(puzzle.edges),
        if (puzzle.edges(n).piece==0), % this is a border piece
            plotEdge(puzzle.edges(n), t_border, puzzle.edge_pitch, rotations{r}, alpha_frame);
        end;
    end;
    
    % plot boundary frame
    plotFrame(t_border, puzzle.size, puzzle.edge_pitch, rotations{r}, alpha_frame, 'w', LINEWIDTH_BOUNDARY);
    
    % plot inner pieces
    for n = 1:length(puzzle.edges),
        if (puzzle.edges(n).piece~=0), % this is an inner piece
            plotEdge(puzzle.edges(n), t_pieces(:,puzzle.edges(n).piece), puzzle.edge_pitch, rotations{r}, alpha_piece);            
        end;
    end;
    
    % plot inner frames
    for n = 1:size(t_pieces,2),
        plotFrame(t_pieces(:,n), [1 1], puzzle.edge_pitch, rotations{r}, alpha_piece, 'k', LINEWIDTH_PIECE);
    end;
    
end;

axis equal
end

function plotEdge(edge, t, edge_pitch, global_R, alpha)
% plot a directed edge (triangle) translated by t - all coordinate system
% globally rotated by global_R
triang_base = edge_pitch*[cos(edge.angle) -sin(edge.angle); sin(edge.angle) cos(edge.angle)]*[0.5 0 0; 0 0.5 -0.5];
triang_trans = bsxfun(@plus, triang_base, t+edge.offset);
trinag_trans_rot = global_R*triang_trans;
patch(trinag_trans_rot(1,:), trinag_trans_rot(2,:), edge.color, 'facealpha', alpha, 'edgealpha', alpha, 'EdgeColor', 'none')
end

function plotFrame(t, sz, edge_pitch, global_R, alpha, line_color, line_width)
frame_base = edge_pitch*[0 sz(1) sz(1) 0; 0 0 sz(2) sz(2)];
frame_trans = bsxfun(@plus, frame_base, t-edge_pitch/2);
frame_trans_rot = global_R*frame_trans;
patch(frame_trans_rot(1,:), frame_trans_rot(2,:), 0, 'EdgeColor', line_color, 'facealpha', alpha, 'edgealpha', alpha, 'FaceColor', 'none', 'LineWidth', line_width)
end
