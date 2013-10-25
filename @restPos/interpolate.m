function rp = interpolate( rp, fact )
%INTERPOLATE Interpolate tongue grid by a factor 
%   RP = INTERPOLATE(FACT)
%   Interpolates the tongue grid by factor FACT. The result is stored in
%   the properties X0 and Y0 as well as in collapsed form in XY.
%   Lasse Bombien (Oct 21 2013)

[MM, NN] = size(rp.X_rest);
rp.fact = fact;
disp('Calculating rest positions');
% preallocate for (a marginal gain of) speed
rp.X0 = zeros(fact*(MM-1)+1,fact*(NN-1)+1);
rp.Y0 = zeros(fact*(MM-1)+1,fact*(NN-1)+1);

% Intrepolate the rest positions as a function of the number of nodes
for j = 1:MM
    rp.X0(fact*(j-1)+1, 1:fact*(NN-1)+1) = interp1(1:NN, rp.X_rest(j,1:NN), 1:1/fact:NN,'spline');
end

for j=1:NN
    rp.Y0(1:fact*(MM-1)+1,fact*(j-1)+1)=interp1(1:MM,rp.Y_rest(1:MM,j),1:1/fact:MM,'spline')';
end

for j=1:fact*(NN-1)+1 % = 1:size(rp.X0,2)
    rp.X0(:,j)=interp1(find(rp.X0(:,j)),nonzeros(rp.X0(:,j)),1:fact*(MM-1)+1,'spline')';
end

for j=1:fact*(MM-1)+1% = 1:size(rp.X0,1)
    rp.Y0(j,:)=interp1(find(rp.Y0(j,:)),nonzeros(rp.Y0(j,:)),1:fact*(NN-1)+1,'spline');
end

[MM, NN] = size(rp.X0);

% % PP juli 2011 - Detection tongue root node on the tongue_lar contour
% for itongue_lar = length(tongue_lar)-1:-1:1
%     if tongue_lar(2,itongue_lar) >= rp.Y0(1,NN)-1 
%         ideptongue_lar = itongue_lar + 1;
%         break;
%     end
% end
% tongue_lar_mri = tongue_lar(:, ideptongue_lar:end); % PP Juli 2011

% --------------------------------------------------------
% Calculate the rest position of the nodes in the form of XY.
% The coordinates of the nodes are arranged succesively, row
% by row:
% XY(i) i odd  : x coordinate
% XY(i) i even: y coordinate

rp.XY=zeros((MM-1)*2*NN+2*NN,1);
tX0 = rp.X0'; tY0 = rp.Y0';
rp.XY = [tX0(:) tY0(:)]'; 
rp.XY = rp.XY(:);
rp.NN = NN;
rp.MM = MM;
end

