function rp = initMinLength(rp)
% to be described
% This properties are used in comlambda.m / changed PP - 9 May 2011

rp.minLength_GGP = (rp.max_restLength_GGP - rp.delta_lambda_tot_GGP/2) * ...
    rp.fac_GGP; 

rp.minLength_GGA = (rp.max_restLength_GGA - rp.delta_lambda_tot_GGA/2) * ...
    rp.fac_GGA;

rp.minLength_Hyo = (rp.max_restLength_Hyo - rp.delta_lambda_tot_Hyo/2) * ...
    rp.fac_Hyo;

rp.minLength_Stylo = (rp.max_restLength_Stylo - rp.delta_lambda_tot_Stylo/2) * ...
    rp.fac_Stylo;

rp.minLength_SL = (rp.max_restLength_SL - rp.delta_lambda_tot_SL/2) * ...
    rp.fac_SL;

rp.minLength_IL = (rp.max_restLength_IL - rp.delta_lambda_tot_IL/2) * ...
    rp.fac_IL;

rp.minLength_Vert = (rp.max_restLength_Vert - rp.delta_lambda_tot_Vert/2) * ...
    rp.fac_Vert; % PP - 9 May 2011

end