function save (TSObj)

% interpolation des U pour prendre moins de place sur le disque
% chaque 1/500 pour fact = 1
% chaque 4/500 pour fact = 2
disp('Enregistrement de U ...')

% ------------------------------------------------------------------
% FXY_T est calcule dans UDOT2 pour la trajectoire de la force en
% fonction du temps dans force_gr.m

% On va ordonner les elements de TEMPS

 [t_ord, ind_ord] = sort(TEMPS); 

 % On va enlever les elements repetes de t_ord
 t_ord_aux = [t_ord(2:length(t_ord)), 0];
 ind_bon = find((t_ord_aux - t_ord) ~= 0);
 t_bon = t_ord(ind_bon); 

 FXY_ord = FXY_T(ind_ord, :);
 FXY_bon = FXY_ord(ind_bon, :); 

 FXY_TRAJ = interp1(t_bon, FXY_bon, t); 

 ACCL_ord = ACCL_T(ind_ord, :);
 ACCL_bon = ACCL_ord(ind_bon, :); 

 ACCL_TRAJ = interp1(t_bon, ACCL_bon, t); 

 ACTIV_ord = ACTIV_T(ind_ord, :);
 ACTIV_bon = ACTIV_ord(ind_bon, :); 

 ACTIV_TRAJ = interp1(t_bon, ACTIV_bon, t); 

 % On enleve les valeurs negatives
 index = find( ACTIV_TRAJ < 0 );
 ACTIV_TRAJ( index ) = zeros( size(index) ); 

 % ACTIV_TRAJ va etre une matrice avec l'activation en fonction du temps
 % pour une fibre de chaque muscle
 % ACTIV_TRAJ(t, :) = [GGP(t), GGA(), Stylo(), Hyo(), SL(), IL(), Vert()] 

 LAMBDA_ord = LAMBDA_T(ind_ord, :);
 LAMBDA_bon = LAMBDA_ord(ind_bon, :); 

 LAMBDA_TRAJ = interp1(t_bon, LAMBDA_bon, t); 

 % LAMBDA_TRAJ va etre une matrice avec la valeur de lambda en fonction du temps
 % pour une fibre de chaque muscle
 % LAMBDA_TRAJ(t, :) = [GGP(t), GGA(), Stylo(), Hyo(), SL(), IL(), Vert()]
 clear global TEMPS FXY_T ACCL_T ACTIV_T LAMBDA_T; 

 % Enregistrement sur disque des mouvements de la langue, ainsi que des
 % forces
 file_mat= [spkStr, '_', out_file];
 U_fin=U(end,:);
 FXY_TRAJ_FIN=FXY_TRAJ(end,:);
 ACTIV_TRAJ_FIN=ACTIV_TRAJ(end,:);
 LAMBDA_TRAJ_FIN=LAMBDA_TRAJ(end,:);
 U_dents_inf_fin=U_dents_inf(end,:);
 U_lowlip_fin=U_lowlip(end,:);
 U_upperlip_fin=U_upperlip(end,:);
 U_pharynx_mri_fin=U_pharynx_mri(end,:);
 U_lar_ar_mri_fin=U_lar_ar_mri(end,:);
 U_tongue_lar_mri_fin=U_tongue_lar_mri(end,:);
 % figure(100)
 % color='rbmcygkrbmcygkrbmcygkrbmcygkrbmcygkrbmcygk'
 % for i=1:length(t)
 % dess=['*' color(i)];
 % plot(X0_seq(i,:),Y0_seq(i,:),dess)
 % hold on
 % end
 % pause
 X0_seq_fin = X0_seq(end,:);
 Y0_seq_fin = Y0_seq(end,:);
 U_X_origin_fin = U_X_origin(end);
 U_Y_origin_fin = U_Y_origin(end); 

 jaw_rotation=jaw_rotation*180/pi;
 ll_rotation=ll_rotation*180/pi;
 if light
     list_data_sauv=' sujet U_fin t CALC_ELA fact MM NN SEQUENCE TEMPS_FINAL TEMPS_HOLD TEMPS_FINAL_CUM TEMPS_ACTIVATION MATRICE_LAMBDA nb_transitions';
     list_data_sauv=[list_data_sauv ' jaw_rotation lip_protrusion ll_rotation hyoid_movment FXY_TRAJ_FIN ACTIV_TRAJ_FIN LAMBDA_TRAJ_FIN X0 Y0'];
     list_data_sauv=[list_data_sauv ' U_dents_inf_fin U_lowlip_fin U_upperlip_fin U_pharynx_mri_fin  U_lar_ar_mri_fin U_tongue_lar_mri_fin'];
     list_data_sauv=[list_data_sauv ' X0_seq_fin Y0_seq_fin U_X_origin_fin U_Y_origin_fin'];
     command=['save ' file_mat '_light'  list_data_sauv];
     eval(command)
 else
     list_data_sauv=' sujet U t ttout CALC_ELA fact MM NN SEQUENCE TEMPS_FINAL TEMPS_HOLD TEMPS_FINAL_CUM TEMPS_ACTIVATION MATRICE_LAMBDA nb_transitions';
     list_data_sauv=[list_data_sauv ' jaw_rotation lip_protrusion ll_rotation hyoid_movment FXY_TRAJ ACCL_TRAJ ACTIV_TRAJ LAMBDA_TRAJ X0 Y0'];
     list_data_sauv=[list_data_sauv ' U_dents_inf U_lowlip U_upperlip U_pharynx_mri U_lar_ar_mri U_tongue_lar_mri X0_seq Y0_seq U_X_origin U_Y_origin'];
     command=['save ' file_mat list_data_sauv];
     eval(command)
 end

% FERM_MACHOIR supprimé => jaw_rotation

% lower_incisive +> U_dents_inf
% upper_incisive velum et palate supprimés car fixes donc contenus dans data_palais_repos

% jaw_rotation lip_protrusion ll_rotation hyoid_movment =>
% NOM des variables de commande ajoutées

% U_structures => Structures récupérées à chaque pas de temps

end
