I = im2double(imread('FTIR.bmp'));
[M, N] = size(I);
w = 32;
block_x = (0 : floor((M-w)/(w/4)) ) * w / 4 + 1; % separating into blocks
block_y = (0 : floor((N-w)/(w/4)) ) * w / 4 + 1;

%%
O = localOrientation(I, w);
F = localFrequency(I, w);

vthresh1 = 10;
vthresh2 = 3;
fthresh = 0.4;
expand = 0;

fingerprint = extractFingerprint(I, O, F, w, vthresh1, vthresh2, fthresh, expand);
result = spatialGabor(I, fingerprint, O, F, w);

figure;
% subplot(1,3,1); imshow(I);
subplot(1,2,1); plotOrientation(I, O, fingerprint, w);
subplot(1,2,2); imshow(result);
