function matsOut = exportModelObsolete(obj)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

    

    % collect data stored in data_palais_repos_xx.mat

    matsOut.data_palais_repos.X1 = obj.landmarks.xyHyoA(1);
    matsOut.data_palais_repos.X2 = obj.landmarks.xyHyoB(1);
    matsOut.data_palais_repos.X3 = obj.landmarks.xyHyoC(1);
    matsOut.data_palais_repos.XS = obj.landmarks.xyStyloidProcess(1);
    matsOut.data_palais_repos.XANS = obj.landmarks.xyANS(1);
    matsOut.data_palais_repos.XPNS = obj.landmarks.xyPNS(1);
    matsOut.data_palais_repos.XTongInsL = obj.landmarks.xyTongInsL(1);
    matsOut.data_palais_repos.XTongInsH = obj.landmarks.xyTongInsH(1);

    matsOut.data_palais_repos.Y1 = obj.landmarks.xyHyoA(2);
    matsOut.data_palais_repos.Y2 = obj.landmarks.xyHyoB(2);
    matsOut.data_palais_repos.Y3 = obj.landmarks.xyHyoC(2);
    matsOut.data_palais_repos.YS = obj.landmarks.xyStyloidProcess(2);
    matsOut.data_palais_repos.YANS = obj.landmarks.xyANS(2);
    matsOut.data_palais_repos.YPNS = obj.landmarks.xyPNS(2);
    matsOut.data_palais_repos.YTongInsL = obj.landmarks.xyTongInsL(2);
    matsOut.data_palais_repos.YTongInsH = obj.landmarks.xyTongInsH(2);
    
%     matsOut.data_palais_repos.ecart_meanx = 
%     matsOut.data_palais_repos.ecart_meany = 
    
    matsOut.data_palais_repos.dents_inf = obj.structures.lowerIncisor;
    matsOut.data_palais_repos.lar_ar = obj.structures.larynxArytenoid;
    matsOut.data_palais_repos.lowlip = obj.structures.lowerLip;
    matsOut.data_palais_repos.palate = obj.structures.upperIncisorPalate;
    matsOut.data_palais_repos.pharynx = obj.structures.backPharyngealWall;
    matsOut.data_palais_repos.tongue_lar = obj.structures.tongueLarynx;
    matsOut.data_palais_repos.upperlip = obj.structures.upperLip;
    matsOut.data_palais_repos.velum = obj.structures.velum;

    % collect data stored in result_stocke_xx.mat
    longrepos_GGP_max = obj.muscleCollection.muscles(1).fiberMaxLengthAtRest;
    longrepos_GGA_max = obj.muscleCollection.muscles(2).fiberMaxLengthAtRest;
    longrepos_Hyo_max = obj.muscleCollection.muscles(3).fiberMaxLengthAtRest;
    longrepos_Stylo_max = obj.muscleCollection.muscles(4).fiberMaxLengthAtRest;
    longrepos_Vert_max = obj.muscleCollection.muscles(5).fiberMaxLengthAtRest;
    longrepos_SL_max = obj.muscleCollection.muscles(7).fiberMaxLengthAtRest;
    longrepos_IL_max = obj.muscleCollection.muscles(6).fiberMaxLengthAtRest;
    
    CONFIGS(1, :) = [longrepos_GGP_max 0 longrepos_GGA_max 0 longrepos_Hyo_max 0 longrepos_Stylo_max 0 longrepos_Vert_max 0 ...
    longrepos_SL_max 0 longrepos_IL_max 0];

    matsOut.result_stocke.CONFIGS = repmat(CONFIGS, 9, 1);

    % collect data stored in XY_repos_xx.mat
    
    matsOut.XY_repos.fac_GGP = obj.muscleCollection.muscles(1).fiberLengthsRatio;
    matsOut.XY_repos.fac_GGA = obj.muscleCollection.muscles(2).fiberLengthsRatio;
    matsOut.XY_repos.fac_Hyo = obj.muscleCollection.muscles(3).fiberLengthsRatio;
    matsOut.XY_repos.fac_Stylo = obj.muscleCollection.muscles(4).fiberLengthsRatio;
    matsOut.XY_repos.fac_Vert = obj.muscleCollection.muscles(5).fiberLengthsRatio;
    matsOut.XY_repos.fac_IL = obj.muscleCollection.muscles(6).fiberLengthsRatio;
    matsOut.XY_repos.fac_SL = obj.muscleCollection.muscles(7).fiberLengthsRatio;
    
    matsOut.XY_repos.longrepos_GGP_max = longrepos_GGP_max;
    matsOut.XY_repos.longrepos_GGA_max = longrepos_GGA_max;   
    matsOut.XY_repos.longrepos_Hyo_max = longrepos_Hyo_max;   
    matsOut.XY_repos.longrepos_Stylo_max = longrepos_Stylo_max;
    matsOut.XY_repos.longrepos_Vert_max = longrepos_Vert_max;
    matsOut.XY_repos.longrepos_SL_max = longrepos_SL_max;
    matsOut.XY_repos.longrepos_IL_max = longrepos_IL_max;
    
    tongMesh = obj.tongGrid; % Class PositionFrame
    positionValuesTmp = getPositionOfNodeNumbers(tongMesh, 1:221);
    
    % interpolation la position de repos en fonction du nombre de noeuds
    
    X_repos_new = reshape(positionValuesTmp(1, :), 13, 17)';
    Y_repos_new = reshape(positionValuesTmp(2, :), 13, 17)';
    
    X0(1:9, 1:7) = X_repos_new(1:2:17, 1:2:13);
    Y0(1:9, 1:7) = Y_repos_new(1:2:17, 1:2:13);
    
    % now the matrix should have 9x7 format
    matsOut.XY_repos.X_repos = X0;
    matsOut.XY_repos.Y_repos = Y0;
    
    
end

