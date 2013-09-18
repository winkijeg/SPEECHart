function [] = plotContours(obj, col)

    plot(obj.contours.outerPt(1, :), obj.contours.outerPt(2, :), col)
    plot(obj.contours.innerPt(1, :), obj.contours.innerPt(2, :), col)

end

