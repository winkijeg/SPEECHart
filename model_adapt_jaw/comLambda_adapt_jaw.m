function LAMBDA = comLambda_adapt_jaw(t)
% no clue what happens (so far)

    global TEMPS_FINAL_CUM
    global TEMPS_ACTIVATION
    global fact

    global MATRICE_LAMBDA

    % minimum length of muscle fibers
    global longmin_GGP
    global longmin_GGA
    global longmin_Hyo
    global longmin_Stylo
    global longmin_SL
    global longmin_IL
    global longmin_Vert
    global longrepos_GGA_max
    global longrepos_GGP_max
    global longrepos_Hyo_max
    global longrepos_IL_max
    global longrepos_SL_max
    global longrepos_Stylo_max
    global longrepos_Vert_max

    % We will calculate the value of lambda for each muscle (lam_musc) and 
    % afterwards (to calculate the value for each fiber) we will interpolate 
    % between the length at rest and minimum length for each fiber
    
    % the time interval where we are ...
    interval = min(find(TEMPS_FINAL_CUM >= t));
    
    t_cum = [0, TEMPS_FINAL_CUM];
    t = t - t_cum(interval);

    if length(interval)
        
        if (t <= TEMPS_ACTIVATION(interval))
            
            lam_GGP = MATRICE_LAMBDA(1, interval) + (MATRICE_LAMBDA(1, interval + 1) - MATRICE_LAMBDA(1, interval)) * t  / TEMPS_ACTIVATION(interval);
            lam_GGA = MATRICE_LAMBDA(2, interval) + (MATRICE_LAMBDA(2, interval + 1) - MATRICE_LAMBDA(2, interval)) * t  / TEMPS_ACTIVATION(interval);
            lam_Hyo = MATRICE_LAMBDA(3, interval) + (MATRICE_LAMBDA(3, interval + 1) - MATRICE_LAMBDA(3, interval)) * t  / TEMPS_ACTIVATION(interval);
            lam_Stylo = MATRICE_LAMBDA(4, interval) + (MATRICE_LAMBDA(4, interval + 1) - MATRICE_LAMBDA(4, interval)) * t  / TEMPS_ACTIVATION(interval);
            lam_Vert = MATRICE_LAMBDA(5, interval) + (MATRICE_LAMBDA(5, interval + 1) - MATRICE_LAMBDA(5, interval)) * t  / TEMPS_ACTIVATION(interval);
            lam_SL = MATRICE_LAMBDA(6, interval) + (MATRICE_LAMBDA(6, interval + 1) - MATRICE_LAMBDA(6, interval)) * t  / TEMPS_ACTIVATION(interval);
            lam_IL = MATRICE_LAMBDA(7, interval) + (MATRICE_LAMBDA(7, interval + 1) - MATRICE_LAMBDA(7, interval)) * t  / TEMPS_ACTIVATION(interval);
  
        else
            
            lam_GGP = MATRICE_LAMBDA(1, interval + 1);
            lam_GGA = MATRICE_LAMBDA(2, interval + 1);
            lam_Hyo = MATRICE_LAMBDA(3, interval + 1);
            lam_Stylo = MATRICE_LAMBDA(4, interval + 1);
            lam_Vert = MATRICE_LAMBDA(5, interval + 1);
            lam_SL = MATRICE_LAMBDA(6, interval + 1);
            lam_IL = MATRICE_LAMBDA(7, interval + 1);
    
        end
        
    else
        % if the simulation time is over
        ind = size(MATRICE_LAMBDA, 2);
        
        lam_GGP = MATRICE_LAMBDA(1, ind);
        lam_GGA = MATRICE_LAMBDA(2, ind);
        lam_Hyo = MATRICE_LAMBDA(3, ind);
        lam_Stylo = MATRICE_LAMBDA(4, ind);
        lam_Vert = MATRICE_LAMBDA(5, ind);
        lam_SL = MATRICE_LAMBDA(6, ind);
        lam_IL = MATRICE_LAMBDA(7, ind);
    
    end  

    % variable values ??of lambda (temporary Evolution) -------------------
    global LAMBDA_T
    global t_i
    
    LAMBDA_T(t_i, 1) = lam_GGP;
    LAMBDA_T(t_i, 2) = lam_GGA;
    LAMBDA_T(t_i, 3) = lam_Stylo;
    LAMBDA_T(t_i, 4) = lam_Hyo;
    LAMBDA_T(t_i, 5) = lam_SL;
    LAMBDA_T(t_i, 6) = lam_IL;
    LAMBDA_T(t_i, 7) = lam_Vert;

    % proportionality factor between the muscle fibers --------------------
    global fac_GGP
    global fac_GGA
    global fac_Hyo
    global fac_Stylo
    global fac_SL
    global fac_IL
    global fac_Vert

    % amplitude variations (min max) set for the lambdas -----------------
    global delta_lambda_tot_GGP
    global delta_lambda_tot_GGA
    global delta_lambda_tot_Hyo
    global delta_lambda_tot_Stylo
    global delta_lambda_tot_SL
    global delta_lambda_tot_IL
    global delta_lambda_tot_Vert

    l_repos_GGP = (longrepos_GGP_max+delta_lambda_tot_GGP/2) * fac_GGP;
    LAMBDA(1:1+3*fact) = longmin_GGP + (l_repos_GGP - longmin_GGP) * ...
        (lam_GGP - (longrepos_GGP_max-delta_lambda_tot_GGP/2)) / delta_lambda_tot_GGP;
    
    l_repos_GGA = (longrepos_GGA_max+delta_lambda_tot_GGA/2) * fac_GGA;
    LAMBDA(2+3*fact:1+6*fact) = longmin_GGA + (l_repos_GGA - longmin_GGA) * (lam_GGA - (longrepos_GGA_max-delta_lambda_tot_GGA/2)) / delta_lambda_tot_GGA;

    i = 1+ 6*fact + 1;
    l_repos_Stylo = (longrepos_Stylo_max+delta_lambda_tot_Stylo/2) * fac_Stylo;
    LAMBDA(i:i+1) = longmin_Stylo + (l_repos_Stylo - longmin_Stylo) * (lam_Stylo - (longrepos_Stylo_max-delta_lambda_tot_Stylo/2)) / delta_lambda_tot_Stylo;
    
    l_repos_Hyo = (longrepos_Hyo_max+delta_lambda_tot_Hyo/2) * fac_Hyo;
    LAMBDA(i+2:i+4) = longmin_Hyo + (l_repos_Hyo - longmin_Hyo) * (lam_Hyo - (longrepos_Hyo_max-delta_lambda_tot_Hyo/2)) / delta_lambda_tot_Hyo;
    
    l_repos_SL = (longrepos_SL_max+delta_lambda_tot_SL/2) * fac_SL;
    LAMBDA(i+5) = longmin_SL + (l_repos_SL - longmin_SL) * (lam_SL - (longrepos_SL_max-delta_lambda_tot_SL/2)) / delta_lambda_tot_SL;
    
    l_repos_IL = (longrepos_IL_max+delta_lambda_tot_IL/2) * fac_IL;
    LAMBDA(i+6) = longmin_IL + (l_repos_IL - longmin_IL) * (lam_IL - (longrepos_IL_max-delta_lambda_tot_IL/2)) / delta_lambda_tot_IL;
    
    i = i+7;
    l_repos_Vert = (longrepos_Vert_max+delta_lambda_tot_Vert/2) * fac_Vert;
    LAMBDA(i:i+3*fact-1) = longmin_Vert + (l_repos_Vert - longmin_Vert) * (lam_Vert - (longrepos_Vert_max-delta_lambda_tot_Vert/2)) / delta_lambda_tot_Vert;
    
end
