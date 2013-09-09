function LAMBDA=Comlambda_adapt_jaw(t)
% Modified PP 9 May 2011 - Introduction of variable delta_lambda_tot_GGP, delta_lambda_tot_GGA, delta_lambda_tot_Hyo
% ..... delta_lambda_tot_Stylo, delta_lambda_tot_SL, delta_lambda_tot_IL, delta_lambda_tot_Vert;


global TEMPS_FINAL;
global TEMPS_FINAL_CUM;
global TEMPS_ACTIVATION;
global fact;

global MATRICE_LAMBDA;

% Longueur minimale pour chaque fibre de chaque muscle (calculees dans
% Simulation4.m

global longmin_GGP;
global longmin_GGA;
global longmin_Hyo;
global longmin_Stylo;
global longmin_SL;
global longmin_IL;
global longmin_Vert;
global longrepos_GGA_max longrepos_GGP_max longrepos_Hyo_max longrepos_IL_max longrepos_SL_max longrepos_Stylo_max longrepos_Vert_max %PP Nov 06

% On va calculer la valeur de lambda pour chaque muscle (lam_musc) et
% apres (pour calculer la valeur pour chaque fibre) on va interpoler
% entre la longueur de repos et la longueur minimal pour les fibres
    
% Il faut connaitre l'interval ou nous sommes
interval = min(find(TEMPS_FINAL_CUM >= t));

t_cum = [0, TEMPS_FINAL_CUM];
t = t - t_cum(interval);
% round(t  * 1000)

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
  
else     % Si le temps simulation est fini
    
  ind = size(MATRICE_LAMBDA, 2);
    
  lam_GGP = MATRICE_LAMBDA(1, ind);
      
  lam_GGA = MATRICE_LAMBDA(2, ind);
      
  lam_Hyo = MATRICE_LAMBDA(3, ind);
      
  lam_Stylo = MATRICE_LAMBDA(4, ind);
  
  lam_Vert = MATRICE_LAMBDA(5, ind);
      
  lam_SL = MATRICE_LAMBDA(6, ind);
      
  lam_IL = MATRICE_LAMBDA(7, ind);
    
end  

% Variable des valeurs de lambda (evolution temporaire)
global LAMBDA_T;
global t_i;

LAMBDA_T( t_i, 1 ) = lam_GGP;
LAMBDA_T( t_i, 2 ) = lam_GGA;
LAMBDA_T( t_i, 3 ) = lam_Stylo;
LAMBDA_T( t_i, 4 ) = lam_Hyo;
LAMBDA_T( t_i, 5 ) = lam_SL;
LAMBDA_T( t_i, 6 ) = lam_IL;
LAMBDA_T( t_i, 7 ) = lam_Vert;

% Facteur de proportionnalite entre les lambda des fibres d'un meme
% muscle
global fac_GGP;
global fac_GGA;
global fac_Hyo;
global fac_Stylo;
global fac_SL;
global fac_IL;
global fac_Vert; 

global longrepos_GGA_max longrepos_GGP_max longrepos_Hyo_max longrepos_IL_max longrepos_SL_max longrepos_Stylo_max longrepos_Vert_max %PP Nov 06

% Amplitude des variations min max prévues pour les lambdas %  PP - 9 May 2011
global delta_lambda_tot_GGP;
global delta_lambda_tot_GGA;
global delta_lambda_tot_Hyo;
global delta_lambda_tot_Stylo;
global delta_lambda_tot_SL;
global delta_lambda_tot_IL;
global delta_lambda_tot_Vert;

l_repos_GGP = (longrepos_GGP_max+delta_lambda_tot_GGP/2) * fac_GGP; %  PP - 9 May 2011
LAMBDA(1:1+3*fact) =  longmin_GGP + (l_repos_GGP - longmin_GGP) * ...
      (lam_GGP - (longrepos_GGP_max-delta_lambda_tot_GGP/2)) / delta_lambda_tot_GGP; %  PP - 9 May 2011

l_repos_GGA = (longrepos_GGA_max+delta_lambda_tot_GGA/2) * fac_GGA; %  PP - 9 May 2011
 LAMBDA(2+3*fact:1+6*fact) =  longmin_GGA + (l_repos_GGA - ...
      longmin_GGA) * (lam_GGA - (longrepos_GGA_max-delta_lambda_tot_GGA/2)) / delta_lambda_tot_GGA; %  PP - 9 May 2011

i=1+6*fact+1;
l_repos_Stylo = (longrepos_Stylo_max+delta_lambda_tot_Stylo/2) * fac_Stylo;  %  PP - 9 May 2011
LAMBDA(i:i+1) =  longmin_Stylo + (l_repos_Stylo - longmin_Stylo) ...
      * (lam_Stylo - (longrepos_Stylo_max-delta_lambda_tot_Stylo/2)) / delta_lambda_tot_Stylo; %  PP - 9 May 2011


l_repos_Hyo = (longrepos_Hyo_max+delta_lambda_tot_Hyo/2) * fac_Hyo;  %  PP - 9 May 2011
LAMBDA(i+2:i+4) =  longmin_Hyo + (l_repos_Hyo - longmin_Hyo) * ...
      (lam_Hyo - (longrepos_Hyo_max-delta_lambda_tot_Hyo/2)) / delta_lambda_tot_Hyo; %  PP - 9 May 2011


l_repos_SL = (longrepos_SL_max+delta_lambda_tot_SL/2) * fac_SL;   %  PP - 9 May 2011
LAMBDA(i+5) =  longmin_SL + (l_repos_SL - longmin_SL) * (lam_SL - (longrepos_SL_max-delta_lambda_tot_SL/2)) / delta_lambda_tot_SL; %  PP - 9 May 2011

l_repos_IL = (longrepos_IL_max+delta_lambda_tot_IL/2) * fac_IL;   %  PP - 9 May 2011
LAMBDA(i+6) =  longmin_IL + (l_repos_IL - longmin_IL) * (lam_IL - ...
    (longrepos_IL_max-delta_lambda_tot_IL/2)) / delta_lambda_tot_IL; %  PP - 9 May 2011

i=i+7;            
l_repos_Vert = (longrepos_Vert_max+delta_lambda_tot_Vert/2) * fac_Vert; %  PP - 9 May 2011
LAMBDA(i:i+3*fact-1) =  longmin_Vert + (l_repos_Vert - ...
   longmin_Vert) * (lam_Vert - (longrepos_Vert_max-delta_lambda_tot_Vert/2)) / delta_lambda_tot_Vert; %  PP - 9 May 2011

