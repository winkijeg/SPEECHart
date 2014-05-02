function mat_elasticity_A0 = elast_init(XY, lambda, mu, order, H, G)
% initialise the elasticity matrix

nNodesPerRow = 13;
nNodes = 221;
nColsShort = 12; % NN-1;
nRowsShort = 16; % MM-1;

% this loop runs 4 (nodes per mesh element) * (13 cols - 1) * (17 rows - 1)
nSteps = nColsShort * nRowsShort;
A0_tmp = zeros(1, (2*nNodes)^2); % row vector format
jump = -2;
for nbStep = 1:nSteps
    
    isFirstNodeOnShortRow = rem(nbStep-1, nColsShort) == 0;
    
    if isFirstNodeOnShortRow
        jump = jump + 2;
    end
    
    % x1 y1 x2 y2 x3 y3 x4 y4
    %
    %                   2             4
    %                    _____________
    %                   /            /
    %                  /     jj     /
    %                 /            /
    %                 -------------
    %                1            3
    %
    
    %                 [1 .. 4; 1.. 4]
    
    xy = [XY(2*nbStep-1+jump:2*nbStep+2+jump); ...
        XY(2*nbStep-1+2*nNodesPerRow+jump:2*nbStep+2+2*nNodesPerRow+jump)];
    
    if nbStep == nColsShort
        % only ONE element is fixed at lower right corner
        pfix = 2;
    elseif rem(nbStep, nColsShort) == 1
        % element fix upper left and lower
        pfix = 1;
    else
        %element is not fixed
        pfix = 0;
    end
    
    KK = sparse(1, 64);
    for i = 1:order
        
        for j = 1:order
            
            valTmp = calculate_K(G(order,i), G(order,j), xy, lambda, mu, pfix);
            KK = KK + (H(order, i) * H(order, j) * valTmp);
        
        end
        
    end
    
    debut = (2*nNodes)*(2*nbStep-2+jump)+2*nbStep-1+jump;
    
    colonne = [debut*ones(1,4)+[0,1,2,3], (debut+2*nNodesPerRow)*ones(1,4)+[0,1,2,3]];
    
    step = (2*nNodes)*ones(1,8);
    II = [colonne, colonne+step, colonne+2*step, colonne+3*step];
    I = [II, II+2*nNodesPerRow*(2*nNodes)*ones(1, 32)];
    A0_tmp(I) = A0_tmp(I) + KK;
    
end

mat_elasticity_A0 = reshape(A0_tmp, 2*nNodes, 2*nNodes);

end
