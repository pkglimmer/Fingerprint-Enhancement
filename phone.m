I = im2double(imread('phone.bmp'));
I = imresize(I, 3/4);
[M, N] = size(I);
w = 32;
block_x = (0 : floor((M-w)/(w/4)) ) * w / 4 + 1; % separating into blocks
block_y = (0 : floor((N-w)/(w/4)) ) * w / 4 + 1;
 
%J = filter2(fspecial('gaussian', 3), I);
% J = histeq(J);

J = I;
%J = normalization(I, 0.5, 0.5);
imshow(J)

%%
% J = normalization(J, 0, 0.1);
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

figure(1);imshow(J1)
figure(2);imshow(result)
figure(3);plotOrientation(J, O, w, block_x, block_y);
