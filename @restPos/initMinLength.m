function rp = initMinLength(rp)
%INITMINLENGTH
% This properties are used in comlambda.m
rp.minLength_GGP=(rp.max_restLength_GGP-rp.delta_lambda_tot_GGP/2) * rp.fac_GGP; % PP - 9 May 2011
rp.minLength_GGA=(rp.max_restLength_GGA-rp.delta_lambda_tot_GGA/2) * rp.fac_GGA; % PP - 9 May 2011
rp.minLength_Hyo=(rp.max_restLength_Hyo-rp.delta_lambda_tot_Hyo/2) * rp.fac_Hyo; % PP - 9 May 2011
rp.minLength_Stylo=(rp.max_restLength_Stylo-rp.delta_lambda_tot_Stylo/2) * rp.fac_Stylo; % PP - 9 May 2011
rp.minLength_SL=(rp.max_restLength_SL-rp.delta_lambda_tot_SL/2) * rp.fac_SL; % PP - 9 May 2011
rp.minLength_IL=(rp.max_restLength_IL-rp.delta_lambda_tot_IL/2) * rp.fac_IL; % PP - 9 May 2011
rp.minLength_Vert=(rp.max_restLength_Vert-rp.delta_lambda_tot_Vert/2) * rp.fac_Vert; % PP - 9 May 2011
