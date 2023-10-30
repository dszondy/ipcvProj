function correctedImage = normalizeColor(inputImage, targetColor)
    % Check if the input is a valid RGB image
    if size(inputImage, 3) ~= 3
        error('Input should be an RGB image.');
    end
    
    % Find the dominant color of the image
    dominantColor = findDominantColor(inputImage);
    
    % Compute the difference between the dominant color and the target color
    colorDifference = double(targetColor) - double(dominantColor);
    
    % Convert inputImage to double for calculations
    correctedImageDouble = double(inputImage);
    
    % Identify the black areas in the image
    blackMask = all(inputImage == 0, 3);
    
    % Adjust each channel of the image based on the color difference
    correctedImageDouble(:,:,1) = correctedImageDouble(:,:,1) + colorDifference(1);
    correctedImageDouble(:,:,2) = correctedImageDouble(:,:,2) + colorDifference(2);
    correctedImageDouble(:,:,3) = correctedImageDouble(:,:,3) + colorDifference(3);
    
    % Restore the black areas
    correctedImageDouble(repmat(blackMask, [1 1 3])) = 0;
    
    % Clip the values to ensure they're within valid range
    correctedImageDouble = max(min(correctedImageDouble, 255), 0);
    
    % Convert the corrected image back to the original data type of the input image
    switch class(inputImage)
        case 'uint8'
            correctedImage = uint8(correctedImageDouble);
        case 'uint16'
            correctedImage = uint16(correctedImageDouble * 65535 / 255);
        case 'double'
            correctedImage = correctedImageDouble / 255.0;
        otherwise
            error('Unsupported data type: %s', class(inputImage));
    end
end
