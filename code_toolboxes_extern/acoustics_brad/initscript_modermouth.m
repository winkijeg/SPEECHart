%this is a script that defines a structure p
% structure contains all variables for the 3-mass
% and bar-plate models

%constants
clear c p t
c.mu = 	5000;  %shear modulus in cover
c.mub =  5000;
c.muc = 	5000;   %shear modulus in body
c.rho = 	1.04;    %tissue density
c.R = 	3.0;		%torque ratio
c.G = 	0.2;		%gain of elongation
c.H = 	0.2;		%adductory strain factor
c.Lo = 	1.6;	   %cadaveric rest length
c.To = 	0.3;		%resting thickness -old value 0.45 cm
c.Dmo =	0.4;		%resting depth of muscle
c.Dlo = 	0.2;		%resting depth of deep layer
c.Dco =  0.2;	   %resting depth of the cover
c.zeta = 0.1;
c.Csound = 35000.0; % speed of sound
c.rhoc = 39.9;  %rho * speed of sound for air
c.xibR = 0.1;
c.xibL = 0.1;
c.xcv = 0.4;
c.phi0 = 0;
c.pgap = 0.0;
c.ny = 21;
c.nz = 15;
c.npR = 0.75;
c.npL = 0.75;
c.phi0R = 0;;
c.phi0L = 0;
c.asym = 0;



p.ic =  	1; %moment of inertia
p.bc = 	1; %rotational damping
p.kr = 	1; %rotational stiffness
p.ta = 	1; %aerodynamic torque
p.fa = 	1; %force at the nodal point
p.M = 	1; %body mass
p.B =		1; %body damping
p.K =		1; %body stiffness
p.m =		1; %cover mass
p.b = 	1; %cover damping
p.k =		1; %cover stiffness
p.x02 =	0.0; %upper prephonatory displacement
p.x01 =	0.0001;
p.th0 =	1; %prephonatory convergence angle
p.x0 =	1;
p.xb0 =	0.6;
p.T =		1; %thickness of the vocal folds
p.L = 	1; %length of the vocal folds
p.Dc =	0; %depth of cover
p.Db = 	0; %depth of body
p.zn = 	0; %nodal point as measured from the bottom of the vocal folds
p.a1 = 	0; %glottal entry area
p.a2 =	0; %glottal exit area
p.an = 	0; %area at the nodal point
p.ga = 	0; %glottal area
p.ca = 	0; %contact area
p.m1 =	0; %lower mass
p.m2 = 	0; %upper mass
p.k1 =	0; %lower stiffness
p.k2 =	0; %upper stiffness
p.kc = 	0; %coupling stiffness
p.b1 = 	0; %lower damping coeff
p.b2 = 	0; %upper damping coeff
p.pg =   0; %mean intraglottal pressure
p.p1 =  	0; %pressure on lower mass
p.p2 =	0; %pressure on upper mass
p.ps =	0; %subglottal pressure
p.pkd = 0;
p.PL = 	7840;
p.ph = 	0; %hydrostatic pressure
p.pe = 	0; %supraglottal (epilaryngeal) pressure
p.psg = 0;
p.f1 = 	0; %force on lower mass
p.f2 =	0; %force on upper mass
p.u = 	0; %glottal flow
p.zc = 	0; %the contact point

p.act =	.25; %ct activity
p.ata = .25; %ta activity
p.alc	=.5; %lca activity
p.apc =	0; %pca activity
p.eps = 	0; %strain
p.xc = 	0; %glottal convergence
p.xn =   0; %xnode
p.zc = 	0;
p.x1 =	0;
p.x2 =	0;
p.xn0 = 	0; %initial position of xnode

p.sigb = 1;	%body fiber stress
p.sigl = 1; %passive ligament stress
p.sigm = 1; %muscle stress;
p.sigam = 1050000;%max active muscle stress
p.sigp = 1; %passive muscle stress;
p.sigmuc = 1;
p.sigc = 1;

p.Al = 0.05;	%cross sectional area of ligament
p.Am = 0.03; 	%cross sectional area of muscle
p.Ac = 0.0195; %cross sectional area of cover

p.Fob = 1;
p.Foc1 = 1;
p.Foc2 = 1;


p.b = 0;	%quadratic coeff for muscle stress
p.epsm = 0;   %optimum strain

p.delta= 0.0000001;
p.Ae = 1000000.0;
p.As = 1000000;

p.x01R = 0;
p.x01L = 0;
p.x02R = 0;
p.x02L = 0;
