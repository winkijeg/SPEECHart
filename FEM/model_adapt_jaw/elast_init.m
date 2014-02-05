function A0 = elast_init(XY, lambda, mu, ordre, H, G, MM, NN)
% initialises the elasticity matrix

    nNodes = NN*MM;

    nColsShort = NN-1;
    nRowsShort = MM-1;

    nSteps = nColsShort*nRowsShort;

    % memory allocation
    AA = zeros(1, (2*nNodes)^2); % row vector format
    
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
            XY(2*nbStep-1+2*NN+jump:2*nbStep+2+2*NN+jump)];
  
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
        for i = 1:ordre
            for j = 1:ordre
                KK = KK + ...
                    (H(ordre, i)*H(ordre, j) * ...
                    calculate_K(G(ordre,i), G(ordre,j), xy, lambda, mu, pfix));
            end
        end
  
        debut = (2*nNodes)*(2*nbStep-2+jump)+2*nbStep-1+jump;
        
        colonne = [debut*ones(1,4)+[0,1,2,3], (debut+2*NN)*ones(1,4)+[0,1,2,3]];
        
        step = (2*nNodes)*ones(1,8);
        II = [colonne, colonne+step, colonne+2*step, colonne+3*step];
        I = [II, II+2*NN*(2*nNodes)*ones(1, 32)];
        AA(I) = AA(I) + KK;
        
    end
    
    A0 = reshape(AA, 2*nNodes, 2*nNodes);

end
