classdef tongueSim
    
    properties (Access = private)
        % -----
        % coordinates
        XY % Vector containing the tongue shape, odd = x; even = y
        
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
        NN % number of rows of tongue shape matrix
        MM % number of columns of tongue shape matrix
        
        % -----
        % tongue constants
        lambda % elastic modulus
        mu % shear
        
        % -----
        % Gaussian variables for squaring the elasticity matrix
        order = 2; % unclear
        H = [2., 0, 0; 1., 1., 0; 0.555556, 0.888889, 0.555556;];
        G = [0., 0, 0; -0.577350, 0.577350, 0; -0.774597, 0., 0.774597;];
    end
    methods (Access = private)
        function TSObj = tongueSim(path_model, spkStr, seq, out_file, ...
                delta_lambda_ggp, delta_lambda_gga, delta_lambda_hyo, ...
                delta_lambda_sty, delta_lambda_ver, delta_lambda_sl, ...
                delta_lambda_il, t_trans, t_hold, jaw_rot, lip_prot, ...
                ll_rot, hyoid_mov, light)
            
        end
        A0 = elast_init(TSObj,activGGA,activGGP,activHyo,activStylo,activSL,...
            activVert,ncontact);
        K = K(TSObj, r, s, XY, lambda2, mu2, pfix);
    end
    
end