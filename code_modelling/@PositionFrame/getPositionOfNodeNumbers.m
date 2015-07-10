function points = getPositionOfNodeNumbers(obj, nodeNumbers)
%return position of a subset of nodes, specified by nodenumbers

    points = [obj.xValNodes(1, nodeNumbers); ...
        obj.yValNodes(1, nodeNumbers)];

end
