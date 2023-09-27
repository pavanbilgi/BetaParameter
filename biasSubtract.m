%%%
% This function converts the image from DN to electrons.

function dataImgbs=biasSubtract(dataImg,gain)
dataImg=double(dataImg);
% Set the boundaries of the serial overscan (bias) regions.
biasL=[1 4560; 2283 2308];
biasR=[1 4560; 2313 2338];

% Calculate the bias level of the left side of the image.
biasLm=median(dataImg(biasL(1,1):biasL(1,2),biasL(2,1):biasL(2,2)),2);
% Bias level of the right side of the image.
biasRm=median(dataImg(biasR(1,1):biasR(1,2),biasR(2,1):biasR(2,2)),2);

% Bias subtract.
imgL=dataImg(1:4560,1:2310)-biasLm;
imgR=dataImg(1:4560,2311:4620)-biasRm;

% Gain correct.
dataImgbs=[imgL/gain(1) imgR/gain(2)];
end
