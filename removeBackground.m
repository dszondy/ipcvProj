function output = removeBackground(im) 
    % inputImage, radius, threshold
    % % accept an image and remove the background of the image [0.1 0.2]
    % edges = edge(im2gray(inputImage),"canny",threshold);
    % % radius = 10;
    % se = strel('disk', radius);
    % closed=imclose(edges,se);
    % mask1D = uint8(imfill(closed,"holes"));
    % mask = cat(3,mask1D,mask1D,mask1D);
    % output = inputImage .* mask;
    out=createMask(im); 
    seclose  = strel('disk', 15); % sub 4=17, 
    closed = imclose(out,seclose);
    mask1D = imfill(closed,"holes");
    mask1D = bwareaopen(mask1D,8000);
    output=uint8(cat(3,mask1D,mask1D,mask1D)).*im;
end