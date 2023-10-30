function normalizedImage = normalizeColor(inputImage)
    % Convert the image to the Lab color space
    labImage = rgb2lab(inputImage);
    
    % Extract the L, a, and b channels
    L = labImage(:,:,1);
    a = labImage(:,:,2);
    b = labImage(:,:,3);
    
    % Normalize each channel
    L = (L - mean(L(:))) / std(L(:));
    a = (a - mean(a(:))) / std(a(:));
    b = (b - mean(b(:))) / std(b(:));
    
    % Clip values to lie within the Lab color space range
    L = min(max(L,0),100);
    a = min(max(a,-127),128);
    b = min(max(b,-127),128);
    
    % Merge the normalized channels back
    normalizedLabImage = cat(3, L, a, b);
    
    % Convert the normalized Lab image back to the RGB color space
    normalizedImage = lab2rgb(normalizedLabImage);
end
