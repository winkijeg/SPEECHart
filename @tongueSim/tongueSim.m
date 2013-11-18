classdef tongueSim < handle
%TONGUESIM a class to handle tongue simulations
%   SEEALSO restPos vtcontour

properties (Access = public)
        % General Properties
        SEQUENCE
        speaker
        spkConf; % an object of class spkConfig
        
        % -----
        % coordinates
        XY % Vector containing the tongue shape, odd = x; even = y
        X0; Y0; X0Y0;					  % Modified by Yohan & Majid; Nov 30, 99

        % -----
        % the vocal tract contour as read from the contour file
        cont; % an object of class vtcontour
        % -----
        % the rest position as read from the rest file
        restpos; % an object of class restPos
        
        
        % Indexing variables used for the calculation of the elasticity matrix A0
        IX;
        IY;
        IA;
        IB;
        IC;
        ID;
        IE;
        
        % -----
        % variables concerning the size of tongue shape matrix
        fact = 2; % scaling factor, preset to 2
        NN = 13% number of rows of tongue shape matrix
        MM = 17% number of columns of tongue shape matrix
        NNxMM %
        NNx2 %
        MMx2 %
        NNxMMx2 %
        Mass % Mass of the nodes
        invMass % inverse of the mass
        A0 % the elasticity matrix
        
        % -----
        % tongue constants
        lambda % elastic modulus
        mu % shear
        
        % Displacement variables
        Ufin; U; tfin; LOOP; t;

        % -----
        % Gaussian variables for squaring the elasticity matrix
        order;
        H;
        G;

        f1; f2; f3; f4; f5;          % Coefficients for computing forces
        MU; c;                    % Idem
        f; F;                     % frication constant and frication matrix
        FXY;                     % Weight
        v1; v2; v3;                % Temporary variables
        
        % Temporary variables 
        aff_fin;
        t_affiche;
        t_verbose;
        nb_contact;
        S_enr;
        X_enr;
        Yn_enr;
        Yp_enr;
        F_enr;
        P_enr;
        V_enr;
        nc;
        pc;
        t_jaw;
        
        % -----
        % Muscle attachment points
        Att_GGP; Att_GGA; Att_Hyo; 
        Att_Stylo; Att_SL; Att_IL; 
        Att_Vert;      

        % -----
        % Muscle forces
        rho; % an object of class muscleForce
        rho_GG; rho_Hyo; rho_Stylo; rho_SL; rho_IL; 
        
        % -----
        % Flags that might ahve to be made accessable by setter functions
        CALC_ELA = 1; %Calculate elasticity matrix every time (every what
        Pref; DoPress;            % reference pressure
        PRESS_FLAG;              % semaphore for display (temp)
        PressDebug;              % Semaphore for debugging

        contact;               % Variable indicating wether contact has been made
                               % (for press.m only) (PP Mars 2000)

        activationTime; % WHATSTHIS
        holdTime; % WHATSTHIS
        n_phon; % WHATSTHIS
        jaw_rotation;
        ll_rotation;
        lip_protrusion;
        hyoid_movment;
        finalTime; finalTimeCum;
        delta_lambda;
        kkk;
        MATRICE_LAMBDA;

    end
    methods (Access = public)
        % Conctructor
        function TSObj = tongueSim(path_model, spkStr, seq, out_file, ...
            delta_lambda_ggp, delta_lambda_gga, delta_lambda_hyo, ...
            delta_lambda_sty, delta_lambda_ver, delta_lambda_sl, ...
            delta_lambda_il, t_trans, t_hold, jaw_rot, lip_prot, ...
            ll_rot, hyoid_mov, light)
            % TONGUESIM Constructor for the tongueSim class
            if (nargin < 1)
            end
            %
            TSObj.initSequence(seq);
            TSObj.speaker = spkStr;
            TSObj.cont = vtcontour([path_model filesep 'data_palais_repos_' spkStr], 'frenchmat');
            TSObj.restpos = restPos([path_model filesep 'XY_repos_' spkStr], 'frenchmat');
            TSObj.spkConf = spkConfig([path_model filesep 'result_stocke_' spkStr], 'frenchmat');

            TSObj.activationTime = t_trans;
            TSObj.holdTime = t_hold;
            TSObj.jaw_rotation = jaw_rot;
            TSObj.ll_rotation = ll_rot;
            TSObj.lip_protrusion = lip_prot;
            TSObj.hyoid_movment = hyoid_mov;
            TSObj.finalTime = TSObj.activationTime + TSObj.holdTime; % combiner le t-rise et le t-hold pour t-final
                                             % combine t_trans (!) and
                                             % t_hold to t_final
            TSObj.finalTimeCum = cumsum(TSObj.finalTime);     % Vector avec le temps final de chaque transition
                                           % Vector with every transitions'
                                           % final times

           TSObj.kkk=0; % ??
            TSObj.rho = muscleForce(0.22, ...% K_m: in N/mm2, value from Van Lunteren & al. 1990
                308/(6*TSObj.fact+1), ...%CSA_GG
                296/3, ... %CSA_Hyo
                40/2, ... %CSA_Stylo
                65, ... %CSA_SL
                88, ... %CSA_IL
                66/(3*TSObj.fact)); %CSA_vert

            TSObj.restpos.interpolate(TSObj.fact);
            TSObj.restpos.calcFiberLength(TSObj.cont);
            TSObj.initVariables();

            TSObj.initMass();

            %A modifier ICI
            %to modify HERE
            TSObj.n_phon = length(TSObj.holdTime);
            TSObj.delta_lambda=[delta_lambda_ggp' delta_lambda_gga' delta_lambda_hyo' delta_lambda_sty' delta_lambda_ver' delta_lambda_sl' delta_lambda_il']';
            TSObj.MATRICE_LAMBDA(:,1) = TSObj.spkConf.configs(1,1:2:14)';

            for np=1:TSObj.n_phon
                TSObj.MATRICE_LAMBDA(:,1+np) = TSObj.delta_lambda(:,np) + TSObj.spkConf.configs(1,1:2:14)';
            end

            TSObj.A0 = TSObj.elast_init(0,0,0,0,0,0,0);
        end
    end

    methods (Access = public) % will al lbecome private

        % Signatures of methods defined in separate files
        A0 = elast_init(TSObj,activGGA,activGGP,activHyo,activStylo,activSL,...
            activVert,ncontact);
        K = K(TSObj, r, s, XY, lambda2, mu2, pfix);
        udot3_init(TSObj);
        initMass(TSObj);
        initSequence(TSObj, seq);
        initVariables(TSObj);
        function plot(TSObj)
            TSObj.cont.plot();
            TSObj.restpos.plot();
        end
    end
    
end