function xyzOut = ras2lps(xyzIn)
% converts coordinates from slicer 3d (RAS) to matlab (LPS)

% written 09/2011 by RW

transMat = [-1 0 0 0;
            0 -1 0 0;
            0 0 1 0;
            0 0 0 1];
       
tmp_vec = transMat * [xyzIn; 1];
        
xyzOut(1:3, 1) = tmp_vec(1:3);
