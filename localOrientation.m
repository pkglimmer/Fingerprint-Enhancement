function O = localOrientation(I, w, block_x, block_y, thresh)
    O = zeros(length(block_x), length(block_y));
    for i = 1 : length(block_x)
        for j = 1 : length(block_y)
            u = block_x(i); v = block_y(j);
            block_region = I(u:(u+w-1), v:(v+w-1));
            magnitude = abs(fftshift( fft2(block_region) ));
            magnitude(magnitude == max(magnitude(:))) =  0; % delete DC component
            peak = find(magnitude == max(magnitude(:)));
            if length(peak)==2 && max(magnitude(:)) > thresh
                dy = mod(peak(1), w) - mod(peak(2), w);
                dx = ceil(peak(1)/w) - ceil(peak(2)/w);
                if dy < 0 
                    O(i, j) = pi - atan2(-dy, -dx);
                else
                    O(i, j) = atan2(dy, -dx) + pi;
                end
            else
                O(i, j) = NaN;
            end
        end
    end
    for i = 2 : length(block_x)-1
        for j = 2 : length(block_y)-1
            block = O(i-1:i+1, j-1:j+1);
            nanCount = length(find(isnan(block(:))));
            if ~isnan(O(i,j)) && nanCount>0
                O(i, j) = median(block(~isnan(block)));
            elseif isnan(O(i,j)) && nanCount<=6
                O(i, j) = median(block(~isnan(block)));
            end
        end
    end
end