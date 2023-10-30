function dominantColor = findDominantColor(img)
    % Convert the image to a 1D grayscale representation
    grayscaleImg = rgb2gray(img);
    
    % Exclude fully black pixels
    nonBlackMask = any(img > 0, 3);
    
    % Compute the histogram of the grayscale image excluding black pixels
    [counts, ~] = imhist(grayscaleImg(nonBlackMask));
    
    % Find the grayscale value that has the highest count
    [~, dominantGrayValue] = max(counts);
    
    % Convert the grayscale value to the range [0, 1]
    dominantGrayValue = (dominantGrayValue - 1) / 255;
    
    % Create a mask to get the corresponding RGB values in the original image
    mask = grayscaleImg == uint8(dominantGrayValue * 255) & nonBlackMask;
    dominantPixels = img(repmat(mask, [1 1 3]));
    
    % Reshape dominantPixels to [n, 3] where n is the number of dominant pixels
    dominantPixels = reshape(dominantPixels, [], 3);
    
    % Compute the average RGB value of the dominant pixels to get the dominant color
    dominantColor = mean(dominantPixels, 1);
    dominantColor = uint8(dominantColor
