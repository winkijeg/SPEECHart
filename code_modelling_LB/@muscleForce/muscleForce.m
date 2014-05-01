classdef muscleForce
    % collect force values for all muscle fibers 
    %   Every muscle contains several fibers providing the same force each.
    %   The CSAs are the cross sectional areas of these fibers.
    %   The value of rho (force) is proportional to the CSAs.
    
    properties
        GG; % Force associated with genioglossus
        Hyo; % Force associated with hyoglossus
        Stylo; % Force associated with styloglossus
        SL; % Force associated with longitudinalis superior
        IL; % Force associated with longitudinalis inferior
        Vert; % Force associated with vertical fibres
    end
    
    methods
        function rho = muscleForce(K_m, CSA_GG, CSA_Hyo, CSA_Stylo, CSA_SL, CSA_IL, CSA_Vert)
            
            rho.GG    = CSA_GG * K_m;
            rho.Hyo   = CSA_Hyo * K_m;
            rho.Stylo = CSA_Stylo * K_m;
            rho.SL    = CSA_SL * K_m;
            rho.IL    = CSA_IL * K_m;
            rho.Vert  = CSA_Vert * K_m;
        end
    end
    
end

