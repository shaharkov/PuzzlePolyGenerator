%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Supplemental code for the paper "A Global Approach for Solving Edge-Matching Puzzles"
% Disclaimer: The code is provided as-is for academic use only and without any guarantees. 
%             Please contact the authors to report any bugs.
% Written by Shahar Kovalsky (http://www.wisdom.weizmann.ac.il/~shaharko/)
%        and Daniel Glasner   (https://sites.google.com/site/dglasner/)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [pieces, border] = generateRandomPuzzle2d(size_x, size_y, num_colors, zero_border_flag, mark_first_piece_flag)

Nx = size_x;
Ny = size_y;
Nc = num_colors;

% randomize puzzle
Edges_x = randi(Nc,Nx+1,Ny);
Edges_y = randi(Nc,Nx,Ny+1);

% clear borders
if zero_border_flag,
    Edges_x(1,:)=0;
    Edges_y(:,1)=0;
    Edges_x(Nx+1,:)=0;
    Edges_y(:,Ny+1)=0;
end;

% mark the edge of 1st piece differently - randomaly
if mark_first_piece_flag,
    Edges_x(1,1)=randi(Nc,1,1);
end;

% assign borders
border{1} = Edges_x(1,:);
border{2} = Edges_y(:,1)';
border{3} = Edges_x(Nx+1,:);
border{4} = Edges_y(:,Ny+1)';

% assign pieces
pieces = zeros(Nx,Ny,4);
for nx = 1:Nx,
    for ny = 1:Ny,
        pieces(nx,ny,:) = [Edges_x(nx,ny) Edges_y(nx,ny) Edges_x(nx+1,ny) Edges_y(nx,ny+1)];
    end;
end;
pieces = squeeze(reshape(pieces,[Nx*Ny,4]))';