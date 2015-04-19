%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Supplemental code for the paper "A Global Approach for Solving Edge-Matching Puzzles"
% Disclaimer: The code is provided as-is for academic use only and without any guarantees. 
%             Please contact the authors to report any bugs.
% Written by Shahar Kovalsky (http://www.wisdom.weizmann.ac.il/~shaharko/)
%        and Daniel Glasner   (https://sites.google.com/site/dglasner/)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [Solutions, info]  = solvePuzzleBacktracking2d(pieces, border, n_rots, find_single_solution, backtracking_timeout)

%
if ~exist('backtracking_timeout', 'var') || isempty(backtracking_timeout),
    backtracking_timeout = inf;
end;

% init timer
t_start = tic;

% transpose things
pieces = pieces';
% border = cellfun(@transpose,border,'UniformOutput',false);

% init board
Nx = length(border{2});
Ny = length(border{1});
NpcsBase = size(pieces,1);
Board = nan(Nx+2,Ny+2);

% add rotated piece instances
switch n_rots,
    case 1,
        R = [0];
    case 2,
        R = [0 2];
    case 4,
        R = [0 1 2 3];
    otherwise,
        error('Incompatible n_rots, must be 1,2 or 4 for 2d backtracking');
end;
R_len = length(R);
for r = 2:R_len,
    pieces = [pieces; circshift(pieces(1:NpcsBase,:),[0 R(r)])];
end;
Npcs = R_len*NpcsBase;

% add piece instances for borders
for n = 1:Nx,
    % top border
    pieces = [pieces; nan nan nan border{2}(n)];
    Board(n+1,1) = size(pieces,1);
    % bottom border
    pieces = [pieces; nan border{4}(n) nan nan];
    Board(n+1,Ny+2) = size(pieces,1);
end;
for n = 1:Ny,
    % left border
    pieces = [pieces; nan nan border{1}(n) nan];
    Board(1,n+1) = size(pieces,1);
    % right border
    pieces = [pieces; border{3}(n) nan nan nan];
    Board(Nx+2,n+1) = size(pieces,1);
end;

%%
% init
info.finish = false;
info.t_first = [];
Free = true(1,Npcs);
Counter = zeros(1,NpcsBase);
Ptr = 1;
Solutions = [];
[xPtr,yPtr] = ind2sub([Nx Ny],Ptr);
% search (backtracking)
fprintf('Searching for solutions: ');
while (Ptr>0) && (toc(t_start)<backtracking_timeout),
    % try next available piece
    NextPiece = find(Free((Counter(Ptr)+1):Npcs),1,'first')+Counter(Ptr);
    if ~isempty(NextPiece),
        if Counter(Ptr), % if current Ptr is already assigned.
            %Free(Counter(Ptr)) = true;
            Free((mod(Counter(Ptr)-1,NpcsBase)+1):NpcsBase:Npcs) = true;      
        end;
        Counter(Ptr) = NextPiece;
        % check compatability with already assigned pieces
        if (pieces(Counter(Ptr),1)==pieces(Board((1+xPtr)-1,(1+yPtr)),3)), % left matches
            if (pieces(Counter(Ptr),2)==pieces(Board((1+xPtr),(1+yPtr)-1),4)), % top matches
                if (xPtr<Nx) || (pieces(Counter(Ptr),3)==pieces(Board((1+xPtr)+1,(1+yPtr)),1)), % not end of row or right matches
                    if (yPtr<Ny) || (pieces(Counter(Ptr),4)==pieces(Board((1+xPtr),(1+yPtr)+1),2)), % not end of col or bottom matches
                        % we have a valid assignment
                        Board((1+xPtr),(1+yPtr)) = Counter(Ptr);
                        % Free(Counter(Ptr)) = false;
                        Free((mod(Counter(Ptr)-1,NpcsBase)+1):NpcsBase:Npcs) = false;
                        if Ptr<NpcsBase,
                        % if any(Free),
                            % forward pointer
                            Ptr = Ptr + 1;
                            [xPtr,yPtr] = ind2sub([Nx Ny],Ptr);
                        else
                            % this is a solution of the puzzle
                            Solutions(:,:,end+1) = Board(2:Nx+1, 2:Ny+1);
                            fprintf('*');
                            if isempty(info.t_first),
                                info.t_first = toc(t_start);
                            end;
                            if find_single_solution,
                                break;
                            end;
                            % free current piece
                            Free((mod(Counter(Ptr)-1,NpcsBase)+1):NpcsBase:Npcs) = true;                            
                        end;
                    end;
                end;
            end;
        end;
    else % no more pieces to try here - step backwards
        % Free(Counter(Ptr)) = true;
        Free((mod(Counter(Ptr)-1,NpcsBase)+1):NpcsBase:Npcs) = true; 
        Counter(Ptr) = 0;
        Board((1+xPtr),(1+yPtr)) = nan;
        Ptr = Ptr-1;
        [xPtr,yPtr] = ind2sub([Nx Ny],Ptr);
    end;
end;

% remove first invalid solution
Solutions(:,:,1)=[];

% collect results
if Ptr<=0,
    info.finish = true;
end;
info.t_finish = toc(t_start);
info.n_solutions = size(Solutions,3);

% report number of solutions found
fprintf('\n1st solution found after %.2f secs\n', info.t_first);
fprintf('%d solutions found in %.2f secs\n',info.n_solutions ,info.t_finish);
if info.finish,
    fprintf('Search finished!\n');
else
    fprintf('Search timed-out...\n');
end;