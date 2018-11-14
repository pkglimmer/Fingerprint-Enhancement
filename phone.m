I = im2double(imread('phone.bmp'));
[M, N] = size(I);
w = 32;
block_x = (0 : floor((M-w)/(w/4)) ) * w / 4 + 1; % separating into blocks
block_y = (0 : floor((N-w)/(w/4)) ) * w / 4 + 1;

%%
I = im2double(Bfilter(I, 150, 2));
%I =  histeq(I);
%J = filter2(fspecial('gaussian', 3), I);
% J = normalization(J, 0.5, 0.1);
w = 4;
block_x = (0 : floor((M-w)/w) ) * w + 1; % separating into blocks
block_y = (0 : floor((N-w)/w) ) * w + 1;

J = I;
for i = 1 : length(block_x)
    for j = 1 : length(block_y)
        u = block_x(i); v = block_y(j);
        block_region = I(u:(u+w-1), v:(v+w-1));
        thresh = median(block_region(:));
        J(u:(u+w-1), v:(v+w-1)) = imbinarize(block_region, thresh);
    end
end


%%
J2 = J;
J1 = filter2(fspecial('average', 5), J);
imshow(J1)
% divide into 8*8 blocks, calculate median and apply threshold filter

%%
% J = normalization(J, 0, 0.1);
J = J1;
w = 32;
block_x = (0 : floor((M-w)/(w/4)) ) * w / 4 + 1; % separating into blocks
block_y = (0 : floor((N-w)/(w/4)) ) * w / 4 + 1;
O = localOrientation(J, w, block_x, block_y);
F = localFrequency(J, w, block_x, block_y, 0);
figure(1); plotOrientation(J, O, w, block_x, block_y);

%vthresh1 = 0.75;
%vthresh2 = 0.5;
vthresh1 = 10000;
vthresh2 = 10000;
expand = 0;

fingerprint = extractFingerprint(J, O, F, block_x, block_y, w, vthresh1, vthresh2, expand);
J1 = J .* double(fingerprint);

result = spatialGabor(I, fingerprint, O, F, w, block_x, block_y);

close all
figure(1);imshow(J1)
figure(2);imshow(result)
figure(3);plotOrientation(J, O, w, block_x, block_y);


%%
function H = glpf(D0,M)
% Create a Gaussian low pass filter
    [DX, DY] = meshgrid(1:M);
    D2 = (DX-M/2-1).^2+(DY-M/2-1).^2;
    H = exp(-D2/(2*D0*D0));
end


%%
