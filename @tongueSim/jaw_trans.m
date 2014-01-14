function [new_X0, new_Y0]=jaw_trans(TSObj, t);
%Jaw rotation and its effect on the tongue and the lower lip -- mz 12/27/99
%Also included the lowerlip rotation relative to the jaw, and lip (lower and upper) protrusion -- mz 1/21/2000

%global X0_rest_pos Y0_rest_pos t_initial t_transition t_final theta alpha_rest_pos dist_rest_pos X_origin Y_origin theta_start hyoid_start hyoid_i_abs;
%global dents_inf lowlip Vect_dents Point_dents pente_D org_D alpha_rest_pos_dents_inf dist_rest_pos_dents_inf alpha_rest_pos_lowlip dist_rest_pos_lowlip;
% global alpha_rest_pos_mandibule dist_rest_pos_mandibule alpha_rest_pos_machoire dist_rest_pos_machoire Mandibule Machoire
%global theta_ll dist_lip upperlip old_t X0 Y0 X_origin_ll Y_origin_ll lowlip_initial X_origin_initial Y_origin_initial dist_hyoid lar_ar_mri tongue_lar_mri pharynx_mri lar_ar_mri_initial tongue_lar_mri_initial pharynx_mri_initial
%
theta_i=0.5*(1-cos(pi*(t-t_initial)/(t_final-t_initial)))*theta;%jaw angle at each transition+hold time step
theta_ll_i=0.5*(cos(pi*(old_t-t_initial)/(t_final-t_initial))-cos(pi*(t-t_initial)/(t_final-t_initial)))*theta_ll;
dist_lip_i=0.5*(cos(pi*(old_t-t_initial)/(t_final-t_initial))-cos(pi*(t-t_initial)/(t_final-t_initial)))*dist_lip;
theta_i_abs=theta_i+theta_start;

%% GB MARS 2011 - Corrected PP Juli 2011
dist_hyoid_i=0.5*(1-cos(pi*(t-t_initial)/(t_final-t_initial)))*dist_hyoid;
hyoid_i_abs=dist_hyoid_i+hyoid_start;
%%
% figure(1000) % Pour illustrer le profil de vitesse du larynx % GB Mars 2011
% plot(t,dist_hyoid_i,'y*')
% hold on



%Calculating the location of condyle. It is assumed that the condyle's total amplitude is 10mm in X direction 
% and 3mm in Y direction (see Vatikiotis-Bateson & Ostry, 1995.  An analysis of the dimensionality of jaw motion
% in speech. J. Phonetics, 23, pp. 101-117).  Also the jaw rotates between -3(deg) to +12(deg) from the rest 
% position; for the total of 15(deg)=0.2618(rad) (see the same reference). Note that the location of condyle is linearly 
% related to the amount of abosulte rotation of the jaw. 
% For this subject (PB), the condyle's movement is 6mm (X-dir), and 2mm(Y-dir)
X_origin=X_origin_initial-6*(theta_i_abs)/0.2618;
Y_origin=Y_origin_initial-2*(theta_i_abs)/0.2618;

if theta_ll~=0
   
% add the lower lip rotation relative the jaw; lowlip(:,end) is the point connected to the jaw, therefore it assumed fixed 
% reltive to jaw
	tan_angle=(lowlip_initial(2,end)-lowlip_initial(2,1:(end-1)))./(lowlip_initial(1,end)-lowlip_initial(1,1:(end-1)));%PP
   for indice=1:length(lowlip_initial(1,:))-1
   lowlip_initial(1,indice)=lowlip_initial(1,end)+(lowlip_initial(1,indice)-lowlip_initial(1,end)).*(cos(theta_ll_i)-sin(theta_ll_i).*tan_angle(indice)); 
          if tan_angle(indice)~=0
   lowlip_initial(2,indice)=lowlip_initial(2,end)+ (lowlip_initial(2,indice)-lowlip_initial(2,end)).*(cos(theta_ll_i)+sin(theta_ll_i)./tan_angle(indice));
          else
              disp('la')
                 lowlip_initial(2,indice)=lowlip_initial(2,end)+ (lowlip_initial(1,indice)-lowlip_initial(1,end)).*sin(theta_ll_i);
          end
   end
   
% add the upper lip rotation relative to the jaw;
   tan_angle=(upperlip(2,end)-upperlip(2,1:(end-1)))./(upperlip(1,end)-upperlip(1,1:(end-1)));% GB Mars 2011
   for indice=1:length(upperlip(1,:))-1
   upperlip(1,indice)=upperlip(1,end)+(upperlip(1,indice)-upperlip(1,end)).*(cos(theta_ll_i)-sin(theta_ll_i).*-tan_angle(indice)); 
          if tan_angle(indice)~=0
   upperlip(2,indice)=upperlip(2,end)+(upperlip(2,indice)-upperlip(2,end)).*(cos(theta_ll_i)+sin(theta_ll_i)./-tan_angle(indice));
          else
              disp('la')
                 upperlip(2,indice)=upperlip(2,end)+ (upperlip(1,indice)-upperlip(1,end)).*sin(theta_ll_i);
          end
   end
   
end

if dist_lip~=0
    
	    % PP Juli 2011
    ilowerlipmin=7;
    ilowerlipmax=11;
    longlowerlip=length(lowlip_initial);
        lowlip_initial(1,1:3)=lowlip_initial(1,1:3);
   for ilip=4:ilowerlipmin
       lowlip_initial(1,ilip)=lowlip_initial(1,ilip)-(1-(ilowerlipmin-ilip)/(ilowerlipmin-4))*dist_lip_i;
   end
   lowlip_initial(1,ilowerlipmin+1:ilowerlipmax-1)=lowlip_initial(1,ilowerlipmin+1:ilowerlipmax-1)-dist_lip_i;
   for ilip=ilowerlipmax:longlowerlip
       lowlip_initial(1,ilip)=lowlip_initial(1,ilip)-(1-(ilip-ilowerlipmax)/(longlowerlip-ilowerlipmax))*dist_lip_i;
   end
   
    % PP Juli 2011
    iupperlipmin=6;
    iupperlipmax=13;
    longupperlip=length(upperlip);
   for ilip=1:iupperlipmin
       upperlip(1,ilip)=upperlip(1,ilip)-(1-(iupperlipmin-ilip)/(iupperlipmin-1))*dist_lip_i;
   end
   upperlip(1,iupperlipmin+1:iupperlipmax-1)=upperlip(1,iupperlipmin+1:iupperlipmax-1)-dist_lip_i;
   for ilip=iupperlipmax:longupperlip
       upperlip(1,ilip)=upperlip(1,ilip)-(1-(ilip-iupperlipmax)/(longupperlip-iupperlipmax))*dist_lip_i;
   end

end

%% GB MARS 2011
if dist_hyoid~=0
   %% PP Juli 2011 Correction of GUillaume's proposal
    lar_ar_mri(1,:)=lar_ar_mri_initial(1,:)-1/5*hyoid_i_abs;
    lar_ar_mri(2,:)=lar_ar_mri_initial(2,:)-hyoid_i_abs;
    tongue_lar_mri(1,2:end)=tongue_lar_mri_initial(1,2:end)-1/5*hyoid_i_abs;
    tongue_lar_mri(2,2:end)=tongue_lar_mri_initial(2,2:end)-hyoid_i_abs;    
end
%%

if (theta_ll~=0 || dist_lip~=0) && theta~=0
	alpha_rest_pos_lowlip=atan2((X_origin_ll-lowlip_initial(1,:)), (Y_origin_ll-lowlip_initial(2,:)));%update the initial angle alpha of the lower lip
	dist_rest_pos_lowlip=sqrt((lowlip_initial(2,:)-Y_origin_ll).^2+(lowlip_initial(1,:)-X_origin_ll).^2);%update the initial distance of the lower lip  
    
end

if theta~=0

% the new location of nodes of the tongue
	new_X0=X_origin-dist_rest_pos.*sin(alpha_rest_pos-theta_i);% the new location of nodes of the tongue
	new_Y0=Y_origin-dist_rest_pos.*cos(alpha_rest_pos-theta_i);

% the new location of the lower incisor 
	dents_inf(1,:)=X_origin-dist_rest_pos_dents_inf.*sin(alpha_rest_pos_dents_inf-theta_i);
	dents_inf(2,:)=Y_origin-dist_rest_pos_dents_inf.*cos(alpha_rest_pos_dents_inf-theta_i);
Vect_dents=[dents_inf(1,11)-dents_inf(1,13)-1 dents_inf(2,11)-dents_inf(2,13)]; 
Point_dents=[dents_inf(1,13)+1 dents_inf(2,13)];
pente_D=(dents_inf(2,11)-dents_inf(2,13))/(dents_inf(1,11)-dents_inf(1,13));
org_D=dents_inf(2,11)-pente_D*dents_inf(1,11);

% the new location of the mandibule

%    Mandibule(1,:)=X_origin-dist_rest_pos_mandibule.*sin(alpha_rest_pos_mandibule-theta_i);
%    Mandibule(2,:)=Y_origin-dist_rest_pos_mandibule.*cos(alpha_rest_pos_mandibule-theta_i);
%    Machoire(1,:)=X_origin-dist_rest_pos_machoire.*sin(alpha_rest_pos_machoire-theta_i);
%    Machoire(2,:)=Y_origin-dist_rest_pos_machoire.*cos(alpha_rest_pos_machoire-theta_i);

% the new location of the lower lip
   lowlip(1,:)=X_origin-dist_rest_pos_lowlip.*sin(alpha_rest_pos_lowlip-theta_i);
   lowlip(2,:)=Y_origin-dist_rest_pos_lowlip.*cos(alpha_rest_pos_lowlip-theta_i);
else
    lowlip(1,:)=lowlip_initial(1,:);
    lowlip(2,:)=lowlip_initial(2,:);
   new_X0=X0;% do not change the X0 and Y0 if there is no jaw rotation
   new_Y0=Y0;
end

old_t=t;
