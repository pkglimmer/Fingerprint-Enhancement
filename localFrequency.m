function F = localFrequency(I, w, block_x, block_y, thresh)
    F = zeros(length(block_x), length(block_y));
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
                F(i, j) = sqrt(dx^2 + dy^2);
            else
                F(i, j) = NaN;
            end
        end
    end
    F = meanFilter(F, 7); % window size used in the paper = 7
end


function smoothFreq = meanFilter(freq, w)
    [m, n] = size(freq);
    smoothFreq = freq;
    w0 = floor(w/2); % half window 
    for i = 1+w0:m-w0
        for j = 1+w0:n-w0
            if ~isnan(freq(i,j)) %&& i>w0 && j>w0 && i+w0<=m && j+w0<=n
                blockFreq = freq(i-w0:i+w0, j-w0:j+w0);
                smoothFreq(i, j) = mean(blockFreq(~isnan(blockFreq)));
                if i==3 && j==22
                    freq(i-w0:i+w0, j-w0:j+w0)
                end
            end
        end
    end    
end


