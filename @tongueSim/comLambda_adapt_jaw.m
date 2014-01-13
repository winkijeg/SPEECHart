function LAMBDA = comLambda_adapt_jaw(TSObj, t)
% no clue what happens (so far)

 
 

    % We will calculate the value of lambda for each muscle (lam_musc) and 
    % afterwards (to calculate the value for each fiber) we will interpolate 
    % between the length at rest and minimum length for each fiber
    
    % the time interval where we are ...
    interval = min(find(TSObj.finalTimeCum >= t));
    
    t_cum = [0, TSObj.finalTimeCum];
    t = t - t_cum(interval);

    if length(interval)
        
        if (t <= TSObj.activationTime(interval))
            
            lam_GGP = TSObj.MATRICE_LAMBDA(1, interval) + (TSObj.MATRICE_LAMBDA(1, interval + 1) - TSObj.MATRICE_LAMBDA(1, interval)) * t  / TSObj.activationTime(interval);
            lam_GGA = TSObj.MATRICE_LAMBDA(2, interval) + (TSObj.MATRICE_LAMBDA(2, interval + 1) - TSObj.MATRICE_LAMBDA(2, interval)) * t  / TSObj.activationTime(interval);
            lam_Hyo = TSObj.MATRICE_LAMBDA(3, interval) + (TSObj.MATRICE_LAMBDA(3, interval + 1) - TSObj.MATRICE_LAMBDA(3, interval)) * t  / TSObj.activationTime(interval);
            lam_Stylo = TSObj.MATRICE_LAMBDA(4, interval) + (TSObj.MATRICE_LAMBDA(4, interval + 1) - TSObj.MATRICE_LAMBDA(4, interval)) * t  / TSObj.activationTime(interval);
            lam_Vert = TSObj.MATRICE_LAMBDA(5, interval) + (TSObj.MATRICE_LAMBDA(5, interval + 1) - TSObj.MATRICE_LAMBDA(5, interval)) * t  / TSObj.activationTime(interval);
            lam_SL = TSObj.MATRICE_LAMBDA(6, interval) + (TSObj.MATRICE_LAMBDA(6, interval + 1) - TSObj.MATRICE_LAMBDA(6, interval)) * t  / TSObj.activationTime(interval);
            lam_IL = TSObj.MATRICE_LAMBDA(7, interval) + (TSObj.MATRICE_LAMBDA(7, interval + 1) - TSObj.MATRICE_LAMBDA(7, interval)) * t  / TSObj.activationTime(interval);
  
        else
            
            lam_GGP = TSObj.MATRICE_LAMBDA(1, interval + 1);
            lam_GGA = TSObj.MATRICE_LAMBDA(2, interval + 1);
            lam_Hyo = TSObj.MATRICE_LAMBDA(3, interval + 1);
            lam_Stylo = TSObj.MATRICE_LAMBDA(4, interval + 1);
            lam_Vert = TSObj.MATRICE_LAMBDA(5, interval + 1);
            lam_SL = TSObj.MATRICE_LAMBDA(6, interval + 1);
            lam_IL = TSObj.MATRICE_LAMBDA(7, interval + 1);
    
        end
        
    else
        % if the simulation time is over
        ind = size(TSObj.MATRICE_LAMBDA, 2);
        
        lam_GGP = TSObj.MATRICE_LAMBDA(1, ind);
        lam_GGA = TSObj.MATRICE_LAMBDA(2, ind);
        lam_Hyo = TSObj.MATRICE_LAMBDA(3, ind);
        lam_Stylo = TSObj.MATRICE_LAMBDA(4, ind);
        lam_Vert = TSObj.MATRICE_LAMBDA(5, ind);
        lam_SL = TSObj.MATRICE_LAMBDA(6, ind);
        lam_IL = TSObj.MATRICE_LAMBDA(7, ind);
    
    end  

    % variable values ??of lambda (temporary Evolution) -------------------
    
    TSObj.LAMBDA_T(TSObj.t_i, 1) = lam_GGP;
    TSObj.LAMBDA_T(TSObj.t_i, 2) = lam_GGA;
    TSObj.LAMBDA_T(TSObj.t_i, 3) = lam_Stylo;
    TSObj.LAMBDA_T(TSObj.t_i, 4) = lam_Hyo;
    TSObj.LAMBDA_T(TSObj.t_i, 5) = lam_SL;
    TSObj.LAMBDA_T(TSObj.t_i, 6) = lam_IL;
    TSObj.LAMBDA_T(TSObj.t_i, 7) = lam_Vert;

 
    l_repos_GGP = (TSObj.restpos.max_restLength_GGP+TSObj.restpos.delta_lambda_tot_GGP/2) * TSObj.restpos.fac_GGP;
    LAMBDA(1:1+3*TSObj.fact) = TSObj.restpos.minLength_GGP + (l_repos_GGP - TSObj.restpos.minLength_GGP) * ...
        (lam_GGP - (TSObj.restpos.max_restLength_GGP-TSObj.restpos.delta_lambda_tot_GGP/2)) / TSObj.restpos.delta_lambda_tot_GGP;
    
    l_repos_GGA = (TSObj.restpos.max_restLength_GGA+TSObj.restpos.delta_lambda_tot_GGA/2) * TSObj.restpos.fac_GGA;
    LAMBDA(2+3*TSObj.fact:1+6*TSObj.fact) = TSObj.restpos.minLength_GGA + (l_repos_GGA - TSObj.restpos.minLength_GGA) * (lam_GGA - (TSObj.restpos.max_restLength_GGA-TSObj.restpos.delta_lambda_tot_GGA/2)) / TSObj.restpos.delta_lambda_tot_GGA;

    i = 1+ 6*TSObj.fact + 1;
    l_repos_Stylo = (TSObj.restpos.max_restLength_Stylo+TSObj.restpos.delta_lambda_tot_Stylo/2) * TSObj.restpos.fac_Stylo;
    LAMBDA(i:i+1) = TSObj.restpos.minLength_Stylo + (l_repos_Stylo - TSObj.restpos.minLength_Stylo) * (lam_Stylo - (TSObj.restpos.max_restLength_Stylo-TSObj.restpos.delta_lambda_tot_Stylo/2)) / TSObj.restpos.delta_lambda_tot_Stylo;
    
    l_repos_Hyo = (TSObj.restpos.max_restLength_Hyo+TSObj.restpos.delta_lambda_tot_Hyo/2) * TSObj.restpos.fac_Hyo;
    LAMBDA(i+2:i+4) = TSObj.restpos.minLength_Hyo + (l_repos_Hyo - TSObj.restpos.minLength_Hyo) * (lam_Hyo - (TSObj.restpos.max_restLength_Hyo-TSObj.restpos.delta_lambda_tot_Hyo/2)) / TSObj.restpos.delta_lambda_tot_Hyo;
    
    l_repos_SL = (TSObj.restpos.max_restLength_SL+TSObj.restpos.delta_lambda_tot_SL/2) * TSObj.restpos.fac_SL;
    LAMBDA(i+5) = TSObj.restpos.minLength_SL + (l_repos_SL - TSObj.restpos.minLength_SL) * (lam_SL - (TSObj.restpos.max_restLength_SL-TSObj.restpos.delta_lambda_tot_SL/2)) / TSObj.restpos.delta_lambda_tot_SL;
    
    l_repos_IL = (TSObj.restpos.max_restLength_IL+TSObj.restpos.delta_lambda_tot_IL/2) * TSObj.restpos.fac_IL;
    LAMBDA(i+6) = TSObj.restpos.minLength_IL + (l_repos_IL - TSObj.restpos.minLength_IL) * (lam_IL - (TSObj.restpos.max_restLength_IL-TSObj.restpos.delta_lambda_tot_IL/2)) / TSObj.restpos.delta_lambda_tot_IL;
    
    i = i+7;
    l_repos_Vert = (TSObj.restpos.max_restLength_Vert+TSObj.restpos.delta_lambda_tot_Vert/2) * TSObj.restpos.fac_Vert;
    LAMBDA(i:i+3*TSObj.fact-1) = TSObj.restpos.minLength_Vert + (l_repos_Vert - TSObj.restpos.minLength_Vert) * (lam_Vert - (TSObj.restpos.max_restLength_Vert-TSObj.restpos.delta_lambda_tot_Vert/2)) / TSObj.restpos.delta_lambda_tot_Vert;
    
end
