%% attempt 3
clear 
close all
clc

% load camera param
load("cameraParamsLeft.mat");
load("cameraParamsMiddle.mat");
load("cameraParamsRight.mat");

% load stereoparams
load("stereoParamsML.mat");
load("stereoParamsMR.mat");

% load images to workspace
imageLocLeftsub1    = "subject2/subject2_Left";
imageLocMiddlesub1  = "subject2/subject2_Middle";
imageLocRightsub1   = "subject2/subject2_Right";

imageLeftsub1   = imageDatastore(imageLocLeftsub1,"FileExtensions",[".jpg" ".png" ".tif"]);
imageMiddlesub1 = imageDatastore(imageLocMiddlesub1,"FileExtensions",[".jpg", ".png" ".tif"]);
imageRightsub1  = imageDatastore(imageLocRightsub1,"FileExtensions",[".jpg", ".png" ".tif"]);

% get the left,middle,images
imageLeft   = readimage(imageLeftsub1,1);
imageMiddle = readimage(imageMiddlesub1,1);
imageRight  = readimage(imageRightsub1,1);

% undistored the images
leftUndt   = undistortImage(imageLeft,cameraParamsLeft);
middleUndt = undistortImage(imageMiddle,cameraParamsMiddle);
rightUndt  = undistortImage(imageRight,cameraParamsRight);

% remove the background
leftUndt =   removeBackground(leftUndt,10,[]);
middleUndt = removeBackground(middleUndt,10,[]);
rightUndt =  removeBackground(rightUndt,10,[]);

% rectify images 
[middle1, leftRect, prj1] =   rectifyStereoImages(middleUndt,leftUndt,stereoParamsML,OutputView="full");
[middle2, rightRect, prj2] =  rectifyStereoImages(middleUndt,rightUndt,stereoParamsMR,OutputView="full");

% check visually if images are rectified
% figure;
% imshow(stereoAnaglyph(leftRect,middle1));
% figure;
% imshow(stereoAnaglyph(rightRect,middle2));

% get grayscale image of rectified image
leftRectgray     = im2gray(leftRect);
middle1gray      = im2gray(middle1);
middle2gray      = im2gray(middle2);
rightRectgray    = im2gray(rightRect);

% get disparity functions  [-360 -240]
disparityRange  = [240 360];
disparityRange2 = [-360 -240];
disparityML     = disparitySGM(leftRectgray, middle1gray,"DisparityRange",disparityRange,UniquenessThreshold=0);
disparityMR     = disparitySGM(rightRectgray,middle2gray,"DisparityRange",disparityRange2,UniquenessThreshold=0);

% remove unreliable disparities
unreliableML = unReliable(disparityML,leftRect);
unreliableMR = unReliable(disparityMR,rightRect);
disparityML(unreliableML)=0;
disparityMR(unreliableMR)=0;

% Interpolation
disparityML = interpolate(disparityML);
disparityMR = interpolate(disparityMR);

% Display disparity map for visual inspection
% figure;
% imshow(disparityML,DisplayRange=disparityRange);
% colormap jet
% colorbar
% title("middleLeft");
% figure;
% imshow(disparityMR,DisplayRange=disparityRange2);
% colormap jet
% colorbar
% title("middleRight");

% reconstuct the scene
xyzMiddleLeft   = reconstructScene(disparityML, prj1);
xyzMiddleRight  = reconstructScene(disparityMR, prj2);

% get point cloud
pointCloudMiddleLeft   = pointCloud(xyzMiddleLeft,"Color",leftRect);
pointCloudMiddleRight  = pointCloud(xyzMiddleRight,"Color",rightRect);

display the pointcloud
figure;
pcshow(pointCloudMiddleLeft,VerticalAxis="Y",VerticalAxisDir="Up",MarkerSize=5);
title("ML");
figure;
pcshow(pointCloudMiddleRight,VerticalAxis="Y",VerticalAxisDir="Up",MarkerSize=5);
title("MR");

% preprocess for merging
% denoising
denoisedML = pcdenoise(pointCloudMiddleLeft,"NumNeighbors",80);
denoisedMR = pcdenoise(pointCloudMiddleRight,"NumNeighbors",80);
% downsampling and merging
scale = 1;
downML = pcdownsample(denoisedML,"random", scale);
downMR = pcdownsample(denoisedMR,"random", scale);

% Rotation Matrices
LM = stereoParamsML.RotationOfCamera2;
RM = stereoParamsMR.RotationOfCamera2;
%Initial Transformation
tformI =  affine3d();
tformI.T(1:3,1:3) = RM/LM; %RR*inv(RL);

[tform, movingML,rmse] = pcregistericp(denoisedML,denoisedMR,MaxIterations=100, InitialTransform=tformI,Metric="planeToPlaneWithColor");
merged = pcmerge(movingML,denoisedMR,1);

figure;
pcshow(merged,VerticalAxis="Y",VerticalAxisDir="Up",MarkerSize=5);
title("Merged");
































































