function [tMatGeom, tformImg] = calcTransformationImgToModel( obj )
% calculate transform from MRI coordinate space to generic coordinates (model)
%   function returns two matrices:
%   - tMat: to be used with geometric coordinates
%   - tform: to be used with image transformation

    pt_ANS_generic = obj.modelGeneric.landmarks.xyANS;
    pt_PNS_generic = obj.modelGeneric.landmarks.xyPNS;
    pt_origin_generic = obj.modelGeneric.landmarks.xyOrigin;

    pt_ANS_mri = obj.landmarks.xyANS;
    pt_PNS_mri = obj.landmarks.xyPNS;
    pt_origin_mri = obj.landmarks.xyOrigin;

    % determine ANS-PNS orientation in the generic (model) space
    angle_GenericRad = lines_exp_angle_nd(2, pt_PNS_generic', ...
        [pt_ANS_generic(1) pt_PNS_generic(2)], pt_PNS_generic', pt_ANS_generic');
    angle_GenericDegree = radians_to_degrees(angle_GenericRad);

    % determine ANS-PNS orientation in the mri space
    angle_MriRad = lines_exp_angle_nd(2, pt_PNS_mri', ...
        [pt_ANS_mri(1) pt_PNS_mri(2)], pt_PNS_mri', pt_ANS_mri');
    angleMriDegree = radians_to_degrees(angle_MriRad);

    % calculate difference between angles
    angle_RotationDegree = angle_GenericDegree - angleMriDegree;
    angle_RotationRad = degrees_to_radians(angle_RotationDegree);

    % derive transfomation matrix from MRI to model coordinates
    tMat = tmat_init();

    % first translate to the center of rotation
    offset_AP = -1 * pt_ANS_mri(1);
    offset_IS = -1 * pt_ANS_mri(2);
    tMat1 = tmat_trans(tMat, [0 offset_AP offset_IS]);
    
    % rotate according to angle ANS-PNS in the generic model
    tMat2 = tmat_rot_axis(tMat1, -1*angle_RotationDegree, 'X');
    
    % translation according to the offset between the two origins
    originMRI3D = [0; pt_origin_mri];
    originMRI3DTrans = tmat_mxp(tMat2, originMRI3D);
    originMRI2DTrans(1:2, 1) = originMRI3DTrans(2:3);
    diffOrigins = originMRI2DTrans - pt_origin_generic;

    tx = -1 * diffOrigins(1);
    ty = -1 * diffOrigins(2);

    tMat3 = tmat_trans(tMat2, [0 tx ty]);
 
    % assign matrix for contours and landmarks 
    tMatGeom = tMat3;
    
    % create matrix in order to transform the MRI image
    % TODO: implement stuff regarding the image to be displayed
%     t1 = [1 0 0; 0 1 0; offset_AP offset_IS 1];
%     tform1 = maketform('affine', t1);
% 
%     t2 = [cos(angle_RotationRad) sin(angle_RotationRad) 0; ...
%         -sin(angle_RotationRad) cos(angle_RotationRad) 0; 0 0 1];
%     tform2 = maketform('affine', t2);
% 
%     t3 = [1 0 0; 0 1 0; -tx -ty 1];
%     tform3 = maketform('affine', t3);
% 
%     % assign matrix for MRI image
%     tformImg = maketform('composite', tform1);
    tformImg = [];

end
