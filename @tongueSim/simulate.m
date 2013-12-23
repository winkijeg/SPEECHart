function simulate(TSObj)
%SIMULATE Run the simulation

tfseq=TSObj.finalTimeCum;
t0_seq=[0 TSObj.finalTimeCum(1:length(TSObj.finalTimeCum)-1)];
tf=TSObj.finalTimeCum(length(TSObj.finalTimeCum));

%Jaw rotation and its effect on the tongue and the lower lip -- mz 12/27/99
TSObj.UU.lowerlip=zeros(round(200*tf),12); % 30
TSObj.UU.upperlip=zeros(round(200*tf),12); % 46
TSObj.UU.lowerteeth=zeros(round(200*tf),10); % 34     %% GB Mars 2011
TSObj.UU.pharynx_mri=zeros(round(200*tf),13);
TSObj.UU.lar_ar_mri=zeros(round(200*tf),12);
TSObj.UU.tongue_lar_mri=zeros(round(200*tf),17);
% TSObj.UU.mandibule=zeros(round(200*tf),20);
X0_seq=zeros(round(200*tf),221);
Y0_seq=zeros(round(200*tf),221);
ttout=0;
X0_initial=TSObj.restpos.X0;
Y0_initial=TSObj.restpos.Y0;
%

TSObj.jaw_rotation = (pi/180) .* TSObj.jaw_rotation;
TSObj.ll_rotation  = (pi/180) .* TSObj.ll_rotation;

%X_origin=TSObj.cont.X_condyle;
%Y_origin=TSObj.cont.Y_condyle;
 
TSObj.udot3_init();

% Si simulation normal
for ind = 1:length(TSObj.finalTimeCum)
    TSObj.i_Sim = ind;
    if TSObj.i_Sim==1
        tfin=[];Ufin=[];
        theta_start=0;
    else
        theta_start=sum(TSObj.jaw_rotation(1:TSObj.i_Sim-1));
    end
    
    if TSObj.i_Sim==1
        tfin=[];Ufin=[];
        hyoid_start=0;
    else
        hyoid_start=sum(TSObj.hyoid_movment(1:TSObj.i_Sim-1));
    end
    
    X0_rest_pos=TSObj.restpos.X0;Y0_rest_pos=TSObj.restpos.Y0;%intitial tongue position
    
    % the initial angle alpha for each node of the tongue
    alpha_rest_pos = atan2((TSObj.cont.X_condyle-X0_rest_pos), (TSObj.cont.Y_condyle-Y0_rest_pos));
    % the distance of each node of the tongue to the center of rotation
    dist_rest_pos = sqrt( (Y0_rest_pos-TSObj.cont.Y_condyle).^2 + ...
                          (X0_rest_pos-TSObj.cont.X_condyle).^2 );
    
    %the initial angle alpha of the lower incisor
    alpha_rest_pos_dents_inf = atan2((TSObj.cont.X_condyle-TSObj.cont.lowerteeth(1,:)), ...
        (TSObj.cont.Y_condyle-TSObj.cont.lowerteeth(2,:)));
    %the initial distance of the lower incisor to the center of rotation
    dist_rest_pos_dents_inf = sqrt((TSObj.cont.lowerteeth(2,:)-TSObj.cont.Y_condyle).^2 + (TSObj.cont.lowerteeth(1,:)-TSObj.cont.X_condyle).^2);
    
    X_origin_ll=TSObj.cont.X_condyle;
    Y_origin_ll=TSObj.cont.Y_condyle;
    lowlip_initial=TSObj.cont.lowerlip;
    alpha_rest_pos_lowlip=atan2((X_origin_ll-TSObj.cont.lowerlip(1,:)), (Y_origin_ll-TSObj.cont.lowerlip(2,:)));%the initial angle alpha of the lower lip
    dist_rest_pos_lowlip=sqrt((TSObj.cont.lowerlip(2,:)-Y_origin_ll).^2+(TSObj.cont.lowerlip(1,:)-X_origin_ll).^2);%the initial distance of the lower lip to the center of rotation
    TSObj.t_initial=t0_seq(TSObj.i_Sim);
    TSObj.t_transition=t0_seq(TSObj.i_Sim)+TSObj.activationTime(TSObj.i_Sim);
    TSObj.t_final=TSObj.finalTimeCum(TSObj.i_Sim);
    theta=TSObj.jaw_rotation(TSObj.i_Sim);
    theta_ll=TSObj.ll_rotation(TSObj.i_Sim);
    dist_lip=TSObj.lip_protrusion(TSObj.i_Sim);
    dist_hyoid=TSObj.hyoid_movment(TSObj.i_Sim); % GB MARS 2011
    %    figure(300)
    %    plot(X0,Y0,'r+')
    %    pause
    %    hold on
    %
    fprintf('Integrating from %d to %d\n',t0_seq(TSObj.i_Sim), TSObj.finalTimeCum(TSObj.i_Sim));
    if 1 
    	disp('NOT ENTERING ODE45PLUS BECAUSE OF TOO MANY UNNRESOLVED ISSUES.')
    else
    	[ts,Us]=TSObj.ode45plus(@TSObj.udot3_adapt_jaw, t0_seq(TSObj.i_Sim), TSObj.finalTimeCum(TSObj.i_Sim), TSObj.U0, 1e-3, (((3 * TSObj.fact) - 2) / 500));
    
    %       figure(300)
    % plot(X0,Y0,'bo')
    % color='rbmcygrbmcygrbmcygrbmcygkrbmcygrbmcyg';
    % length(ts)
    % for iloop=1:(length(ts)-1)
    %     iloop
    % dess=['*' color(iloop)];
    % plot(X0_seq(iloop,:),Y0_seq(iloop,:),dess)
    % hold on
    % end
    %    pause
    %    plot(X0_seq(length(ts),:),Y0_seq(length(ts),:),'ow', 'LInewidth',2)
    % pause
    	U0=Us(length(ts),:);
    	[TSObj.tfin]=[TSObj. tfin;ts];
    	[TSObj.Ufin]=[TSObj.Ufin;Us];
    end
end
%
if ( TSObj.length_ttout < (200 * tf) )
    TSObj.UU.X_origin=TSObj.UU.X_origin(1:TSObj.length_ttout);
    TSObj.UU.Y_origin=TSObj.UU.Y_origin(1:TSObj.length_ttout);
    TSObj.UU.lowerlip=TSObj.UU.lowerlip(1:TSObj.length_ttout,1:end);
    TSObj.UU.upperlip=TSObj.UU.upperlip(1:TSObj.length_ttout,1:end);
    TSObj.UU.lowerteeth=TSObj.UU.lowerteeth(1:TSObj.length_ttout,1:end);
    TSObj.UU.pharynx_mri=TSObj.UU.pharynx_mri(1:TSObj.length_ttout,1:end);
    TSObj.UU.lar_ar_mri=TSObj.UU.lar_ar_mri(1:TSObj.length_ttout,1:end);
    TSObj.UU.tongue_lar_mri=TSObj.UU.tongue_lar_mri(1:TSObj.length_ttout,1:end);
    %    TSObj.UU.mandibule=TSObj.UU.mandibule(1:TSObj.length_ttout,1:end);
    X0_seq = X0_seq(1:TSObj.length_ttout, 1:221);
    Y0_seq = Y0_seq(1:TSObj.length_ttout, 1:221);
end

t=tfin';
U=Ufin;
