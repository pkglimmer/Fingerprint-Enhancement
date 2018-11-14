function J = spatialGabor(I, fingerprintArea, O, F, w)
% Apply gabor filter to fingerprint area of the image
% I: input image
% fingerprintArea: a m*n logical matrix of fingerprint area
% O: orientation map
% F: frequency map
% w: window size. 32 is an ideal size.
    [M, N] = size(I);
    block_x = (0 : floor((M-w)/(w/4)) ) * w / 4 + 1;
    block_y = (0 : floor((N-w)/(w/4)) ) * w / 4 + 1;
    J = zeros(M, N);
    overlap = zeros(M, N); % counting overlaps on each pixel
    for i = 1 : length(block_x)
        for j = 1 : length(block_y)
            if fingerprintArea(block_x(i)+w-1, block_y(j)+w-1) && ...
                    fingerprintArea(block_x(i), block_y(j))
                block_region = [ block_x(i) : block_x(i)+w-1; block_y(j) : block_y(j)+w-1 ];
                block = I(block_region(1, :), block_region(2, :));
                % block filtering
                [MAG, PHASE] = imgaborfilt(block, F(i, j), O(i, j)*180/pi);
                enhancedBlock = MAG .* cos(PHASE);
                enhancedBlock = normalization( enhancedBlock, 0.5, 1);
                J(block_region(1, :), block_region(2, :)) = J(block_region(1, :), block_region(2, :)) + enhancedBlock;
                overlap(block_region(1, :), block_region(2, :)) = overlap(block_region(1, :), block_region(2, :)) + ones(w);
            end
        end 
    end
    J = J ./ overlap;
end
