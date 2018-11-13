I = im2double(imread('phone.bmp'));
[M, N] = size(I);
w = 32;
block_x = (0 : floor((M-w)/(w/4)) ) * w / 4 + 1; % separating into blocks
block_y = (0 : floor((N-w)/(w/4)) ) * w / 4 + 1;
% 

% J = filter2(fspecial('sobel'), I);
J = filter2(fspecial('gaussian', 3), J);
J = histeq(I);
imshow(J)
% J = normalization(J, 0, 0.1);
O = localOrientation(J, w, block_x, block_y, 20);
F = localFrequency(J, w, block_x, block_y, 0);
% plotOrientation(J, O, w, block_x, block_y);

vthresh1 = 0.75;
vthresh2 = 0.1;

[fingerprint, area1] = extractFingerprint(J, O, block_x, block_y, w, vthresh1, vthresh2, 0);

J1 = J .* double(fingerprint);
imshow(J1)

%%

result = spatialGabor(J, ~isnan(area1), O, F, w, block_x, block_y);
imshow(result)


