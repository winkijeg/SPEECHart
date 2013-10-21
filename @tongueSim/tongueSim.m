classdef tongueSim < handle
    
    properties (Access = public)
        % General Properties
        SEQUENCE
        speaker
        
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
        
        % -----
        % tongue constants
        lambda % elastic modulus
        mu % shear
        
        % -----
        % Gaussian variables for squaring the elasticity matrix
        order = 2; % unclear
        H = [2., 0, 0; 1., 1., 0; 0.555556, 0.888889, 0.555556;];
        G = [0., 0, 0; -0.577350, 0.577350, 0; -0.774597, 0., 0.774597;];
        
        f1; f2; f3; f4; f5;          % Coefficients for computing forces
        MU; c;                    % Idem
        f; F;                     % frication constant and frication matrix
        PXY;                     % Weight
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
        % Flags that might ahve to be made accessable by setter functions
        CALC_ELA = 1; %Calculate elasticity matrix every time (every what
        Pref; DoPress;            % reference pressure
        PRESS_FLAG;              % semaphore for display (temp)
        PressDebug;              % Semaphore for debugging

        contact;               % Variable indicating wether contact has been made
                               % (for press.m only) (PP Mars 2000)


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
            TSObj.initSequence(seq);
            TSObj.speaker = spkStr;
            TSObj.cont = vtcontour([path_model filesep 'data_palais_repos_' spkStr], 'frenchmat');
            TSObj.restpos = restPos([path_model filesep 'XY_repos_' spkStr], 'frenchmat');
            TSObj.restpos.interpolate(TSObj.fact);
            %TSObj.initMass();
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
        function plot(TSObj)
            TSObj.cont.plot();
            TSObj.restpos.plot();
        end
    end
    
end