I = im2double(imread('phone.bmp'));
[M, N] = size(I);
w = 32;
block_x = (0 : floor((M-w)/(w/4)) ) * w / 4 + 1; % separating into blocks
block_y = (0 : floor((N-w)/(w/4)) ) * w / 4 + 1;
% 

J = filter2(fspecial('sobel'), I);
J = filter2(fspecial('average', 3), J);
J = histeq(I);
imshow(J)
%J = normalization(J, 0, 0.1);
O = localOrientation(J, w, block_x, block_y, 20);
plotOrientation(J, O, w, block_x, block_y);


function plotOrientation(I, O, w, block_x, block_y)
    imshow(I);
    hold on;
    [m, n] = size(O);
    for i = 1:m
        for j = 1:n
            center_x = block_x(i) + ceil(w/2);
            center_y = block_y(j) + ceil(w/2);
            theta = O(i, j);
            line([center_y - w/4 * sin(theta), center_y + w/4 * sin(theta)],...
                [center_x - w/4 * cos(theta), center_x + w/4 * cos(theta)], 'linewidth', 1);
        end
    end
end


