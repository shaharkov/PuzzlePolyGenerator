%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Supplemental code for the paper "A Global Approach for Solving Edge-Matching Puzzles"
% Disclaimer: The code is provided as-is for academic use only and without any guarantees. 
%             Please contact the authors to report any bugs.
% Written by Shahar Kovalsky (http://www.wisdom.weizmann.ac.il/~shaharko/)
%        and Daniel Glasner   (https://sites.google.com/site/dglasner/)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function eqs = generateEquations(colors,mi_inds,rotation_angles)
% Generates equations by taking the product of the input colors multi
% indices and rotation angles. 

eqs(size(colors,2),size(mi_inds,2),size(rotation_angles,2)) = newEquationStruct();
for i = 1:size(colors,2),
    for j = 1:size(mi_inds,2),
        for k = 1:size(rotation_angles,2),
            eqs(i,j,k).color = colors(:,i);
            eqs(i,j,k).mi_ind = mi_inds(j);
            eqs(i,j,k).angle = rotation_angles(k);
        end
    end
end
eqs = permute(eqs,[1 3 2]);
eqs = eqs(:);
            
