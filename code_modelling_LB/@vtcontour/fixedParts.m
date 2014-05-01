function cnt = fixedParts(cnt)
%FIXEDPARTS Calculation and design of fixed parts: teeth, palate, ...

% Position of the lower teeth
% Indeed, tongue movements must be limited on the level of the lower teeth.
% The file data_palais_repos.mat is read from disk which contains among
% others the lower teeth.
% The vectors Vect_dents et Point_dents are passed to UDOT.m

cnt.Vect_dents=[cnt.lowerteeth(1,11)-cnt.lowerteeth(1,13)-1 cnt.lowerteeth(2,11)-cnt.lowerteeth(2,13)];
cnt.Point_dents=[cnt.lowerteeth(1,13)+1 cnt.lowerteeth(2,13)];
cnt.slope_D=(cnt.lowerteeth(2,11)-cnt.lowerteeth(2,13))/(cnt.lowerteeth(1,11)-cnt.lowerteeth(1,13));
cnt.org_D=cnt.lowerteeth(2,11)-cnt.slope_D*cnt.lowerteeth(1,11);



% Position of palate and velum
% The contact for the production of consonantes will be between the
% different 'superior' nodes of the tongue and the following points
% As akways : odd indices -> X coordinante
%            even indices -> Y coordinate
% Points du palais :
% Points of the palate :
P_palais=(8:length(cnt.palate(1,:))); % On prend tous les points du palais MRI
%(points 1 à 7 = dents standard ajoutée par transform_data_mri (PP Nov06)
% All points from the MRI palate are taken, (points 1 to 7 = standard teeth
% added by transform_data_mri)
for i=1:size(P_palais,2)
    cnt.Point_P(2*i-1)=cnt.palate(1,P_palais(i));
    cnt.Point_P(2*i)=cnt.palate(2,P_palais(i));
end
% Points du velum :
% Points of the velum :
P_velum=(2:(length(cnt.velum(1,:))-5)); % On prend tous les points du palais mou mesurés MRI sauf le premier
% qui correspond au dernier du palais dur (PP Nov06)
% All points of the soft palate are taken exept the first which corresponds
% to the last of the hard palate

for j=i+1:i+size(P_velum,2)
    cnt.Point_P(2*j-1)=cnt.velum(1,P_velum(j-i));
    cnt.Point_P(2*j)=cnt.velum(2,P_velum(j-i));
end
cnt.nbpalais=size(P_palais,2)+size(P_velum,2);

% Calcul des equations de chaque segment du palais
% Calculate the equations of every segment of the palate
cnt.slope_P=zeros(cnt.nbpalais-1,1);
cnt.org_P=zeros(cnt.nbpalais-1,1);
for i=1:cnt.nbpalais-1
    cnt.slope_P(i)=(cnt.Point_P(2*i)-cnt.Point_P(2*i+2))/(cnt.Point_P(2*i-1)-cnt.Point_P(2*i+1));
    cnt.org_P(i)=cnt.Point_P(2*i)-cnt.slope_P(i)*cnt.Point_P(2*i-1);
end

%PP Juli 2011
for i=2:cnt.nbpalais-1
    for j=i-1:-1:1
        if cnt.slope_P(i)<=cnt.slope_P(j)+0.001 && cnt.slope_P(i)>=cnt.slope_P(j)-0.001
            fprintf('Slight displacement (1/4mm) of palate point %i for better contact detection\n',i)
            cnt.Point_P(2*i)=cnt.Point_P(2*i)+0.25;
            cnt.slope_P(i)=(cnt.Point_P(2*i)-cnt.Point_P(2*i+2))/(cnt.Point_P(2*i-1)-cnt.Point_P(2*i+1));
            cnt.org_P(i)=cnt.Point_P(2*i)-cnt.slope_P(i)*cnt.Point_P(2*i-1);
            i_P_prec=i-1;
            cnt.slope_P(i_P_prec)=(cnt.Point_P(2*i_P_prec)-cnt.Point_P(2*i_P_prec+2))/(cnt.Point_P(2*i_P_prec-1)-cnt.Point_P(2*i_P_prec+1));
            cnt.org_P(i_P_prec)=cnt.Point_P(2*i_P_prec)-cnt.slope_P(i_P_prec)*cnt.Point_P(2*i_P_prec-1);
        end
    end
end
