% function [A,W_IM,W,EX_WM] = dwt_svd(best)
%WATERMARK EMBEDDING.
clc;
clear all;
close all;

lambda = 0.03;

%INPUT/ORIGINAL/HOST IMAGE
A = imread('lena.jpg');
A = rgb2gray(A);
A = imresize(A,[512 512]);
A = double(A);

%BINARY WATERMARK 
W = imread('lg.jpg');
W = rgb2gray(W);
W= imresize(W,[256 256]);
W=double(W);

%%
[LL,LH,HL,HH] = dwt2(A,'db1');
[LLw,LHw,HLw,HHw] = dwt2(W,'db1');
dwt_orig_1 = reshape(LL,[256,256]);
dwt_watermark_1 = reshape(LLw,[128,128]);
[U,S,V]=svd(dwt_orig_1);
[Uw,Sw,Vw]=svd(dwt_watermark_1);
SS=S;
for i=1:128
    SS(i,i) = S(i,i) + lambda*Sw(i,i);
end
AA = U*SS*V';
W_IM=idwt2(AA,LH,HL,HH,'db1',size(A));
W_IM=reshape(W_IM,[512,512]);
W_IM=real(W_IM);
W_IM=uint8(W_IM);
figure
subplot(1,3,1)
imshow(uint8(A))
title('original image')
subplot(1,3,2)
imshow(uint8(W))
title('watermark')
subplot(1,3,3)
imshow(W_IM)
title('watermarked image')
peaksnr = psnr(W_IM,uint8(A))
ssimval=ssim(W_IM,uint8(A))
%%
W_IM = imnoise(W_IM,'salt & pepper',0.03);
[LL_w,LH_w,HL_w,HH_w] = dwt2(W_IM,'db1');
F_W=reshape(LL_w,[256,256]);
[Ub,Sb,Vb] = svd(F_W);
for i=1:128
    Extract_S(i,i)=(Sb(i,i)-S(i,i))/lambda;
end
EX=Uw*Extract_S*Vw';
EX = idwt2(EX,LHw,HLw,HHw,'db1',size(W_IM));
EX=reshape(EX,[256,256]);
EX=real(EX);
EX_WM=uint8(EX);
figure
subplot(1,2,1)
imshow(uint8(W))
title('original watemark')
subplot(1,2,2)
imshow(EX_WM)
title('extracted watermark')
 peaksnr_wm = psnr(EX_WM,uint8(W))
 ssim_wm = ssim(EX_WM,uint8(W))
 