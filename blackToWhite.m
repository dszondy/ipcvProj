function imgOut = blackToWhite(imgIn)
    % Create a mask for fully black pixels
    blackMask = all(imgIn == 0, 3);
    
    % Convert the image to a double representation for arithmetic operations
    imgOut = im2double(imgIn);
    
    % For each channel (R, G, B), set the values in the mask to 1 (which is white for double images)
    for channel = 1:3
        imgOutChannel = imgOut(:,:,channel);
        imgOutChannel(blackMask) = 1; % Set to white
        imgOut(:,:,channel) = imgOutChannel;
    end
    
    % Convert the image back to its original data type
    if isa(imgIn, 'uint8')
        imgOut = im2uint8(imgOut);
    elseif isa(imgIn, 'uint16')
        imgOut = im2uint16(imgOut);
    end
end
