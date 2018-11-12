I = im2double(imread('latent.bmp'));
w = 32;
[M1, N1] = size(I);
block_x = (0 : floor((M1-w)/(w/4)) ) * w / 4 + 1; % separating into blocks
block_y = (0 : floor((N1-w)/(w/4)) ) * w / 4 + 1;

O = localOrientation(I, w, block_x, block_y, 0);
M = size(O, 1); 
N = size(O, 2);

plotOrientation(I, O, w, block_x, block_y);


%%
temp = O(44:46, 44:46);
var(temp(:))

%% BFS
start = round([M/2, N/2]);
expansion = [1 0; 0 -1; -1 0; 0 1];
area = ones(M, N)*(-1); % fingerprint area
closedTable = zeros(M*N, 2);
cur = 1; total = 1;
closedTable(1, :) = start;
varThresh = 0.3;

while cur <= total
    pos = closedTable(cur, :);
    cur = cur + 1;
    for i = 1 : 4
        adjacentPos = pos + expansion(i, :);
        x = adjacentPos(1);
        y = adjacentPos(2);
        if area(x, y) == -1
            if x<=2 || y<=2 || M-x<=2 || N-y<=2
                area(x,y) = nan;
            else
                regionOrientation = O(x-1:x+1, y-1:y+1);
                if var(regionOrientation(:))<varThresh && ~isnan(area(x,y))
                    area(x, y) = O(x, y);
                    total = total + 1;
                    closedTable(total, :) = adjacentPos;
                else
                    area(x, y) = nan;
                end
            end
        end
    end
end

area(area==-1) = nan;

plotOrientation(I, area, w, block_x, block_y);


%%

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
