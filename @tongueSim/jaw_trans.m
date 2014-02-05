function [new_X0, new_Y0] = jaw_trans(TSObj, t)
% models jaw rotation and its effect on the tongue and the lower lip
% Also included is the lowerlip rotation relative to the jaw, and lip (lower 
% and upper) protrusion

    % global TSObj.t_initial
    % global TSObj.t_final
    % global TSObj.theta
    % global TSObj.theta_ll
    % global TSObj.theta_start
    % global TSObj.dist_lip
    % global TSObj.dist_hyoid
    % global TSObj.alpha_rest_pos 
    % global TSObj.dist_rest_pos
    % global TSObj.X_origin 
    % global TSObj.Y_origin 
    
    % global TSObj.hyoid_start
    % global hyoid_i_abs NOT NEEDED AS A GLOBAL
    
    % global TSObj.cont.lowerteeth
    % global TSObj.cont.lowerlip
    % global TSObj.cont.Vect_dents
    % global TSObj.cont.Point_dents
    % global TSObj.cont.slope_D
    % global TSObj.cont.org_D
    % global TSObj.cont.upperlip
    % global TSObj.cont.lar_ar
    % global TSObj.cont.tongue_lar_mri
    % global TSObj.alpha_rest_pos_dents_inf
    % global TSObj.dist_rest_pos_dents_inf
    % global TSObj.alpha_rest_pos_lowlip
    % global TSObj.dist_rest_pos_lowlip
    
    % global TSObj.old_t
    % global TSObj.X0
    % global TSObj.Y0
    % global TSObj.X_origin_ll
    % global TSObj.Y_origin_ll

    % global TSObj.lowerlip_initial
    % global TSObj.X_origin_initial
    % global TSObj.Y_origin_initial
    % global TSObj.lar_ar_initial
    % global TSObj.tongue_lar_initial
    
    % jaw angle at each timestep (transition+hold)
    theta_i = 0.5*(1-cos(pi*(t-TSObj.t_initial)/(TSObj.t_final-TSObj.t_initial))) * TSObj.theta;
    theta_ll_i = 0.5*(cos(pi*(TSObj.old_t-TSObj.t_initial)/(TSObj.t_final-TSObj.t_initial))-cos(pi*(t-TSObj.t_initial)/(TSObj.t_final-TSObj.t_initial)))*TSObj.theta_ll;
    dist_lip_i = 0.5*(cos(pi*(TSObj.old_t-TSObj.t_initial)/(TSObj.t_final-TSObj.t_initial))-cos(pi*(t-TSObj.t_initial)/(TSObj.t_final-TSObj.t_initial)))*TSObj.dist_lip;
    theta_i_abs = theta_i + TSObj.theta_start;

    dist_hyoid_i = 0.5*(1-cos(pi*(t-TSObj.t_initial)/(TSObj.t_final-TSObj.t_initial)))*TSObj.dist_hyoid;
    hyoid_i_abs = dist_hyoid_i+TSObj.hyoid_start;

    % Calculating the location of condyle. It is assumed that the condyle's 
    % total amplitude is 10mm in X direction and 3mm in Y direction (see 
    % Vatikiotis-Bateson & Ostry, 1995.  An analysis of the dimensionality 
    % of jaw motion in speech. J. Phonetics, 23, pp. 101-117).  Also the jaw 
    % rotates between -3(deg) to +12(deg) from the rest position; for the 
    % total of 15(deg) = 0.2618(rad) (see the same reference). Note that the 
    % location of condyle is linearly related to the amount of abosulte 
    % rotation of the jaw. For this subject (PB), the condyle's movement 
    % is 6mm (X-dir), and 2mm(Y-dir)
    
    TSObj.X_origin = TSObj.X_origin_initial - 6 * (theta_i_abs) / 0.2618;
    TSObj.Y_origin = TSObj.Y_origin_initial - 2 * (theta_i_abs) / 0.2618;

    if TSObj.theta_ll ~= 0
        % add the lower lip rotation relative the jaw; TSObj.cont.lowerlip(:,end) is the 
        % point connected to the jaw, therefore it assumed fixed relative to jaw
        tan_angle = (TSObj.lowerlip_initial(2,end)-TSObj.lowerlip_initial(2,1:(end-1)))./(TSObj.lowerlip_initial(1,end)-TSObj.lowerlip_initial(1,1:(end-1)));%PP
   
        for indice = 1:length(TSObj.lowerlip_initial(1,:))-1
            
            TSObj.lowerlip_initial(1,indice) = TSObj.lowerlip_initial(1,end)+(TSObj.lowerlip_initial(1,indice)-TSObj.lowerlip_initial(1,end)).*(cos(theta_ll_i)-sin(theta_ll_i).*tan_angle(indice)); 
          
            if tan_angle(indice) ~= 0
                
                TSObj.lowerlip_initial(2, indice) = TSObj.lowerlip_initial(2,end)+ (TSObj.lowerlip_initial(2,indice)-TSObj.lowerlip_initial(2,end)).*(cos(theta_ll_i)+sin(theta_ll_i)./tan_angle(indice));
          
            else
                
                TSObj.lowerlip_initial(2, indice) = TSObj.lowerlip_initial(2,end)+ (TSObj.lowerlip_initial(1,indice)-TSObj.lowerlip_initial(1,end)).*sin(theta_ll_i);
          
            end
            
        end
        
        % add the upper lip rotation relative to the jaw
        tan_angle = (TSObj.cont.upperlip(2,end)-TSObj.cont.upperlip(2,1:(end-1)))./(TSObj.cont.upperlip(1,end)-TSObj.cont.upperlip(1,1:(end-1)));
   
        for indice = 1:length(TSObj.cont.upperlip(1,:))-1
            
            TSObj.cont.upperlip(1,indice) = TSObj.cont.upperlip(1,end)+(TSObj.cont.upperlip(1,indice)-TSObj.cont.upperlip(1,end)).*(cos(theta_ll_i)-sin(theta_ll_i).*-tan_angle(indice)); 
          
            if tan_angle(indice) ~= 0
                
                TSObj.cont.upperlip(2,indice)=TSObj.cont.upperlip(2,end)+(TSObj.cont.upperlip(2,indice)-TSObj.cont.upperlip(2,end)).*(cos(theta_ll_i)+sin(theta_ll_i)./-tan_angle(indice));
          
            else
                
                TSObj.cont.upperlip(2,indice)=TSObj.cont.upperlip(2,end)+ (TSObj.cont.upperlip(1,indice)-TSObj.cont.upperlip(1,end)).*sin(theta_ll_i);
          
            end
            
        end
        
    end
    
    
    if TSObj.dist_lip ~= 0
        
        ilowerlipmin = 7;
        ilowerlipmax = 11;
        longlowerlip = length(TSObj.lowerlip_initial);
        TSObj.lowerlip_initial(1, 1:3) = TSObj.lowerlip_initial(1, 1:3);
        
        for ilip = 4:ilowerlipmin
            
            TSObj.lowerlip_initial(1, ilip) = TSObj.lowerlip_initial(1,ilip)-(1-(ilowerlipmin-ilip)/(ilowerlipmin-4))*dist_lip_i;
   
        end
        
        TSObj.lowerlip_initial(1, ilowerlipmin+1:ilowerlipmax-1) = TSObj.lowerlip_initial(1, ilowerlipmin+1:ilowerlipmax-1)-dist_lip_i;
   
        for ilip = ilowerlipmax:longlowerlip
            
            TSObj.lowerlip_initial(1,ilip)=TSObj.lowerlip_initial(1,ilip)-(1-(ilip-ilowerlipmax)/(longlowerlip-ilowerlipmax))*dist_lip_i;
   
        end
   
        iupperlipmin = 6;
        iupperlipmax = 13;
        longupperlip = length(TSObj.cont.upperlip);
        
        for ilip = 1:iupperlipmin
            
            TSObj.cont.upperlip(1,ilip)=TSObj.cont.upperlip(1,ilip)-(1-(iupperlipmin-ilip)/(iupperlipmin-1))*dist_lip_i;
   
        end
        
        TSObj.cont.upperlip(1, iupperlipmin+1:iupperlipmax-1) = TSObj.cont.upperlip(1,iupperlipmin+1:iupperlipmax-1)-dist_lip_i;
        
        for ilip = iupperlipmax:longupperlip
            
            TSObj.cont.upperlip(1,ilip)=TSObj.cont.upperlip(1,ilip)-(1-(ilip-iupperlipmax)/(longupperlip-iupperlipmax))*dist_lip_i;
        
        end
        
    end
    
    
    if TSObj.dist_hyoid ~= 0
        
        TSObj.cont.lar_ar(1, :) = TSObj.lar_ar_initial(1, :)-1/5*hyoid_i_abs;
        TSObj.cont.lar_ar(2, :) = TSObj.lar_ar_initial(2, :)-hyoid_i_abs;
        
        TSObj.cont.tongue_lar_mri(1, 2:end) = TSObj.tongue_lar_initial(1, 2:end)-1/5*hyoid_i_abs;
        TSObj.cont.tongue_lar_mri(2, 2:end) = TSObj.tongue_lar_initial(2, 2:end)-hyoid_i_abs;
        
    end

    if (TSObj.theta_ll ~= 0 || TSObj.dist_lip ~= 0) && TSObj.theta ~= 0
        
        % update the initial angle alpha of the lower lip
        TSObj.alpha_rest_pos_lowlip = atan2((TSObj.X_origin_ll-TSObj.lowerlip_initial(1,:)), ...
            (TSObj.Y_origin_ll-TSObj.lowerlip_initial(2,:)));
        % update the initial distance of the lower lip  
        TSObj.dist_rest_pos_lowlip = sqrt((TSObj.lowerlip_initial(2,:)-TSObj.Y_origin_ll).^2 + (TSObj.lowerlip_initial(1,:)-TSObj.X_origin_ll).^2);

    end

    if TSObj.theta ~= 0
        
        % the new location of nodes of the tongue
        new_X0 = TSObj.X_origin-TSObj.dist_rest_pos.*sin(TSObj.alpha_rest_pos-theta_i);
        new_Y0 = TSObj.Y_origin-TSObj.dist_rest_pos.*cos(TSObj.alpha_rest_pos-theta_i);

        % the new location of the lower incisor 
        TSObj.cont.lowerteeth(1, :) = TSObj.X_origin-TSObj.dist_rest_pos_dents_inf.*sin(TSObj.alpha_rest_pos_dents_inf-theta_i);
        TSObj.cont.lowerteeth(2, :) = TSObj.Y_origin-TSObj.dist_rest_pos_dents_inf.*cos(TSObj.alpha_rest_pos_dents_inf-theta_i);

        TSObj.cont.Vect_dents = [TSObj.cont.lowerteeth(1,11)-TSObj.cont.lowerteeth(1,13)-1 TSObj.cont.lowerteeth(2,11)-TSObj.cont.lowerteeth(2,13)]; 
        TSObj.cont.Point_dents = [TSObj.cont.lowerteeth(1,13)+1 TSObj.cont.lowerteeth(2,13)];
        TSObj.cont.slope_D = (TSObj.cont.lowerteeth(2,11)-TSObj.cont.lowerteeth(2,13))/(TSObj.cont.lowerteeth(1,11)-TSObj.cont.lowerteeth(1,13));
        TSObj.cont.org_D = TSObj.cont.lowerteeth(2,11)-TSObj.cont.slope_D*TSObj.cont.lowerteeth(1,11);

        % the new location of the lower lip
        TSObj.cont.lowerlip(1, :) = TSObj.X_origin-TSObj.dist_rest_pos_lowlip.*sin(TSObj.alpha_rest_pos_lowlip-theta_i);
        TSObj.cont.lowerlip(2, :) = TSObj.Y_origin-TSObj.dist_rest_pos_lowlip.*cos(TSObj.alpha_rest_pos_lowlip-theta_i);

    else
        TSObj.cont.lowerlip(1,:) = TSObj.lowerlip_initial(1,:);
        TSObj.cont.lowerlip(2,:) = TSObj.lowerlip_initial(2,:);
        % do not change the TSObj.X0 and TSObj.Y0 if there is no jaw rotation
        new_X0 = TSObj.X0;
        new_Y0 = TSObj.Y0;

    end
    
    TSObj.old_t = t;
    
end
