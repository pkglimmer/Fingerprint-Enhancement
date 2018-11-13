function [fingerprint, areaOrientation] = extractFingerprint(I, O, block_x, block_y, w, vthresh1, vthresh2, expand)
    M = size(O, 1); 
    N = size(O, 2);
    brightness = zeros(M, N);
    for i = 1 : length(block_x)
        for j = 1 : length(block_y)
            u = block_x(i); v = block_y(j);
            block_region = I(u:(u+w-1), v:(v+w-1));
            brightness(i, j) = mean(block_region(:));
        end
    end
    start = round([M/2, N/2]);
    expansion = [1 0; 0 -1; -1 0; 0 1];
    area = ones(M, N)*(-1); % fingerprint area
    closedTable = zeros(M*N, 2);
    cur = 1; total = 1;
    closedTable(1, :) = start;
    while cur <= total
        pos = closedTable(cur, :);
        cur = cur + 1;
        for i = 1 : 4
            adjacentPos = pos + expansion(i, :);
            x = adjacentPos(1);
            y = adjacentPos(2);
            if area(x, y) == -1
                if x<=3 || y<=3 || M-x<=3 || N-y<=3
                    area(x,y) = nan;
                else
                    regionOrientation = O(x-2:x+2, y-2:y+2);
                    regionBrightness = brightness(x-2:x+2, y-2:y+2);
                    if var(regionOrientation(:))<vthresh1 && ... 
                            ~isnan(area(x,y)) && var(regionBrightness(:))<vthresh2
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
    area1 = ones(M, N) * nan;
    fingerprint = false(size(I,1), size(I,2));
    for i = expand+1 : M-expand-1
        for j = expand+1 : N-expand-1
            if ~isempty(find(~isnan(area(i-expand:i+expand, j-expand:j+expand)), 1))
                area1(i,j) = O(i,j);
                u = block_x(i); v = block_y(j);
                fingerprint(u:(u+w-1), v:(v+w-1)) = true;
            end
        end
    end
    areaOrientation = area1;
end
