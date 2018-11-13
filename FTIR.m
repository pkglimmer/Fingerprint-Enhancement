I = im2double(imread('FTIR.bmp'));
[M, N] = size(I);
w = 32;
block_x = (0 : floor((M-w)/(w/4)) ) * w / 4 + 1; % separating into blocks
block_y = (0 : floor((N-w)/(w/4)) ) * w / 4 + 1;

O = localOrientation(I, w, block_x, block_y, 80);
F = localFrequency(I, w, block_x, block_y, 0);

result = spatialGabor(I, ~isnan(O), O, F, w, block_x, block_y);

% plotOrientation(I, O, w, block_x, block_y);

imshow(result)

%%
O = localOrientation(I, w, block_x, block_y, 50);

vthresh1 = 2;
vthresh2 = 0.01;
expand = 0;

[fingerprint, Orient] = extractFingerprint(I, O, block_x, block_y, w, vthresh1, vthresh2, expand);
J = I .* double(fingerprint);

result = spatialGabor(I, ~isnan(Orient), O, F, w, block_x, block_y);

figure(1);imshow(J)
figure(2);imshow(result)
%figure(3);plotOrientation(I, O, w, block_x, block_y);

%%
% I2 = im2bw(I, 0.70);
close all;
result1 = normalization(result, 0.5, 1);
figure(2);imshow(result);
