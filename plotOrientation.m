function plotOrientation(I, O, fingerprint, w)
% Present 1. Blue lines: orientation in fingerprint area
% 2. Yellow dots: background area
    [M, N] = size(I);
    block_x = (0 : floor((M-w)/(w/4)) ) * w / 4 + 1; 
    block_y = (0 : floor((N-w)/(w/4)) ) * w / 4 + 1;
    imshow(I);
    hold on;
    [m, n] = size(O);
    for i = 1:m
        for j = 1:n
            center_x = block_x(i) + ceil(w/2);
            center_y = block_y(j) + ceil(w/2);
            if fingerprint(block_x(i)+w-1, block_y(j)+w-1) && ...
                    fingerprint(block_x(i), block_y(j))
                theta = O(i, j);
                len = w/8;
                line([center_y - len * sin(theta), center_y + len * sin(theta)],...
                    [center_x - len * cos(theta), center_x + len * cos(theta)], 'linewidth', 2);
            else
                plot(center_y, center_x, '-y.', 'LineWidth', 2, 'MarkerSize', 10);
            end
        end
    end
end