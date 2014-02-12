function [tMatGeom, tformImg] = calcTransformationImgToModel( obj )
% calculate transform from MRI coordinate space to generic coordinates (model)
%   this function returns two matrices:
%   tMat: to be used with geometric coordinates
%   tform: to be used with image transformation

pt_ANS_generic = obj.modelGeneric.landmarks.ANS;
pt_PNS_generic = obj.modelGeneric.landmarks.PNS;

pt_ANS_mri = obj.landmarks.ANS;
pt_PNS_mri = obj.landmarks.PNS;

% determine ANS-PNS orientation in the generic (model) space
angle_GenericRad = lines_exp_angle_nd(2, pt_PNS_generic', ...
    [pt_ANS_generic(1) pt_PNS_generic(2)], pt_PNS_generic', pt_ANS_generic');
angle_GenericDegree = radians_to_degrees(angle_GenericRad);

% determine ANS-PNS orientation in the speaker (mri) space
angle_MriRad = lines_exp_angle_nd(2, pt_PNS_mri', ...
    [pt_ANS_mri(1) pt_PNS_mri(2)], pt_PNS_mri', pt_ANS_mri');
angleMriDegree = radians_to_degrees(angle_MriRad);

% calculate difference between angles
angle_RotationDegree = angle_GenericDegree - angleMriDegree;
angle_RotationRad = degrees_to_radians(angle_RotationDegree);


% derives transfomation matrix from MRI to genaral model coordinates
tMat = tmat_init();

% first translate to the center of rotation
offset_AP = -1 * pt_ANS_mri(1);
offset_IS = -1 * pt_ANS_mri(2);
tMat1 = tmat_trans(tMat, [0 offset_AP offset_IS]);
t1 = [1 0 0; 0 1 0; offset_AP offset_IS 1];
tform1 = maketform('affine', t1);

% rotate according to angle ANS-PNS in the generic model
tMat2 = tmat_rot_axis(tMat1, -1*angle_RotationDegree, 'X');
t2 = [cos(angle_RotationRad) sin(angle_RotationRad) 0; ...
    -sin(angle_RotationRad) cos(angle_RotationRad) 0; 0 0 1];
tform2 = maketform('affine', t2);

% translation to ANS of generic model
tx = pt_ANS_generic(1);
ty = pt_ANS_generic(2);

tMat3 = tmat_trans(tMat2, [0 tx ty]);
t3 = [1 0 0; 0 1 0; -tx -ty 1];
tform3 = maketform('affine', t3);

tMatGeom = tMat3;
tformImg = maketform('composite', tform1);

end
