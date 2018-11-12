function G = normalization(I, M0, VAR0)
    % I: input image, G: normalized output image
    % M0 and VAR0: desired mean and variance, respectively
    % definition of normalization was taken from the "fingerprint" paper
    Mean = mean(I(:));
    sd = sqrt(var(I(:)));
    G = M0 + (I - Mean) * sqrt(VAR0) / sd;
end