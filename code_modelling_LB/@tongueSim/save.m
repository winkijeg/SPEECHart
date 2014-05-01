function save(obj)
% save ???

    t = obj.tfin';
    U = obj.Ufin;
    
    % interpolation des U pour prendre moins de place sur le disque
    % chaque 1/500 pour fact = 1
    % chaque 4/500 pour fact = 2
    disp('Saving U ...')

    % ------------------------------------------------------------------
    % FXY_T est calcule dans UDOT2 pour la trajectoire de la force en
    % fonction du temps dans force_gr.m

    % On va ordonner les elements de TEMPS

    [t_ord, ind_ord] = sort(obj.TEMPS); 

    % On va enlever les elements repetes de t_ord
    t_ord_aux = [t_ord(2:length(t_ord)), 0];
    ind_bon = find((t_ord_aux - t_ord) ~= 0);
    t_bon = t_ord(ind_bon); 

    FXY_ord = obj.FXY_T(ind_ord, :);
    FXY_bon = FXY_ord(ind_bon, :); 

    FXY_TRAJ = interp1(t_bon, FXY_bon, t); 

    ACCL_ord = obj.ACCL_T(ind_ord, :);
    ACCL_bon = ACCL_ord(ind_bon, :);

    ACCL_TRAJ = interp1(t_bon, ACCL_bon, t); 

    ACTIV_ord = obj.ACTIV_T(ind_ord, :);
    ACTIV_bon = ACTIV_ord(ind_bon, :); 

    ACTIV_TRAJ = interp1(t_bon, ACTIV_bon, t); 

    % On enleve les valeurs negatives
    index = find( ACTIV_TRAJ < 0 );
    ACTIV_TRAJ( index ) = zeros( size(index) ); 

    % ACTIV_TRAJ va etre une matrice avec l'activation en fonction du temps
    % pour une fibre de chaque muscle
    % ACTIV_TRAJ(t, :) = [GGP(t), GGA(), Stylo(), Hyo(), SL(), IL(), Vert()] 

    LAMBDA_ord = obj.LAMBDA_T(ind_ord, :);
    LAMBDA_bon = LAMBDA_ord(ind_bon, :); 

    LAMBDA_TRAJ = interp1(t_bon, LAMBDA_bon, t); 

    % LAMBDA_TRAJ va etre une matrice avec la valeur de lambda en fonction du temps
    % pour une fibre de chaque muscle
    % LAMBDA_TRAJ(t, :) = [GGP(t), GGA(), Stylo(), Hyo(), SL(), IL(), Vert()]
    % clear global TEMPS FXY_T ACCL_T ACTIV_T LAMBDA_T; 

    % Enregistrement sur disque des mouvements de la langue, ainsi que des
    % forces
    % U_fin=U(end,:);
    % FXY_TRAJ_FIN=FXY_TRAJ(end,:);
    % ACTIV_TRAJ_FIN=ACTIV_TRAJ(end,:);
    % LAMBDA_TRAJ_FIN=LAMBDA_TRAJ(end,:);
    % U_dents_inf_fin=TSObj.UU.lowerteeth(end,:);
    % U_lowlip_fin=TSObj.UU.lowerlip(end,:);
    % U_upperlip_fin=TSObj.UU.upperlip(end,:);
    % U_pharynx_mri_fin=TSObj.UU.pharynx_mri(end,:);
    % U_lar_ar_mri_fin=TSObj.UU.lar_ar_mri(end,:);
    U_tongue_lar_mri_fin = obj.UU.tongue_lar_mri(end, :);
    % figure(100)
    % color='rbmcygkrbmcygkrbmcygkrbmcygkrbmcygkrbmcygk'
    % for i=1:length(t)
    % dess=['*' color(i)];
    % plot(X0_seq(i,:),Y0_seq(i,:),dess)
    % hold on
    % end
    % pause
    % X0_seq_fin = TSObj.X0_seq(end,:);
    % Y0_seq_fin = TSObj.Y0_seq(end,:);
    
    U_X_origin_fin = obj.UU.X_origin(end);
    U_Y_origin_fin = obj.UU.Y_origin(end); 

    if obj.saveLight
        command = obj.saveVars(obj.outFile, ...
            'sujet', obj.speaker, ...
            'U_fin', U(end,:), ...
            'CALC_ELA', obj.CALC_ELA, 'fact', obj.fact, ...
            'MM', obj.MM, 'NN', obj.NN, 'SEQUENCE', obj.SEQUENCE, ...
            'TEMPS_FINAL', obj.t_final, 'TEMPS_FINAL_CUM', obj.t_final_cum, ...
            'TEMPS_HOLD', obj.t_hold, 'TEMPS_ACTIVATION', obj.activationTime, ...
            'MATRICE_LAMBDA', obj.MATRICE_LAMBDA, ...
            'nb_transitions', size(obj.MATRICE_LAMBDA,2)-1, ...
            'jaw_rotation', obj.jaw_rotation * 180/pi, ...
            'lip_protrusion', obj.lip_protrusion, ...
            'll_rotation' , obj.ll_rotation * 180/pi, ...
            'hyoid_movment', obj.hyoid_movment, ...
            'FXY_TRAJ_FIN', FXY_TRAJ(end,:), ...
            'ACTIV_TRAJ_FIN', ACTIV_TRAJ(end,:), ...
            'LAMBDA_TRAJ_FIN', LAMBDA_TRAJ(end,:), ...
            'X0', obj.restpos.X0, 'Y0', obj.restpos.Y0, ...
            'U_dents_inf_fin', obj.UU.lowerteeth(end,:), ...
            'U_lowlip_fin', obj.UU.lowerlip(end,:), ...
            'U_upperlip_fin', obj.UU.upperlip(end,:), ...
            'U_pharynx_mri_fin', obj.UU.pharynx_mri(end,:), ...
            'U_lar_ar_mri_fin', obj.UU.lar_ar_mri(end,:), ...
            'U_tongue_lar_mri_fin', obj.UU.tongue_lar_mri(end,:), ...
            'X0_seq_fin', obj.X0_seq(end,:), ...
            'Y0_seq_fin', obj.Y0_seq(end,:), ...
            'U_X_origin_fin', obj.UU.X_origin(end), ...
            'U_Y_origin_fin', obj.UU.Y_origin(end));
        
        eval(command);
    else
        list_data_sauv = ' sujet U t ttout CALC_ELA fact MM NN SEQUENCE TEMPS_FINAL TEMPS_HOLD TEMPS_FINAL_CUM TEMPS_ACTIVATION MATRICE_LAMBDA nb_transitions';
        list_data_sauv = [list_data_sauv ' jaw_rotation lip_protrusion ll_rotation hyoid_movment FXY_TRAJ ACCL_TRAJ ACTIV_TRAJ LAMBDA_TRAJ X0 Y0'];
        list_data_sauv = [list_data_sauv ' U_dents_inf U_lowlip U_upperlip U_pharynx_mri U_lar_ar_mri U_tongue_lar_mri X0_seq Y0_seq U_X_origin U_Y_origin'];
        command = ['save ' obj.file_mat list_data_sauv];
        
        eval(command)
    end
    
end
