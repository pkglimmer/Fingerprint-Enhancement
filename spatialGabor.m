function J = spatialGabor(I, fingerprintArea, O, freq, w, block_x, block_y)
    [M, N] = size(I);
    J = zeros(M, N);
    overlap = zeros(M, N);
    for i = 1 : length(block_x)
        for j = 1 : length(block_y)
            if fingerprintArea(i, j)
                block_region = [ block_x(i) : block_x(i)+w-1; block_y(j) : block_y(j)+w-1 ];
                block = I(block_region(1, :), block_region(2, :));
                [MAG, PHASE] = imgaborfilt(block, freq(i, j), O(i, j)*180/pi);
                enhancedBlock = MAG .* cos(PHASE);
                enhancedBlock = normalization( enhancedBlock, 0.5, 1);
                J(block_region(1, :), block_region(2, :)) = J(block_region(1, :), block_region(2, :)) + enhancedBlock;
                overlap(block_region(1, :), block_region(2, :)) = overlap(block_region(1, :), block_region(2, :)) + ones(w);
            end
        end 
    end
    J = J ./ overlap;
end
