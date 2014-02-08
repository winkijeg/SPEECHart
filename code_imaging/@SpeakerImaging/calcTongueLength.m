function [val, basicData] = calcTongueLength(innerPtPart, indStart, indEnd)
% calculate tongue length by summing up piecewise linear approximation 

lenTotal = 0;
for k = indStart:indEnd-1
    
    p_cur = innerPtPart(1:2, k);
    p_next = innerPtPart(1:2, k+1);
    
    distTmp = points_dist_nd(2, p_cur', p_next');
    
    lenTotal = lenTotal + distTmp;
end

val = lenTotal;

basicData.ptStart = innerPtPart(1:2, indStart);
basicData.ptEnd = innerPtPart(1:2, indEnd);
basicData.contPart = innerPtPart(1:2, indStart:indEnd);

end
