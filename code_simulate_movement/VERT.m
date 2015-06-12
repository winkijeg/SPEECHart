function VERT(U)
% calculate force acting on verticalis muscle

% global input variables
global NNxMMx2;                 % Offset de U' dans U
global Att_Vert;                % attachment points of the Vert
global XY;                      % node positions
global LAMBDA_Vert MU;          % to calculate the activation of Vert
global rho_Vert c;              % to calculate the force of the Vert
global f1 f2 f3 f4 f5;          % Idem
global longrepos_Vert;          % Idem
global t_i;                     % 'Temps entier' pout ACTIV_T
global fac_Vert;


% global input/output variables
global FXY                      % force exerted by each node
global ACTIV_T                  % muscle activation

% global output variables
global ForceVert                % force exerted by each fiber


for k = 1:6     % loop the number of fibers
    
    longtot = 0;
    for j = Att_Vert(k,2):-1:Att_Vert(k,1)+1
        v1 = 2 * j; 
        long(j) = sqrt((XY(v1-1)-XY(v1-3))^2+(XY(v1)-XY(v1-2))^2);
        longtot = longtot + long(j);
    end
    
    LongdotVert(k) = ((XY(Att_Vert(k,4)-1)-XY(Att_Vert(k,3)-1)) * U(NNxMMx2+Att_Vert(k,4)-1)+(XY(Att_Vert(k,4))-XY(Att_Vert(k,3)))*U(NNxMMx2+Att_Vert(k,4)))/longtot;
    Activ1 = (longtot-LAMBDA_Vert(k)+MU*LongdotVert(k));
    if Activ1 > 0
        ForceVert(k) = rho_Vert*(exp(c*Activ1)-1);
        ForceVert(k) = ForceVert(k)*(f1+f2*atan(f3+f4*LongdotVert(k)/longrepos_Vert(k))+f5*LongdotVert(k)/longrepos_Vert(k));
        ForceVert(k) = ForceVert(k)/fac_Vert(k);
        
        if ForceVert(k) > 20
            ForceVert(k) = 20;
        end
        
        FXY(Att_Vert(k,4)-1) = FXY(Att_Vert(k,4)-1)-(XY(Att_Vert(k,4)-1)-XY(Att_Vert(k,4)-3))/long(Att_Vert(k,2))*ForceVert(k);
        FXY(Att_Vert(k,4)) = FXY(Att_Vert(k,4))-(XY(Att_Vert(k,4))-XY(Att_Vert(k,4)-2))/long(Att_Vert(k,2))*ForceVert(k);
        FXY(Att_Vert(k,3)-1) = FXY(Att_Vert(k,3)-1)-(XY(Att_Vert(k,3)-1)-XY(Att_Vert(k,3)+1))/long(Att_Vert(k,1)+1)*ForceVert(k);
        FXY(Att_Vert(k,3)) = FXY(Att_Vert(k,3))-(XY(Att_Vert(k,3))-XY(Att_Vert(k,3)+2))/long(Att_Vert(k,1)+1)*ForceVert(k);
        
        for j = Att_Vert(k,2)-1:-1:Att_Vert(k,1)+1
            v1 = 2 * j;
            FXY(v1-1) = FXY(v1-1)-(XY(v1-1)-XY(v1+1))/long(j+1)*ForceVert(k);
            FXY(v1) = FXY(v1)-(XY(v1)-XY(v1+2))/long(j+1)*ForceVert(k);
            FXY(v1-1) = FXY(v1-1)-(XY(v1-1)-XY(v1-3))/long(j)*ForceVert(k);
            FXY(v1) = FXY(v1)-(XY(v1)-XY(v1-2))/long(j)*ForceVert(k);
        end
        
    else
        
        ForceVert(k) = 0;
    
    end
end

ACTIV_T(t_i, 7) = Activ1;

end
