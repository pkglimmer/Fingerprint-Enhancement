I = im2double(imread('latent.bmp'));
I = histeq(I);
[M1, N1] = size(I);
w = 32;
block_x = (0 : floor((M1-w)/(w/4)) ) * w / 4 + 1; % separating into blocks
block_y = (0 : floor((N1-w)/(w/4)) ) * w / 4 + 1;
O = localOrientation(I, w, block_x, block_y, 0);
F = localFrequency(I, w, block_x, block_y, 0);

vthresh1 = 0.55;
vthresh2 = 0.0025;

[fingerprint, area1] = extractFingerprint(I, O, block_x, block_y, w, vthresh1, vthresh2, 0);

J = I .* double(fingerprint);
imshow(J)

%%

result = spatialGabor(I, ~isnan(area1), O, F, w, block_x, block_y);
imshow(result)