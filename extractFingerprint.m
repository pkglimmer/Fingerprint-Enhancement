function fingerprint = extractFingerprint(I, O, F, w, vthresh1, vthresh2, fthresh, expand)
    % Use BFS to extract fingerprint area.
    % I: input image
    % O, F: orientation/frequency map of the image
    % vthresh1, vthresh2: threshold of the variance of O, F among neighbors
    % fthresh: threshold of freq/samplefreq, e.g. 0.4-0.6 would be fine
    % expand(pixels): expand region if the area is too small
    [M1, N1] = size(I);
    block_x = (0 : floor((M1-w)/(w/4)) ) * w / 4 + 1; % separating into blocks
    block_y = (0 : floor((N1-w)/(w/4)) ) * w / 4 + 1;
    M = size(O, 1); 
    N = size(O, 2);
    start = round([M/2, N/2]);
    expansion = [1 0; 0 -1; -1 0; 0 1];
    area = ones(M, N)*(-1); % fingerprint area
    closedTable = zeros(M*N, 2);
    cur = 1; total = 1;
    closedTable(1, :) = start;
    % get sample frequency from the center
    u = round(M/2); v = round(N/2);
    sampleFreq = F(u-2:u+2, v-2:v+2);
    sampleFreq = mean(sampleFreq(:));
    Opadding = padding(O, 2); % padding
    Fpadding = padding(F, 2);
    
    while cur <= total
        pos = closedTable(cur, :);
        cur = cur + 1;
        for i = 1 : 4
            adjacentPos = pos + expansion(i, :);
            x = adjacentPos(1);
            y = adjacentPos(2);
            if x<=0 || x>M || y<=0 || y>N
                continue
            end
            if area(x, y) == -1
                % padding for blocks on edges
                if x<=3 || y<=3 || M-x<=3 || N-y<=3 
                    regionOrientation = Opadding(x:x+4, y:y+4);
                    regionFrequency = Fpadding(x:x+4, y:y+4);
                else
                    regionOrientation = O(x-2:x+2, y-2:y+2);
                    regionFrequency = F(x-2:x+2, y-2:y+2);
                end
                % thresholding
                if var(regionOrientation(:))<vthresh1 && ... 
                        ~isnan(area(x,y)) && var(regionFrequency(:))<vthresh2 && ...
                            abs(mean(regionFrequency(:))-sampleFreq)/sampleFreq<fthresh
                    area(x, y) = O(x, y);
                    total = total + 1;
                    closedTable(total, :) = adjacentPos;
                else
                    area(x, y) = nan;
                end
            end
        end
    end
    area(area==-1) = nan;
    fingerprint = false(size(I,1), size(I,2));
    for i = expand+1 : M-expand-1
        for j = expand+1 : N-expand-1
            if ~isempty(find(~isnan(area(i-expand:i+expand, j-expand:j+expand)), 1))
                u = block_x(i); v = block_y(j);
                fingerprint(u:(u+w-1), v:(v+w-1)) = true;
            end
        end
    end
    k = 2;
    for i = k+1 : M-k
        for j = k+1 : N-k
            block = area(i-k:i+k, j-k:j+k);
            nanCount = length(find(isnan(block(:))));
            if nanCount < (2*k+1)^2/8
                u = block_x(i); v = block_y(j);
                fingerprint(u:(u+w-1), v:(v+w-1)) = true;
            end
        end
    end
end
% pad around A, add w row/col at each side. method = replicant
function B = padding(A, w)
    [m, n] = size(A);
    B = zeros(m+2*w, n+2*w);
    B(w+1:m+w, w+1:n+w) = A;
    
    B(1:w, w+1:n+w) = A(1:w, 1:n); % top
    B(m+w+1:m+2*w, w+1:n+w) = A(m-w+1:m, 1:n); % bottom
    B(w+1:m+w, 1:w) = A(1:m, 1:w);
    B(w+1:m+w, n+w+1:n+2*w) = A(1:m, n-w+1:n);
end







