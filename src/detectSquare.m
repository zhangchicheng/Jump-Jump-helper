function [center, top, resLines] = detectSquare(ROI)
% ROI is binary image after edge detection

[H,T,R] = hough(ROI);
P  = houghpeaks(H,50,'threshold',0);

lines = houghlines(ROI,T,R,P,'FillGap',5,'MinLength',120);

if ~isempty(lines)
    
    % only reserve lines that theta is 60 or -60
    theta = [lines.theta];
    tmpLines = lines(theta == 60 | theta == -60);
    
    if ~isempty(tmpLines)
        
        % find top point and adjacent lines
        p1 = reshape([tmpLines.point1],2,[]);
        p2 = reshape([tmpLines.point2],2,[]);
        p = [p1(2,:); p2(2,:)];
        [~, idx] = min(min(p));
        
        resLines(1) = tmpLines(idx);
        if resLines(1).point1(2) < resLines(1).point2(2)
            top = resLines(1).point1;
        else
            top = resLines(1).point2;
        end
        center = [top(1) top(2)+floor(pdist([resLines(1).point1; resLines(1).point2])/2)];
        tmpLines(idx) = [];
        
        for i = 1:numel(tmpLines)
            if tmpLines(i).theta == -resLines(1).theta
                tp1 = [tmpLines(i).point1];
                tp2 = [tmpLines(i).point2];
                if pdist([tp1; resLines(1).point1]) < 5 || pdist([tp2; resLines(1).point1]) < 5
                    resLines(end+1) = tmpLines(i);
                end
                if pdist([tp1; resLines(1).point2]) < 5 || pdist([tp2; resLines(1).point2]) < 5
                    resLines(end+1) = tmpLines(i);
                end
            end
        end
        
        for j = 1:numel(tmpLines)
            if numel(resLines) > 1 && tmpLines(j).theta == resLines(1).theta
                tp1 = [tmpLines(j).point1];
                tp2 = [tmpLines(j).point2];
                if pdist([tp1; resLines(end).point1]) < 5 || pdist([tp2; resLines(end).point1]) < 5
                    resLines(end+1) = tmpLines(j);
                end
                if pdist([tp1; resLines(end).point2]) < 5 || pdist([tp2; resLines(end).point2]) < 5
                    resLines(end+1) = tmpLines(j);
                end
            end
        end
        
    else
        top = [];
        center = [];
        resLines = tmpLines;
    end
else
    top = [];
    center = [];
    resLines = lines;
end

end
