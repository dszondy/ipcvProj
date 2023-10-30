function disparitymap= interpolate(disparitymap)
% Filling missing pixels in the disparity map --interpolation
w=10;
maskSize = 2 * w + 1;
mask=fspecial('gauss',maskSize,5);
[M,N]=size(disparitymap);
for i = 1:M
for j = 1:N
    if disparitymap(i, j) ~= 0 && ~isnan(disparitymap(i, j))
        % Extract the window around the pixel
        i_min = max(1, i - w);
        i_max = min(M, i + w);
        j_min = max(1, j - w);
        j_max = min(N, j + w);
        
        win = disparitymap(i_min:i_max, j_min:j_max);
        [winM, winN] = size(win);
        
        % Check if the window size matches the mask size
        if winM == maskSize && winN == maskSize
            nonZeros = win ~= 0;
            win = mask .* win;
            if sum(sum(mask .* nonZeros)) ~= 0
                disparitymap(i, j) = sum(sum(win .* nonZeros)) / sum(sum(mask .* nonZeros));
            end
        end
    end
end
end
end


