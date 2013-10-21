function rp = initFromFrenchMatfile(rp, source)
%INITFROMFRENCHMATFILE Read restpositions from a mat file
%   RP = INITFROMFRENCHMATFILE(SOURCE)
%   Reads restpositions from SOURCE, i.e. the path to a mat file in the
%   format provided with the original test suite
%   Lasse Bombien (Oct 21 2013)

try
    load(source);
    rp.X_rest               = X_repos;
    rp.Y_rest               = Y_repos;
    rp.fac_GGA              = fac_GGA;
    rp.fac_GGP              = fac_GGP;
    rp.fac_Hyo              = fac_Hyo;
    rp.fac_IL               = fac_IL;
    rp.fac_SL               = fac_SL;
    rp.fac_Stylo            = fac_Stylo;
    rp.fac_Vert             = fac_Vert;
    rp.max_restLength_GGA   = longrepos_GGA_max;
    rp.max_restLength_GGP   = longrepos_GGP_max;
    rp.max_restLength_Hyo   = longrepos_Hyo_max;
    rp.max_restLength_IL    = longrepos_IL_max;
    rp.max_restLength_SL    = longrepos_SL_max;
    rp.max_restLength_Stylo = longrepos_Stylo_max;
    rp.max_restLength_Vert  = longrepos_Vert_max;
catch err
    error('%s', err.message);
end
end