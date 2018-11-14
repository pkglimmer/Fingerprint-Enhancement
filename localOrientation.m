function O = localOrientation(I, w, block_x, block_y)
    O = nan(length(block_x), length(block_y));
    for i = 1 : length(block_x)
        for j = 1 : length(block_y)
            u = block_x(i); v = block_y(j);
            block_region = I(u:(u+w-1), v:(v+w-1));
            magnitude = abs(fftshift( fft2(block_region) ));
            magnitude(magnitude == max(magnitude(:))) =  0; % delete DC component
            peak = find(magnitude == max(magnitude(:)));
            if length(peak)==2
                dy = mod(peak(1), w) - mod(peak(2), w);
                dx = ceil(peak(1)/w) - ceil(peak(2)/w);
                if dy < 0 
                    O(i, j) = pi - atan2(-dy, -dx);
                else
                    O(i, j) = atan2(dy, -dx);
                end
            else
                dy = mod(peak(1), w) - 16.5;
                dx = ceil(peak(1)/w) - 16.5;
                if (dx > 0 && dy < 0) || (dx < 0 && dy > 0)
                    O(i, j) = atan(dy / dx);
                else
                    O(i, j) = -atan(dy / dx);
                end
            end
        end
    end
%     temp = O; % median filter
%     O(isnan(O))
%     for i = 5 : length(block_x)-5
%         for j = 5 : length(block_y)-5
%             block = O(i-4:i+4, j-4:j+4);
%             %nanCount = length(find(isnan(block(:))));
%             if abs(O(i,j)<0.01) || abs(O(i, j)-pi/2)<0.01
%                 temp(i, j) = median(block(~isnan(block)));
%             end
%             
%         end
%     end
%     O = temp;
end