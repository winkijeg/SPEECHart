function initVariables( TSObj )
	

	% Indexing variables used for the calculation of the elasticity matrix A0

	TSObj.IX=[1,3,5,7];
	TSObj.IY=[2,4,6,8];
	iaa=[1,5,2,6,3,7,4,8];
	TSObj.IA=repmat(iaa, 1, 8);
	TSObj.IB=[ones(1,8),5*ones(1,8),2*ones(1,8),6*ones(1,8),3*ones(1,8),...
		7*ones(1,8),4*ones(1,8),8*ones(1,8)];
	icx=[0,9,0,9,0,9,0,9];
	iccx=[1,0,1,0,1,0,1,0];
	icy=[9,0,9,0,9,0,9,0];
	iccy=[0,1,0,1,0,1,0,1];
	TSObj.IC=[icx+iccx,icy+5*iccy,icx+2*iccx,icy+6*iccy,icx+3*iccx,icy+7*iccy,...
		icx+4*iccx,icy+8*iccy];
	idd=[5,1,6,2,7,3,8,4];
	TSObj.ID=repmat(idd, 1, 8);
	TSObj.IE=[5*ones(1,8),1*ones(1,8),6*ones(1,8),2*ones(1,8),7*ones(1,8),...
		3*ones(1,8),8*ones(1,8),4*ones(1,8)];


	% Gaussian variables used for squaring A0
	% In this way, calculating the integral is replaced by a sum: SUM(Hi*f(Gi))


	TSObj.order=2;

	TSObj.H(1,1)=2.;
	TSObj.H(2,1)=1.;
	TSObj.H(2,2)=1.;
	TSObj.H(3,1)=0.555556;
	TSObj.H(3,2)=0.888889;
	TSObj.H(3,3)=0.555556;

	TSObj.G(1,1)=0.;
	TSObj.G(2,1)=-0.577350;
	TSObj.G(2,2)=0.577350;
	TSObj.G(3,1)=-0.774597;
	TSObj.G(3,2)=0.;
	TSObj.G(3,3)=0.774597;

	% Creation of the force vector FXY which is applied to the nodes.
	% its dimensions are 2*TSObj.NN*TSObj.MM
	TSObj.FXY=sparse(2*TSObj.NN*TSObj.MM,1);

	% Creation de U et Ufin, vecteurs deplacement de dimension 4*TSObj.NN*TSObj.MM
	% Creation of U and Ufin, displacement vectors of dimension 4*TSObj.NN*TSObj.MM
	TSObj.Ufin=zeros(1,4*TSObj.NN*TSObj.MM);
	TSObj.tfin=0;
	TSObj.LOOP=0;
	TSObj.U=zeros(1,4*TSObj.NN*TSObj.MM);
	TSObj.t=0;
	% TSObj.t0=0;
	TSObj.U0=[TSObj.U(size(TSObj.t)*[0;1],1:2*TSObj.NN*TSObj.MM)]';
	TSObj.U0(2*TSObj.NN*TSObj.MM+1:4*TSObj.NN*TSObj.MM,1)=zeros(2*TSObj.NN*TSObj.MM,1);


	% --------------------------------------------------------
	% Constantes de la langue
	% Tongue constants
	% nu : rapport de Poisson (Poisson's ratio)
	% E  : module d'Young (Young's modulus: stiffness)

	nu=0.49;
	% E=0.7; Valeur de Yohan dans sa these
	E = 0.35;
	% Constantes d'elasticite lambda et mu
	TSObj.lambda=(nu*E)/((1+nu)*(1-2*nu)); % elastic modulus
	TSObj.mu=E/(2*(1+nu)); % shear


	TSObj.TEMPS = 0;
	TSObj.FXY_T = zeros(1, 2*TSObj.MM*TSObj.NN);
	TSObj.ACCL_T = zeros(1, 2*TSObj.MM*TSObj.NN);
	TSObj.ACTIV_T = 0;
	TSObj.LAMBDA_T = 0;

