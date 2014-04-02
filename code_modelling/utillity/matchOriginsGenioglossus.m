function originsAdapted = matchOriginsGenioglossus( partOfMentalSpine )
% adapt MRI genioglossus oringins with respect to the generic tongue mesh

% first (lowest) 3 mesh lines
% equaly spced points between first (last) two teeth points
lineSegTmp1 = partOfMentalSpine(1:2, 1:2);
ptsTmp1(1:2, :) = polyline_points_nd(2, 2, lineSegTmp1, 3);
originsAdapted(1:2, 1:3) = ptsTmp1(1:2, 1:3);

% second section (2/3)
lineSegTmp2 = partOfMentalSpine(1:2, 2:3);
ptsTmp2(1:2, :) = polyline_points_nd(2, 2, lineSegTmp2, 7);
originsAdapted(1:2, 4:9) = ptsTmp2(1:2, 2:7);

% third section (3/3)
lineSegTmp3 = partOfMentalSpine(1:2, 3:4);
ptsTmp3 = polyline_points_nd(2, 2, lineSegTmp3, 9);
originsAdapted(1:2, 10:17) = ptsTmp3(1:2, 2:9);

end

