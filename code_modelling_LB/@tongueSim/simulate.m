function simulate(TSObj)
%SIMULATE Run the simulation

tic;

% tfseq=TSObj.t_final_cum;
t0_seq=[0 TSObj.t_final_cum(1:length(TSObj.t_final_cum)-1)];
TSObj.tf=TSObj.t_final_cum(length(TSObj.t_final_cum));

%Jaw rotation and its effect on the tongue and the lower lip -- mz 12/27/99
TSObj.UU.lowerlip=zeros(round(200*TSObj.tf),12); % 30
TSObj.UU.upperlip=zeros(round(200*TSObj.tf),12); % 46
TSObj.UU.lowerteeth=zeros(round(200*TSObj.tf),10); % 34     %% GB Mars 2011
TSObj.UU.pharynx_mri=zeros(round(200*TSObj.tf),13);
TSObj.UU.lar_ar_mri=zeros(round(200*TSObj.tf),12);
TSObj.UU.tongue_lar_mri=zeros(round(200*TSObj.tf),17);
% TSObj.UU.mandibule=zeros(round(200*TSObj.tf),20);
TSObj.X0_seq=zeros(round(200*TSObj.tf),221);
TSObj.Y0_seq=zeros(round(200*TSObj.tf),221);
TSObj.ttout=0;
X0_initial=TSObj.restpos.X0;
Y0_initial=TSObj.restpos.Y0;
%

TSObj.jaw_rotation = (pi/180) .* TSObj.jaw_rotation;
TSObj.ll_rotation  = (pi/180) .* TSObj.ll_rotation;

TSObj.X_origin=TSObj.X_origin_initial;
TSObj.Y_origin=TSObj.Y_origin_initial;
TSObj.lar_ar_initial = TSObj.cont.lar_ar;
TSObj.tongue_lar_initial = TSObj.cont.tongue_lar_mri;
 
TSObj.udot3_init();

% Si simulation normal
for ind = 1:length(TSObj.t_final_cum)
    TSObj.i_Sim = ind;
    if TSObj.i_Sim==1
        TSObj.tfin=[];TSObj.Ufin=[];
        TSObj.theta_start=0;
        TSObj.hyoid_start=0;
    else
        TSObj.theta_start=sum(TSObj.jaw_rotation(1:TSObj.i_Sim-1));
        TSObj.hyoid_start=sum(TSObj.hyoid_movment(1:TSObj.i_Sim-1));
    end
    
    
    X0_rest_pos=TSObj.restpos.X0;Y0_rest_pos=TSObj.restpos.Y0;%intitial tongue position
    
    % the initial angle alpha for each node of the tongue
    TSObj.alpha_rest_pos = atan2((TSObj.X_origin-X0_rest_pos), (TSObj.Y_origin-Y0_rest_pos));
    % the distance of each node of the tongue to the center of rotation
    TSObj.dist_rest_pos = sqrt( (Y0_rest_pos-TSObj.Y_origin).^2 + ...
                          (X0_rest_pos-TSObj.X_origin).^2 );
    
    %the initial angle alpha of the lower incisor
    TSObj.alpha_rest_pos_dents_inf = atan2((TSObj.X_origin-TSObj.cont.lowerteeth(1,:)), ...
        (TSObj.Y_origin-TSObj.cont.lowerteeth(2,:)));
    %the initial distance of the lower incisor to the center of rotation
    TSObj.dist_rest_pos_dents_inf = sqrt((TSObj.cont.lowerteeth(2,:)-TSObj.Y_origin).^2 + (TSObj.cont.lowerteeth(1,:)-TSObj.X_origin).^2);
    
    TSObj.X_origin_ll=TSObj.X_origin;
    TSObj.Y_origin_ll=TSObj.Y_origin;
    TSObj.lowerlip_initial=TSObj.cont.lowerlip;
    TSObj.alpha_rest_pos_lowlip=atan2((TSObj.X_origin_ll-TSObj.cont.lowerlip(1,:)), (TSObj.Y_origin_ll-TSObj.cont.lowerlip(2,:)));%the initial angle alpha of the lower lip
    TSObj.dist_rest_pos_lowlip=sqrt((TSObj.cont.lowerlip(2,:)-TSObj.Y_origin_ll).^2+(TSObj.cont.lowerlip(1,:)-TSObj.X_origin_ll).^2);%the initial distance of the lower lip to the center of rotation
    TSObj.t_initial=t0_seq(TSObj.i_Sim);
    TSObj.t_transition=t0_seq(TSObj.i_Sim)+TSObj.activationTime(TSObj.i_Sim);
    TSObj.t_final=TSObj.t_final_cum(TSObj.i_Sim);
    TSObj.theta=TSObj.jaw_rotation(TSObj.i_Sim);
    TSObj.theta_ll=TSObj.ll_rotation(TSObj.i_Sim);
    TSObj.dist_lip=TSObj.lip_protrusion(TSObj.i_Sim);
    TSObj.dist_hyoid=TSObj.hyoid_movment(TSObj.i_Sim); % GB MARS 2011
    %    figure(300)
    %    plot(X0,Y0,'r+')
    %    pause
    %    hold on
    %
    fprintf('Integrating from %d to %d\n',t0_seq(TSObj.i_Sim), TSObj.t_final_cum(TSObj.i_Sim));
    if 0    
    	disp('NOT ENTERING ODE45PLUS BECAUSE OF TOO MANY UNNRESOLVED ISSUES.')
    else
        disp(['Iteration ' num2str(ind) ' of ode45plus.']);
    	[ts,Us]=TSObj.ode45plus(@TSObj.udot3_adapt_jaw, t0_seq(TSObj.i_Sim), TSObj.t_final_cum(TSObj.i_Sim), TSObj.U0, 1e-3, (((3 * TSObj.fact) - 2) / 500));
    
    %       figure(300)
    % plot(X0,Y0,'bo')
    % color='rbmcygrbmcygrbmcygrbmcygkrbmcygrbmcyg';
    % length(ts)
    % for iloop=1:(length(ts)-1)
    %     iloop
    % dess=['*' color(iloop)];
    % plot(TSObj.X0_seq(iloop,:),TSObj.Y0_seq(iloop,:),dess)
    % hold on
    % end
    %    pause
    %    plot(TSObj.X0_seq(length(ts),:),TSObj.Y0_seq(length(ts),:),'ow', 'LInewidth',2)
    % pause
    	TSObj.U0=Us(length(ts),:);
    	[TSObj.tfin]=[TSObj. tfin;ts];
    	[TSObj.Ufin]=[TSObj.Ufin;Us];
    end
end
%
if ( TSObj.length_ttout < (200 * TSObj.tf) )    
    TSObj.UU.X_origin=TSObj.UU.X_origin(1:TSObj.length_ttout);
    TSObj.UU.Y_origin=TSObj.UU.Y_origin(1:TSObj.length_ttout);
    TSObj.UU.lowerlip=TSObj.UU.lowerlip(1:TSObj.length_ttout,1:end);
    TSObj.UU.upperlip=TSObj.UU.upperlip(1:TSObj.length_ttout,1:end);
    TSObj.UU.lowerteeth=TSObj.UU.lowerteeth(1:TSObj.length_ttout,1:end);
    TSObj.UU.pharynx_mri=TSObj.UU.pharynx_mri(1:TSObj.length_ttout,1:end);
    TSObj.UU.lar_ar_mri=TSObj.UU.lar_ar_mri(1:TSObj.length_ttout,1:end);
    TSObj.UU.tongue_lar_mri=TSObj.UU.tongue_lar_mri(1:TSObj.length_ttout,1:end);
    %    TSObj.UU.mandibule=TSObj.UU.mandibule(1:TSObj.length_ttout,1:end);
    TSObj.X0_seq = TSObj.X0_seq(1:TSObj.length_ttout, 1:221);
    TSObj.Y0_seq = TSObj.Y0_seq(1:TSObj.length_ttout, 1:221);
end

t=TSObj.tfin';
U=TSObj.Ufin;

% interpolation des U pour prendre moins de place sur le disque
% chaque 1/500 pour fact = 1
% chaque 4/500 pour fact = 2
disp('Enregistrement de U ...')

% ------------------------------------------------------------------
% FXY_T est calcule dans UDOT2 pour la trajectoire de la force en
% fonction du temps dans force_gr.m

% On va ordonner les elements de TEMPS

%%%%L [t_ord, ind_ord] = sort(TEMPS);%%%%L 

%%%%L % On va enlever les elements repetes de t_ord
%%%%L t_ord_aux = [t_ord(2:length(t_ord)), 0];
%%%%L ind_bon = find((t_ord_aux - t_ord) ~= 0);
%%%%L t_bon = t_ord(ind_bon);%%%%L 

%%%%L FXY_ord = FXY_T(ind_ord, :);
%%%%L FXY_bon = FXY_ord(ind_bon, :);%%%%L 

%%%%L FXY_TRAJ = interp1(t_bon, FXY_bon, t);%%%%L 

%%%%L ACCL_ord = ACCL_T(ind_ord, :);
%%%%L ACCL_bon = ACCL_ord(ind_bon, :);%%%%L 

%%%%L ACCL_TRAJ = interp1(t_bon, ACCL_bon, t);%%%%L 

%%%%L ACTIV_ord = ACTIV_T(ind_ord, :);
%%%%L ACTIV_bon = ACTIV_ord(ind_bon, :);%%%%L 

%%%%L ACTIV_TRAJ = interp1(t_bon, ACTIV_bon, t);%%%%L 

%%%%L % On enleve les valeurs negatives
%%%%L index = find( ACTIV_TRAJ < 0 );
%%%%L ACTIV_TRAJ( index ) = zeros( size(index) );%%%%L 

%%%%L % ACTIV_TRAJ va etre une matrice avec l'activation en fonction du temps
%%%%L % pour une fibre de chaque muscle
%%%%L % ACTIV_TRAJ(t, :) = [GGP(t), GGA(), Stylo(), Hyo(), SL(), IL(), Vert()]%%%%L 

%%%%L LAMBDA_ord = LAMBDA_T(ind_ord, :);
%%%%L LAMBDA_bon = LAMBDA_ord(ind_bon, :);%%%%L 

%%%%L LAMBDA_TRAJ = interp1(t_bon, LAMBDA_bon, t);%%%%L 

%%%%L % LAMBDA_TRAJ va etre une matrice avec la valeur de lambda en fonction du temps
%%%%L % pour une fibre de chaque muscle
%%%%L % LAMBDA_TRAJ(t, :) = [GGP(t), GGA(), Stylo(), Hyo(), SL(), IL(), Vert()]
%%%%L clear global TEMPS FXY_T ACCL_T ACTIV_T LAMBDA_T;%%%%L 

%%%%L % Enregistrement sur disque des mouvements de la langue, ainsi que des
%%%%L % forces
%%%%L file_mat= [spkStr, '_', out_file];
%%%%L U_fin=U(end,:);
%%%%L FXY_TRAJ_FIN=FXY_TRAJ(end,:);
%%%%L ACTIV_TRAJ_FIN=ACTIV_TRAJ(end,:);
%%%%L LAMBDA_TRAJ_FIN=LAMBDA_TRAJ(end,:);
%%%%L U_dents_inf_fin=U_dents_inf(end,:);
%%%%L U_lowlip_fin=U_lowlip(end,:);
%%%%L U_upperlip_fin=U_upperlip(end,:);
%%%%L U_pharynx_mri_fin=U_pharynx_mri(end,:);
%%%%L U_lar_ar_mri_fin=U_lar_ar_mri(end,:);
%%%%L U_tongue_lar_mri_fin=U_tongue_lar_mri(end,:);
%%%%L % figure(100)
%%%%L % color='rbmcygkrbmcygkrbmcygkrbmcygkrbmcygkrbmcygk'
%%%%L % for i=1:length(t)
%%%%L % dess=['*' color(i)];
%%%%L % plot(X0_seq(i,:),Y0_seq(i,:),dess)
%%%%L % hold on
%%%%L % end
%%%%L % pause
%%%%L X0_seq_fin = X0_seq(end,:);
%%%%L Y0_seq_fin = Y0_seq(end,:);
%%%%L U_X_origin_fin = U_X_origin(end);
%%%%L U_Y_origin_fin = U_Y_origin(end);%%%%L 

%%%%L jaw_rotation=jaw_rotation*180/pi;
%%%%L ll_rotation=ll_rotation*180/pi;
%%%%L if light
%%%%L     list_data_sauv=' sujet U_fin t CALC_ELA fact MM NN SEQUENCE TEMPS_FINAL TEMPS_HOLD TEMPS_FINAL_CUM TEMPS_ACTIVATION MATRICE_LAMBDA nb_transitions';
%%%%L     list_data_sauv=[list_data_sauv ' jaw_rotation lip_protrusion ll_rotation hyoid_movment FXY_TRAJ_FIN ACTIV_TRAJ_FIN LAMBDA_TRAJ_FIN X0 Y0'];
%%%%L     list_data_sauv=[list_data_sauv ' U_dents_inf_fin U_lowlip_fin U_upperlip_fin U_pharynx_mri_fin  U_lar_ar_mri_fin U_tongue_lar_mri_fin'];
%%%%L     list_data_sauv=[list_data_sauv ' X0_seq_fin Y0_seq_fin U_X_origin_fin U_Y_origin_fin'];
%%%%L     command=['save ' file_mat '_light'  list_data_sauv];
%%%%L     eval(command)
%%%%L else
%%%%L     list_data_sauv=' sujet U t ttout CALC_ELA fact MM NN SEQUENCE TEMPS_FINAL TEMPS_HOLD TEMPS_FINAL_CUM TEMPS_ACTIVATION MATRICE_LAMBDA nb_transitions';
%%%%L     list_data_sauv=[list_data_sauv ' jaw_rotation lip_protrusion ll_rotation hyoid_movment FXY_TRAJ ACCL_TRAJ ACTIV_TRAJ LAMBDA_TRAJ X0 Y0'];
%%%%L     list_data_sauv=[list_data_sauv ' U_dents_inf U_lowlip U_upperlip U_pharynx_mri U_lar_ar_mri U_tongue_lar_mri X0_seq Y0_seq U_X_origin U_Y_origin'];
%%%%L     command=['save ' file_mat list_data_sauv];
%%%%L     eval(command)
%%%%L end

% FERM_MACHOIR supprimé => jaw_rotation

% lower_incisive +> U_dents_inf
% upper_incisive velum et palate supprimés car fixes donc contenus dans data_palais_repos

% jaw_rotation lip_protrusion ll_rotation hyoid_movment =>
% NOM des variables de commande ajoutées

% U_structures => Structures récupérées à chaque pas de temps

disp('Nombre de contacts : ');
TSObj.n_contact
disp('Nombre d''appels a UDOT : ');
TSObj.kkk
% Sauvegarde sur disque des mouvements du noeud qui entre en contact

%%%%L eval(['save mvt',' X_enr',' S_enr',' F_enr',' Yn_enr',' Yp_enr',' P_enr',' V_enr']);

toc % Affichage du temps de calcul
disp('End of simulation')

