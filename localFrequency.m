function F = localFrequency(I, w)
% Returns a matrix of local frequency in each block
% I: input image
% w: window size
% In ideal situation, there are two peaks in each spectrum, which are
% almost center-symmetric; in other cases, use only one coordinate to
% calculate the local orientation.
    [M, N] = size(I);
    block_x = (0 : floor((M-w)/(w/4)) ) * w / 4 + 1; % separating into blocks
    block_y = (0 : floor((N-w)/(w/4)) ) * w / 4 + 1;
    F = nan(length(block_x), length(block_y));
    for i = 1 : length(block_x)
        for j = 1 : length(block_y)
            u = block_x(i); v = block_y(j);
            block_region = I(u:(u+w-1), v:(v+w-1));
            magnitude = abs(fftshift( fft2(block_region) ));
            peak = find(magnitude == max(magnitude(:))); % find freq peak
            k = 0;
            while length(peak) ~= 2 && k<3
                magnitude(magnitude == max(magnitude(:))) =  0; % delete DC component
                peak = find(magnitude == max(magnitude(:))); % find freq peak
                k = k+1;
            end
            if k == 3
                F(i, j) = 2;
                continue
            end
            dy = mod(peak(1), w) - mod(peak(2), w);
            dx = ceil(peak(1)/w) - ceil(peak(2)/w);
            F(i, j) = sqrt(dy^2 + dx^2);
            if F(i, j) < 2
                F(i, j) = 2;
            end
        end
    end
    F = Flpf(F, 3); % apply LPF
end


function smoothFreq = Flpf(F, w)
    kernel = fspecial('gaussian', w, 10);
    smoothFreq = imfilter(F, kernel, 'replicate');
end


