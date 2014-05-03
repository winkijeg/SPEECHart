function [new_X0, new_Y0] = jaw_trans(t)
% models jaw rotation and its effect on the tongue and the lower lip
% Also included is the lowerlip rotation relative to the jaw, and lip (lower
% and upper) protrusion

global t_initial
global t_final
global theta
global alpha_rest_pos
global dist_rest_pos
global X_origin
global Y_origin
global theta_start

global hyoid_start
global hyoid_i_abs

global dents_inf
global lowlip
global Vect_dents
global Point_dents
global pente_D
global org_D
global alpha_rest_pos_dents_inf
global dist_rest_pos_dents_inf
global alpha_rest_pos_lowlip
global dist_rest_pos_lowlip

global theta_ll
global dist_lip
global upperlip
global old_t
global X0
global Y0
global X_origin_ll
global Y_origin_ll
global lowlip_initial
global X_origin_initial
global Y_origin_initial
global dist_hyoid
global lar_ar_mri
global tongue_lar_mri
global lar_ar_mri_initial
global tongue_lar_mri_initial

% jaw angle at each timestep (transition+hold)
theta_i = 0.5*(1-cos(pi*(t-t_initial)/(t_final-t_initial))) * theta;
theta_ll_i = 0.5*(cos(pi*(old_t-t_initial)/(t_final-t_initial))-cos(pi*(t-t_initial)/(t_final-t_initial)))*theta_ll;
dist_lip_i = 0.5*(cos(pi*(old_t-t_initial)/(t_final-t_initial))-cos(pi*(t-t_initial)/(t_final-t_initial)))*dist_lip;
theta_i_abs = theta_i + theta_start;

dist_hyoid_i = 0.5*(1-cos(pi*(t-t_initial)/(t_final-t_initial)))*dist_hyoid;
hyoid_i_abs = dist_hyoid_i+hyoid_start;

% Calculating the location of condyle. It is assumed that the condyle's
% total amplitude is 10mm in X direction and 3mm in Y direction (see
% Vatikiotis-Bateson & Ostry, 1995.  An analysis of the dimensionality
% of jaw motion in speech. J. Phonetics, 23, pp. 101-117).  Also the jaw
% rotates between -3(deg) to +12(deg) from the rest position; for the
% total of 15(deg) = 0.2618(rad) (see the same reference). Note that the
% location of condyle is linearly related to the amount of abosulte
% rotation of the jaw. For this subject (PB), the condyle's movement
% is 6mm (X-dir), and 2mm(Y-dir)

X_origin = X_origin_initial - 6 * (theta_i_abs) / 0.2618;
Y_origin = Y_origin_initial - 2 * (theta_i_abs) / 0.2618;

if theta_ll ~= 0
    % add the lower lip rotation relative the jaw; lowlip(:,end) is the
    % point connected to the jaw, therefore it assumed fixed relative to jaw
    tan_angle = (lowlip_initial(2,end)-lowlip_initial(2,1:(end-1)))./(lowlip_initial(1,end)-lowlip_initial(1,1:(end-1)));%PP
    
    for indice = 1:length(lowlip_initial(1,:))-1
        
        lowlip_initial(1,indice) = lowlip_initial(1,end)+(lowlip_initial(1,indice)-lowlip_initial(1,end)).*(cos(theta_ll_i)-sin(theta_ll_i).*tan_angle(indice));
        
        if tan_angle(indice) ~= 0
            
            lowlip_initial(2, indice) = lowlip_initial(2,end)+ (lowlip_initial(2,indice)-lowlip_initial(2,end)).*(cos(theta_ll_i)+sin(theta_ll_i)./tan_angle(indice));
            
        else
            
            lowlip_initial(2, indice) = lowlip_initial(2,end)+ (lowlip_initial(1,indice)-lowlip_initial(1,end)).*sin(theta_ll_i);
            
        end
        
    end
    
    % add the upper lip rotation relative to the jaw
    tan_angle = (upperlip(2,end)-upperlip(2,1:(end-1)))./(upperlip(1,end)-upperlip(1,1:(end-1)));
    
    for indice = 1:length(upperlip(1,:))-1
        
        upperlip(1,indice) = upperlip(1,end)+(upperlip(1,indice)-upperlip(1,end)).*(cos(theta_ll_i)-sin(theta_ll_i).*-tan_angle(indice));
        
        if tan_angle(indice) ~= 0
            
            upperlip(2,indice)=upperlip(2,end)+(upperlip(2,indice)-upperlip(2,end)).*(cos(theta_ll_i)+sin(theta_ll_i)./-tan_angle(indice));
            
        else
            
            upperlip(2,indice)=upperlip(2,end)+ (upperlip(1,indice)-upperlip(1,end)).*sin(theta_ll_i);
            
        end
        
    end
    
end


if dist_lip ~= 0
    
    ilowerlipmin = 7;
    ilowerlipmax = 11;
    longlowerlip = length(lowlip_initial);
    lowlip_initial(1, 1:3) = lowlip_initial(1, 1:3);
    
    for ilip = 4:ilowerlipmin
        
        lowlip_initial(1, ilip) = lowlip_initial(1,ilip)-(1-(ilowerlipmin-ilip)/(ilowerlipmin-4))*dist_lip_i;
        
    end
    
    lowlip_initial(1, ilowerlipmin+1:ilowerlipmax-1) = lowlip_initial(1, ilowerlipmin+1:ilowerlipmax-1)-dist_lip_i;
    
    for ilip = ilowerlipmax:longlowerlip
        
        lowlip_initial(1,ilip)=lowlip_initial(1,ilip)-(1-(ilip-ilowerlipmax)/(longlowerlip-ilowerlipmax))*dist_lip_i;
        
    end
    
    iupperlipmin = 6;
    iupperlipmax = 13;
    longupperlip = length(upperlip);
    
    for ilip = 1:iupperlipmin
        
        upperlip(1,ilip)=upperlip(1,ilip)-(1-(iupperlipmin-ilip)/(iupperlipmin-1))*dist_lip_i;
        
    end
    
    upperlip(1, iupperlipmin+1:iupperlipmax-1) = upperlip(1,iupperlipmin+1:iupperlipmax-1)-dist_lip_i;
    
    for ilip = iupperlipmax:longupperlip
        
        upperlip(1,ilip)=upperlip(1,ilip)-(1-(ilip-iupperlipmax)/(longupperlip-iupperlipmax))*dist_lip_i;
        
    end
    
end


if dist_hyoid ~= 0
    
    lar_ar_mri(1, :) = lar_ar_mri_initial(1, :)-1/5*hyoid_i_abs;
    lar_ar_mri(2, :) = lar_ar_mri_initial(2, :)-hyoid_i_abs;
    
    tongue_lar_mri(1, 2:end) = tongue_lar_mri_initial(1, 2:end)-1/5*hyoid_i_abs;
    tongue_lar_mri(2, 2:end) = tongue_lar_mri_initial(2, 2:end)-hyoid_i_abs;
    
end

if (theta_ll ~= 0 || dist_lip ~= 0) && theta ~= 0
    
    % update the initial angle alpha of the lower lip
    alpha_rest_pos_lowlip = atan2((X_origin_ll-lowlip_initial(1,:)), ...
        (Y_origin_ll-lowlip_initial(2,:)));
    % update the initial distance of the lower lip
    dist_rest_pos_lowlip = sqrt((lowlip_initial(2,:)-Y_origin_ll).^2 + (lowlip_initial(1,:)-X_origin_ll).^2);
    
end

if theta ~= 0
    
    % the new location of nodes of the tongue
    new_X0 = X_origin-dist_rest_pos.*sin(alpha_rest_pos-theta_i);
    new_Y0 = Y_origin-dist_rest_pos.*cos(alpha_rest_pos-theta_i);
    
    % the new location of the lower incisor
    dents_inf(1, :) = X_origin-dist_rest_pos_dents_inf.*sin(alpha_rest_pos_dents_inf-theta_i);
    dents_inf(2, :) = Y_origin-dist_rest_pos_dents_inf.*cos(alpha_rest_pos_dents_inf-theta_i);
    
    Vect_dents = [dents_inf(1,11)-dents_inf(1,13)-1 dents_inf(2,11)-dents_inf(2,13)];
    Point_dents = [dents_inf(1,13)+1 dents_inf(2,13)];
    pente_D = (dents_inf(2,11)-dents_inf(2,13))/(dents_inf(1,11)-dents_inf(1,13));
    org_D = dents_inf(2,11)-pente_D*dents_inf(1,11);
    
    % the new location of the lower lip
    lowlip(1, :) = X_origin-dist_rest_pos_lowlip.*sin(alpha_rest_pos_lowlip-theta_i);
    lowlip(2, :) = Y_origin-dist_rest_pos_lowlip.*cos(alpha_rest_pos_lowlip-theta_i);
    
else
    lowlip(1,:) = lowlip_initial(1,:);
    lowlip(2,:) = lowlip_initial(2,:);
    % do not change the X0 and Y0 if there is no jaw rotation
    new_X0 = X0;
    new_Y0 = Y0;
    
end

old_t = t;

end
