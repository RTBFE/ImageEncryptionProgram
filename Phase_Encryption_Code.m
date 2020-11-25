clc;clear;

prompt = {'enter 1 for encryption of image, enter 2 for decryption of image'};
answer = inputdlg(prompt);

if answer(1) == "1"
    [file,path] = uigetfile('*.*','select image to be encrypted');
    image = im2double(imread([path,file]));
    sizeOfImage = size(image);
    phaseMaskSpatial = rand(sizeOfImage(1),sizeOfImage(2));
    phaseMaskFrequency = phaseMask(sizeOfImage);
    encryptedImage = splitAndEncryptImage(image,sizeOfImage,phaseMaskSpatial,phaseMaskFrequency);
    key = [phaseMaskSpatial phaseMaskSpatial;real(phaseMaskFrequency) imag(phaseMaskFrequency)];
    imwrite(key,'C:\Users\Ross\Documents\MATLAB\Personal Project\outputFolder\Key.bmp')
    imwrite(encryptedImage,'C:\Users\Ross\Documents\MATLAB\Personal Project\outputFolder\EncryptedImage.bmp');
else
    [file,path] = uigetfile('*.*','select encrypted Image');
    encryptedImage = im2double(imread([path,file]));
    sizeOfImage = size(encryptedImage);
    [file,path] = uigetfile('*.*','select key');
    key = im2double(imread([path,file]));
    
    phaseMaskSpatial = key(1:sizeOfImage(1),1:sizeOfImage(2));
    phaseMaskFrequencyReal = key(sizeOfImage(1)+1:2*sizeOfImage(1),1:sizeOfImage(2));
    phaseMaskFrequencyImaginary = key(sizeOfImage(1)+1:2*sizeOfImage(1),sizeOfImage(2)+1:2*sizeOfImage(2));
    phaseMaskFrequency = complex(phaseMaskFrequencyReal,phaseMaskFrequencyImaginary);
    
    decryptedImage = splitAndDecryptImage(encryptedImage,sizeOfImage,phaseMaskSpatial,phaseMaskFrequency);
    imshow(decryptedImage);
    %imwrite(decryptedImage,'C:\Users\Ross\Documents\MATLAB\Personal Project\outputFolder\decryptedImage.bmp')
end 

%% Functions

function encryptedImage = splitAndEncryptImage(image,sizeOfImage,phaseMaskSpatial,phaseMaskFrequency)
    if size(sizeOfImage) ~= 3 % if the image is a bit image
        encryptedImage = encryptImage(image,phaseMaskSpatial,phaseMaskFrequency);
    else
        imageR = image(:, :, 1);
        imageG = image(:, :, 2);
        imageB = image(:, :, 3);

        imageR = encryptImage(imageR,phaseMaskSpatial,phaseMaskFrequency);
        imageG = encryptImage(imageG,phaseMaskSpatial,phaseMaskFrequency);
        imageB = encryptImage(imageB,phaseMaskSpatial,phaseMaskFrequency);
        encryptedImage = cat(3, imageR, imageG, imageB);
    end
end

function decryptedImage = splitAndDecryptImage(encryptedImage,sizeOfImage,phaseMaskSpatial,phaseMaskFrequency)
    if size(sizeOfImage) ~= 3 % if the image is a bit image
        decryptedImage = decryptImage(encryptedImage,phaseMaskSpatial,phaseMaskFrequency);
    else
        imageR = encryptedImage(:, :, 1);
        imageG = encryptedImage(:, :, 2);
        imageB = encryptedImage(:, :, 3);
        
        imageR = decryptImage(imageR,phaseMaskSpatial,phaseMaskFrequency);
        imageG = decryptImage(imageG,phaseMaskSpatial,phaseMaskFrequency);
        imageB = decryptImage(imageB,phaseMaskSpatial,phaseMaskFrequency);
        decryptedImage = cat(3, imageR, imageG, imageB);
    end
end

function encryptedImage = encryptImage(image,phaseMaskSpatial,phaseMaskFrequency)
    image = image.*phaseMaskSpatial;
    image = fftshift(fft2(fftshift(image)));
    image = image.*phaseMaskFrequency;
    encryptedImage = ifftshift(ifft2(ifftshift(image)));
end

function decryptedImage = decryptImage(image,phaseMaskSpatial,phaseMaskFrequency)
    inversePhaseMaskSpatial = -1*phaseMaskSpatial;
    inversePhaseMaskFrequency = exp(-1*log(phaseMaskFrequency));
    %image = image.*inversePhaseMaskSpatial;
    image = fftshift(fft2(fftshift(image)));% Convert Image to frequency domain 
    image = image.*inversePhaseMaskFrequency;
    decryptedImage = ifftshift(ifft2(ifftshift(image)));
end

function x = phaseMask(sizeOfImage)
    x1 = exp(-1i*2*pi*rand(sizeOfImage(1)-1,sizeOfImage(2)/2-1));
    
    for z = 1:(sizeOfImage(1)-2)/2
        x2(z,1) = exp(-1i*2*pi*rand());
    end
    x2 = [x2;rand();conj(flipud(x2))];

    x3 = conj(rot90(x1,2));

    for z = 1:(sizeOfImage(1)-2)/2
        x4(z,1) = exp(-1i*2*pi*rand());
    end
    x4 = [x4;rand();conj(flipud(x4))];

    for z = 1:(sizeOfImage(2)-2)/2
        x5(1,z) = exp(-1i*2*pi*rand());
    end
    x5 = [rand() x5 rand() conj(fliplr(x5))];

    x = [x4 x1 x2 x3];

    x = [x5;x];
end
