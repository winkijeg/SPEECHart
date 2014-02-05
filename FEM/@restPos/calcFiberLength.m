function calcFiberLength( rp , cont)
	%CALCFIBERLENGTH Calculation of fibre length in rest position
	%	Definition of the factors of the distribution on the fibres
	%	of a muscle and calculation by interpolation if fact>1
	%   cont is a n object of class vtcontour and contains

	%GGP
	restLength_GGP = zeros(1+3*rp.fact, 1);
	for k = 1:size(restLength_GGP,1)
		restLength_GGP(k) = 0;
		o = rp.NN * rp.fact + 1 + (k - 1) * rp.NN; %index of the smaller relevant node
		i = o + rp.NN - rp.fact;                   %index of the larger relevant node
		for j = i : -1 : o+1
			restLength_GGP(k) = restLength_GGP(k) + ...
			sqrt( (rp.XY(2*j-1) - rp.XY(2+j-3))^2 + (rp.XY(2*j) - rp.XY(2*j-1))^2);
		end
	end
	rp.restLength_GGP = restLength_GGP';
	% fac_GGP est lu dans rest_file PP: 16 juillet 2006
	% fac_GGP is read in rest_file

	% GGA
	restLength_GGA = zeros(1+3*rp.fact,1);
		for k=1:size(restLength_GGA,1)  % 6 fibres (apres les comm. de Reiner - Nov 99
			restLength_GGA(k)=0;
			o=4*rp.NN*rp.fact+1+k*rp.NN;
    	i=o+rp.NN-rp.fact;   % on demarre de la surface avec 63 noeuds et de la
    	% ligne en dessous de la surface avec 221 noeuds
    	for j=i:-1:o+1
    		restLength_GGA(k)=restLength_GGA(k) + ...
    		sqrt( (rp.XY(2*j-1) - rp.XY(2*j-3))^2 + (rp.XY(2*j) - rp.XY(2*j-2))^2);
    	end
    end
    rp.restLength_GGA=restLength_GGA';
	% fac_GGA est lu dans rest_file PP: 16 juillet 2006
	% fac_GGA is read in rest_file

	% Hyo
	% this is really obscure
	% GET BACK TO THIS
	i=(5*rp.fact-1)*rp.NN+1+3*rp.fact; % Modifs YP-PP Dec 99
	j=6*rp.fact*rp.NN+1+4*rp.fact; % Modifs YP-PP Dec 99
	long1=sqrt((rp.XY(2*i-1)-cont.X1)^2+(rp.XY(2*i)-cont.Y1)^2);
	long2=sqrt((rp.XY(2*j-1)-rp.XY(2*i-1))^2+(rp.XY(2*j)-rp.XY(2*i))^2);
	i=4*rp.fact*rp.NN+1+4*rp.fact;  % Modifs YP-PP Dec 99
	long_Hyo2=sqrt((rp.XY(2*i-1)-cont.X2)^2+(rp.XY(2*i)-cont.Y2)^2);
	i=3*rp.fact*rp.NN+1+5*rp.fact;    % i=27
	long_Hyo3=sqrt((rp.XY(2*i-1)-cont.X3)^2+(rp.XY(2*i)-cont.Y3)^2);
	rp.restLength_Hyo=[long1+long2;long_Hyo2;long_Hyo3];
	% fac_Hyo est lu dans rest_file PP: 16 juillet 2006

	% Stylo
	if rp.fact~=3
	    j=3*rp.fact*rp.NN+1+4*rp.fact;    % j=26
	    longStylo1=sqrt((rp.XY(2*j-1)-cont.XS)^2+(rp.XY(2*j)-cont.YS)^2);
	    %  i=(8*rp.fact-1)*rp.NN+4*rp.fact;    % Modifs Nov 99 PP-YP
	    i=(7*rp.fact)*rp.NN+4*rp.fact;    % Modifs PP-YP Mars 2000
	    j=4*rp.fact*rp.NN+1+4*rp.fact;    % j=33
	    long1=sqrt((rp.XY(2*i-1)-rp.XY(2*j-1))^2+(rp.XY(2*i)-rp.XY(2*j))^2);
	    long2=sqrt((rp.XY(2*j-1)-cont.XS)^2+(rp.XY(2*j)-cont.YS)^2);
	    restLength_Stylo=[longStylo1;long1+long2];
	else
	    rp.XY(499)=cont.XS;
	    rp.XY(500)=cont.YS;
	    ind_n=[250 115 114:13:192];
	    longtot=0;
	    for j=1:size(ind_n,2)-1
	        long(j)=sqrt((rp.XY(2*ind_n(j+1)-1)-rp.XY(2*ind_n(j)-1))^2+(rp.XY(2*ind_n(j+1))-rp.XY(2*ind_n(j)))^2);
	        longtot=longtot+long(j);
	    end
	    ind_n=[250 101 100:13:204];
	    longtot2=0;
	    for j=1:size(ind_n,2)-1
	        long(j)=sqrt((rp.XY(2*ind_n(j+1)-1)-rp.XY(2*ind_n(j)-1))^2+(rp.XY(2*ind_n(j+1))-rp.XY(2*ind_n(j)))^2);
	        longtot2=longtot2+long(j);
	    end
	    restLength_Stylo=[longtot;longtot2];
	end
	rp.restLength_Stylo = restLength_Stylo;
	% fac_Stylo est lu dans rest_file PP: 16 juillet 2006

	% SL
	% Fibre 1 (Superieure) % Modif Dec 99 YP-PP
	long_SL(1)=0;
	k=rp.fact*(2*rp.NN+6)+1;         % k=21;
	i=rp.NN*rp.MM;                 % i=63;
	long1 = 0;
	for j=k+rp.NN:rp.NN:i
	    long1(j)=sqrt((rp.XY(2*j-1)-rp.XY(2*(j-rp.NN)-1))^2+(rp.XY(2*j)-rp.XY(2*(j-rp.NN)))^2);
	    long_SL(1)=long_SL(1)+long1(j);
	end

	% Fibre 2)
	long_SL(2)=0;
	k=rp.fact*(2*rp.NN+6);
	i=rp.NN*rp.MM-1;
	long2 = 0;
	for j=k+rp.NN:rp.NN:i
	    long2(j)=sqrt((rp.XY(2*j-1)-rp.XY(2*(j-rp.NN)-1))^2+(rp.XY(2*j)-rp.XY(2*(j-rp.NN)))^2);
	    long_SL(2)=long_SL(2)+long2(j);
	end
	rp.restLength_SL=[long_SL(1);long_SL(2)];
	% fac_SL est lu dans rest_file PP: 16 juillet 2006

	% IL
	i=4*rp.fact*rp.NN+2*rp.fact+1;     % i=31;
	j=7*rp.fact*rp.NN+3*rp.fact+1;     % j=53;
	if rp.fact==1
	    k=61;
	else
	    k=221-4;  % CORRECTION APPORTÉE PAR PASCAL LE 4 MAI 1999 POUR CORRIGER
	    % LA FIBRE FAISAIT UN ALLER RETOUR ET N'ALLAIT PAS DANS L'APEX
	end
	long1=sqrt((rp.XY(2*i-1)-cont.X2)^2+(rp.XY(2*i)-cont.Y2)^2);
	long2=sqrt((rp.XY(2*j-1)-rp.XY(2*i-1))^2+(rp.XY(2*j)-rp.XY(2*i))^2);
	long3=sqrt((rp.XY(2*k-1)-rp.XY(2*j-1))^2+(rp.XY(2*k)-rp.XY(2*j))^2);
	rp.restLength_IL=long1+long2+long3;
	% fac_IL est lu dans rest_file PP: 16 juillet 2006

	% Vert
	restLength_Vert = 0;
	for k=1:3*rp.fact %Modifs Dec 99 YP-PP
	    restLength_Vert(k)=0;
	    l=(k-1)*rp.NN+rp.fact*(5*rp.NN+3)+1; %Modifs Dec 99 YP-PP
	    i=(k-1)*rp.NN+rp.fact*(5*rp.NN+6); %Modifs Dec 99 YP-PP
	    for j=i:-1:l+1
	        restLength_Vert(k)=restLength_Vert(k)+sqrt((rp.XY(2*j-1)-rp.XY(2*j-3))^2+(rp.XY(2*j)-rp.XY(2*j-2))^2);
	    end
	end
	rp.restLength_Vert=restLength_Vert';
	% fac_Vert est lu dans rest_file PP: 16 juillet 2006

