%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Supplemental code for the paper "A Global Approach for Solving Edge-Matching Puzzles"
% Disclaimer: The code is provided as-is for academic use only and without any guarantees. 
%             Please contact the authors to report any bugs.
% Written by Shahar Kovalsky (http://www.wisdom.weizmann.ac.il/~shaharko/)
%        and Daniel Glasner   (https://sites.google.com/site/dglasner/)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function edges = prepareEdges(n_dims,pieces,border,prm)

% Computes an offset matrix describing the offsets of the edges to the
% pieces.
%
% Input:
% pieces - each column is a piece
% border - a cell array
%
% Output:
% Edges an array of struct representing the edges
% with the following fields
% offset [i;j,...] , piece, color, angle, 

curr_edge_ind = 0;
if n_dims==1, % case of 1d puzzles
    if size(pieces,1)~=2
        error('prepareEdges: pieces array has wrong dimensions');
    end;
    % TODO SK: preallocation of edges(:)
    % convert border
    curr_edge_ind = curr_edge_ind+1;
    edges(curr_edge_ind).piece = 0;
    edges(curr_edge_ind).offset = 0;
    edges(curr_edge_ind).angle = pi;
    edges(curr_edge_ind).color = border{1}(1);
    curr_edge_ind = curr_edge_ind+1;
    edges(curr_edge_ind).piece = 0;
    edges(curr_edge_ind).offset = size(pieces,2);
    edges(curr_edge_ind).angle = 0;
    edges(curr_edge_ind).color = border{2}(1);
    % convert pieces
    for n = 1:size(pieces,2),
        curr_edge_ind = curr_edge_ind+1;
        edges(curr_edge_ind).piece = n;
        edges(curr_edge_ind).offset = 0;
        edges(curr_edge_ind).angle = 0;
        edges(curr_edge_ind).color = pieces(1,n);
        curr_edge_ind = curr_edge_ind+1;
        edges(curr_edge_ind).piece = n;
        edges(curr_edge_ind).offset = 1;
        edges(curr_edge_ind).angle = pi;
        edges(curr_edge_ind).color = pieces(2,n);
    end;
elseif n_dims==2, % case of 2d puzzles
    if size(pieces,1)~=4
        error('prepareEdges: pieces array has wrong dimensions');
    end;
    % TODO SK: preallocation of edges(:)
    % init
    list_offsets = [-0.5 0; 0 -0.5; 0.5 0; 0 0.5]';    % L B R T
    list_angles = [0 0.5 1 1.5]*pi;
    size_x = length(border{2});
    size_y = length(border{1});
    % convert border - left
    for n = 1:size_y,
        curr_edge_ind = curr_edge_ind+1;
        edges(curr_edge_ind).piece = 0;
        edges(curr_edge_ind).offset = list_offsets(:,1)+[0; (n-1)];
        edges(curr_edge_ind).angle = list_angles(3);
        edges(curr_edge_ind).color = border{1}(n);
    end;
    % convert border - bottom
    for n = 1:size_x
        curr_edge_ind = curr_edge_ind+1;
        edges(curr_edge_ind).piece = 0;
        edges(curr_edge_ind).offset = list_offsets(:,2)+[(n-1); 0];
        edges(curr_edge_ind).angle = list_angles(4);
        edges(curr_edge_ind).color = border{2}(n);
    end;
    % convert border - right
    for n = 1:length(border{3})
        curr_edge_ind = curr_edge_ind+1;
        edges(curr_edge_ind).piece = 0;
        edges(curr_edge_ind).offset = list_offsets(:,1)+[size_x; (n-1)];
        edges(curr_edge_ind).angle = list_angles(1);
        edges(curr_edge_ind).color = border{3}(n);
    end;
    % convert border - bottom
    for n = 1:length(border{2})
        curr_edge_ind = curr_edge_ind+1;
        edges(curr_edge_ind).piece = 0;
        edges(curr_edge_ind).offset = list_offsets(:,2)+[(n-1); size_y];
        edges(curr_edge_ind).angle = list_angles(2);
        edges(curr_edge_ind).color = border{4}(n);
    end;
    % convert pieces
    num_sides = 4;
    for n = 1:size(pieces,2),
        for m = 1:num_sides,
            curr_edge_ind = curr_edge_ind+1;
            edges(curr_edge_ind).piece = n;
            edges(curr_edge_ind).offset = list_offsets(:,m);
            edges(curr_edge_ind).angle = list_angles(m);
            edges(curr_edge_ind).color = pieces(m,n);
        end;
    end;
else
    error('preparePuzzle: not yet implemented for n_dims~=1,2')
end;