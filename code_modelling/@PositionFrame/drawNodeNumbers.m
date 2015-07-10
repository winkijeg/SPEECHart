function h = drawNodeNumbers(obj, col)
%draw node numbers but no mesh nodes

    for nbNode = 1:obj.nNodes

        h(nbNode) = text(obj.xValNodes(nbNode), obj.yValNodes(nbNode), ...
            num2str(nbNode), 'Color', col);

    end

end

