I = im2double(imread('latent.bmp'));
I = histeq(I);
[M1, N1] = size(I);

%%
w = 16;
block_x = (0 : floor((M1-w)/w) ) * w + 1; % separating into blocks
block_y = (0 : floor((N1-w)/w) ) * w + 1;

u = M/2; v = N/2;
block_region = I(u:(u+w-1), v:(v+w-1));
thresh = median(block_region(:));

J = I;
for i = 1 : length(block_x)
    for j = 1 : length(block_y)
        u = block_x(i); v = block_y(j);
        block_region = I(u:(u+w-1), v:(v+w-1));
        %thresh = median(block_region(:));
        J(u:(u+w-1), v:(v+w-1)) = imbinarize(block_region, thresh);
    end
end
imshow(J)
%%
%J = I;
w = 32;
block_x = (0 : floor((M1-w)/(w/4)) ) * w / 4 + 1; % separating into blocks
block_y = (0 : floor((N1-w)/(w/4)) ) * w / 4 + 1;
O = localOrientation(J, w, block_x, block_y);
F = localFrequency(J, w, block_x, block_y, 0);

vthresh1 = 1;%0.55;
vthresh2 = 0.3;%0.0025;

fingerprint = extractFingerprint(J, O, F, block_x, block_y, w, vthresh1, vthresh2, 0);
J1 = J .* double(fingerprint);
imshowpair(J1, I, 'montage')

%%

result = spatialGabor(J, fingerprint, O, F, w, block_x, block_y);
close all
figure(1);imshow(J)
figure(2);imshow(result)
figure(3);plotOrientation(J, O, w, block_x, block_y);

%%
figure(1);imshow(I)
figure(2),imshow(F, [])
figure(3),imshow(O, [])