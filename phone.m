I = im2double(imread('phone.bmp'));
I = imresize(I, [400, 300]); %压扁一丢丢
[M, N] = size(I);
I = im2double(Bfilter(I, 300, 2));
I = normalization(I, 0.5, 0.5);
imshow(I)

%% Preprocess
w = 8;
block_x = (0 : floor((M-w)/w) ) * w + 1; % separating into blocks
block_y = (0 : floor((N-w)/w) ) * w + 1;
J = I;
V = zeros(length(block_x), length(block_y));
for i = 1 : length(block_x)
    for j = 1 : length(block_y)
        u = block_x(i); v = block_y(j);
        block_region = I(u:(u+w-1), v:(v+w-1));
        MEDIAN = median(block_region(:));
        VAR = var(block_region(:));
        J(u:(u+w-1), v:(v+w-1)) = normalization(block_region, MEDIAN, 0.5);
    end
end
J = 1-J;
imshow(J);

%% Enhance
%J = J1;
w = 32;
block_x = (0 : floor((M-w)/(w/4)) ) * w / 4 + 1; % separating into blocks
block_y = (0 : floor((N-w)/(w/4)) ) * w / 4 + 1;
O = localOrientation(J, w);
F = localFrequency(J, w);

vthresh1 = 10000;
vthresh2 = 10000;
fthresh = 10000;
expand = 0;

fingerprint = extractFingerprint(J, O, F, w, vthresh1, vthresh2, fthresh, expand);
result = spatialGabor(J, fingerprint, O, F, w);
result = imresize(result, [M,N]);

figure;
% subplot(1,3,1); imshow(I);
subplot(1,2,1); plotOrientation(I, O, fingerprint, w); title('Orientation & Mask');
subplot(1,2,2); imshow(result); title('Fingerprint Enhancement');

