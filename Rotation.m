function  [R_IM1,R_IM2] = Rotation(A, S,W,W_IM ,alpha,Uw,Vw )
% Rotation: Clockwise and Anticlockwise
I = W_IM;
figure
subplot(1,3,1);
imshow(I)
title('Original Image');
R_IM1 = imrotate(I,-90);
 subplot(1,3,2);
imshow(R_IM1)
title('Rotation by -90');
subplot(1,3,3);
R_IM2 = imrotate(I,90);
imshow(R_IM2)
title('Rotation by 90');
B_R1 = dct(double(R_IM1));
B_R2 = dct(double(R_IM2));
% F_R1=reshape(B_R1,[512,512]);
% F_R2=reshape(B_R2,[512,512]);
[Ur1,Sr1,Vr1] = svd(B_R1);
[Ur2,Sr2,Vr2] = svd(B_R2);
for i=1:256
    EX_R1(i,i)=(Sr1(i,i)-S(i,i))/alpha;
    EX_R2(i,i)=(Sr2(i,i)-S(i,i))/alpha;
end
EX1=Uw*EX_R1*Vw';
EX2=Uw*EX_R2*Vw';
EX1 = idct(EX1);
EX2 = idct(EX2);
EX1=reshape(EX1,[256,256]);
EX2=reshape(EX2,[256,256]);
EX1=real(EX1);
EX2=real(EX2);
EX_R1=uint8(EX1);
EX_R2=uint8(EX2);

figure
subplot(1,3,1)
imshow(uint8(W))
title('original watermark')
subplot(1,3,2)
imshow(EX_R1)
title('extracted watermark of rotated image1')
subplot(1,3,3)
imshow(EX_R2)
title('extracted watermark of rotated image2')
psnr_rotate1 = psnr(R_IM1,uint8(A))
ssim_rotate1 = ssim(R_IM1,uint8(A))
psnr_rotate2 = psnr(R_IM2,uint8(A))
ssim_rotate2 = ssim(EX_R2,uint8(W))
peaksnr_rot1_wm = psnr(EX_R1,uint8(W))
peaksnr_rot2_wm = psnr(EX_R2,uint8(W))
ssim_wmro = ssim(EX_R2,uint8(W))
end

