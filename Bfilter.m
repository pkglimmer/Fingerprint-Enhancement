function image_out = Bfilter(image_in, D0, N)
% Butterworth low pass filter
% full credit to https://blog.csdn.net/cjsh_123456/article/details/79342300
    % Butterworth滤波器，在频率域进行滤波
    % 输入为需要进行滤波的灰度图像，Butterworth滤波器的截止频率D0，阶数N
    % 输出为滤波之后的灰度图像
    [m, n] = size(image_in);
    P = 2 * m;
    Q = 2 * n;
    fp = zeros(P, Q);
    %对图像填充0,并且乘以(-1)^(x+y) 以移到变换中心
    for i = 1 : m
        for j = 1 : n
            fp(i, j) = double(image_in(i, j)) * (-1)^(i+j);
        end
    end
    % 对填充后的图像进行傅里叶变换
    F1 = fft2(fp);
    % 生成Butterworth滤波函数，中心在(m+1,n+1)
    Bw = zeros(P, Q);
    a = D0^(2 * N);
    for u = 1 : P
        for v = 1 : Q
            temp = (u-(m+1.0))^2 + (v-(n+1.0))^2;
            Bw(u, v) = 1 / (1 + (temp^N) / a);
        end
    end
    %进行滤波
    G = F1 .* Bw;
    % 反傅里叶变换
    gp = ifft2(G);
    % 处理得到的图像
    image_out = zeros(m, n, 'uint8');
    gp = real(gp);
    g = zeros(m, n);
    for i = 1 : m
        for j = 1 : n
            g(i, j) = gp(i, j) * (-1)^(i+j);

        end
    end
    mmax = max(g(:));
    mmin = min(g(:));
    range = mmax-mmin;
    for i = 1 : m
        for j = 1 : n
            image_out(i,j) = uint8(255 * (g(i, j)-mmin) / range);
        end
    end
end