clear;clc;

sizeOfImage = [512 512 3];
x = phaseMask(sizeOfImage);
y = ifftshift(ifft2(ifftshift(x)));
tf = ishermitian(x,'skew')

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







%{
x1 =
for z = 1:sizeOfImage(1)
    for w = 1:sizeOfImage(2)
        x1(z,w) = rand();
    end
end

x2 = 
for z = 1:(sizeOfImage(1)-2)/2
    x2T(z,1) = rand();
end

for z = (sizeOfImage(1)-2)/2:sizeOfImage(1)-2
    for w = 1:(sizeOfImage(1)-2)/2
        x2B(z,1) = x2T(w,1);
    end
end
x2 = [x2T;rand();x2B];

x3 = 
for z = 1:sizeOfImage(1)
    for w = 1:sizeOfImage(2)
        for zz = sizeOfImage(1):-1:1
            for ww = sizeOfImage(2):-1:1
                x3(z,w) = x1(zz,ww);
            end
        end
    end
end
%}