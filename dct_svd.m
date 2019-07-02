%WATERMARK EMBEDDING.
clc;
clear all;
close all;

lambda = firefly();

%INPUT/ORIGINAL/HOST IMAGE
original_image = imread('lena.jpg');
original_image = rgb2gray(original_image);
original_image = imresize(original_image,[512 512]);
original_image = double(original_image);

%BINARY WATERMARK 
watermark = imread('lg.jpg');
watermark = rgb2gray(watermark);
watermark= imresize(watermark,[256 256]);
watermark=double(watermark);

%%
dct_orig = dct(original_image);
dct_w = dct(watermark);
dct_orig_1 = reshape(dct_orig,[512,512]);
dct_watermark_1 = reshape(dct_w,[256,256]);
[U,S,V]=svd(dct_orig_1);
[Uw,Sw,Vw]=svd(dct_watermark_1);
SS=S;
for i=1:256
    SS(i,i) = S(i,i) + lambda*Sw(i,i);
end
AA = U*SS*V';
Watermark_Image=idct(AA);
Watermark_Image=reshape(Watermark_Image,[512,512]);
Watermark_Image=real(Watermark_Image);
Watermark_Image=uint8(Watermark_Image);
figure
subplot(1,3,1)
imshow(uint8(original_image))
title('original image')
subplot(1,3,2)
imshow(uint8(watermark))
title('watermark')
subplot(1,3,3)
imshow(Watermark_Image)
title('watermarked image')
peaksnr = psnr(Watermark_Image,uint8(original_image))
ssimval=ssim(Watermark_Image,uint8(original_image))
%%
dct_watermrk = dct(double(Watermark_Image));
F_W=reshape(dct_watermrk,[512,512]);
[Ub,Sb,Vb] = svd(F_W);
for i=1:256
    Extract_S(i,i)=(Sb(i,i)-S(i,i))/lambda;
end
EX=Uw*Extract_S*Vw';
EX = idct(EX);
EX=reshape(EX,[256,256]);
EX=real(EX);
EX_WM=uint8(EX);
figure
subplot(1,2,1)
imshow(uint8(watermark))
title('original watemark')
subplot(1,2,2)
imshow(EX_WM)
title('extracted watermark')
 peaksnr_wm = psnr(EX_WM,uint8(watermark))
 ssim_wm = ssim(EX_WM,uint8(watermark))
 
 %% BER
 
 [M,N] = size(watermark);
 for m = 1:M
     for n = 1:N
         num = xor(watermark(m,n),EX_WM(m,n));
     end
 end
 ber = num./(M*N)
 