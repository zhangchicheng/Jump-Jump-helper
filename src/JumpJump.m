function JumpJump()

warning('off','images:initSize:adjustingMag')
normal_magic_number = 1.35;

counter = 0;

while true
    % Pull the screenshot
    image = pullScreencap;
    piece = findPiece(image);
    [h,~,~] = size(image);
    newh = floor(h*0.25);
    tmpPiece = piece;
    tmpPiece(2) = tmpPiece(2)-newh+1;
    
    bin = edge(rgb2gray(image),'canny');
    
    ROI = edge(rgb2gray(image(newh:piece(2),:,:)),'canny');
    
    % crop image based on piece
    
    [center, top, lines] = detectSquare(ROI);
    
    isSquare = false;
    if ~isempty(center)
        center = floor(center);
        isSquare = validateSquare(tmpPiece,top);
        if ~isSquare
            params.minMajorAxis = 200;
            params.maxMajorAxis = 500;
            ell = ellipseDetection(ROI, params);
            center = floor(ell(1:2));
        end
    else
        params.minMajorAxis = 200;
        params.maxMajorAxis = 500;
        ell = ellipseDetection(ROI, params);
        center = floor(ell(1:2));
    end
    
    % visulize
    if ~isempty(center) && ~isempty(piece)
        imshow(bin)
        hold on
        if isSquare
            for k = 1:length(lines)
                xy = [lines(k).point1; lines(k).point2];
                plot(xy(:,1),xy(:,2)+newh-1,'LineWidth',2,'Color','green');
            end
        else
            visualizeEllipse(ell(:,3),ell(:,4),ell(:,5)*pi/180,ell(:,1),ell(:,2)+newh-1,'r');
        end
        
        plot(center(1), center(2)+newh-1, 'Marker', 'o', ...
            'MarkerSize', 10, 'MarkerEdgeColor', 'b', 'MarkerFaceColor', 'b');
        plot(piece(1), piece(2), 'Marker', 'o', ...
            'MarkerSize', 10, 'MarkerFaceColor', 'b', 'MarkerFaceColor', 'b');
        hold off
    else
        fprintf('Maximum score: %d\n', counter);
        break
    end
    
    % jump
    
    jump(pdist([tmpPiece(1), tmpPiece(2); center(1), center(2)], 'euclidean'), ...
        normal_magic_number, ...
        set_press_location(size(image, 1), size(image, 2), 50));
    
    pause(2);
    % Randomize pause
    
    
    % Score counter
    counter = counter + 1;
end

end

function image = pullScreencap()

if strcmpi(computer, 'MACI64') || strcmpi(computer, 'GLNXA64')
    cmd_capture = './adb shell screencap -p /sdcard/autojump.png';
    cmd_pull = './adb pull /sdcard/autojump.png .';
else % Windows
    cmd_capture = 'adb.exe shell screencap -p /sdcard/autojump.png';
    cmd_pull = 'adb.exe pull /sdcard/autojump.png .';
end
[return_1, ~] = system(cmd_capture);
[return_2, ~] = system(cmd_pull);
if return_1 || return_2
    error('Cannot capture screenshots');
end
image = imread('autojump.png');
end

function jump(distance, magic_number, swipe_positions)
press_time = floor(max(distance * magic_number, 100));
if strcmpi(computer, 'MACI64') || strcmpi(computer, 'GLNXA64')
    cmd_jump = sprintf('./adb shell input swipe %d %d %d %d %d', ...
        swipe_positions(1), swipe_positions(2), swipe_positions(3), swipe_positions(4), ...
        press_time);
else % Windows
    cmd_jump = sprintf('adb.exe shell input swipe %d %d %d %d %d', ...
        swipe_positions(1), swipe_positions(2), swipe_positions(3), swipe_positions(4), ...
        press_time);
end
[returns, ~] = system(cmd_jump);
if returns
    error('Cannot jump!')
end
end

function swipe_positions = set_press_location(image_height, image_width, delta)
left    = floor(image_width/2) + randi([-delta, delta]);
top     = floor(1584 * (image_height / 1920.0)) + randi([-delta, delta]);
swipe_positions = [left, top, left, top];
end
