function output = removeBackground(inputImage, radius, threshold)
    % accept an image and remove the background of the image [0.1 0.2]
    edges = edge(im2gray(inputImage),"canny",threshold);
    % radius = 10;
    se = strel('disk', radius);
    closed=imclose(edges,se);
    mask1D = uint8(imfill(closed,"holes"));
    mask = cat(3,mask1D,mask1D,mask1D);
    output = inputImage .* mask;
end