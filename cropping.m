function [ crop_IM ] = cropping(A,S,W,W_IM ,alpha,Uw,Vw )
crop_IM = W_IM;
for i=1:50
    for j=1:50
        crop_IM(i,:) = 0;
        crop_IM(:,j) = 0;
    end
end
for i=463:512
    for j = 463:512
        crop_IM(i,:)=0;
        crop_IM(:,j)=0;
    end
end
figure
subplot(1,2,1)
imshow(W_IM)
title('watermarked image')
subplot(1,2,2)
imshow(crop_IM)
title('cropped Image')
B_Cr = dct(double(crop_IM));
F_Cr=reshape(B_Cr,[512,512]);
[Ucr,Scr,Vcr] = svd(F_Cr);
for i=1:256
    EX_CR(i,i)=(Scr(i,i)-S(i,i))/alpha;
end
EX=Uw*EX_CR*Vw';
EX = idct(EX);
EX=reshape(EX,[256,256]);
EX=real(EX);
EX_CR=uint8(EX);
figure
subplot(1,2,1)
imshow(uint8(W))
title('original watemark')
subplot(1,2,2)
imshow(EX_CR)
title('extracted watermark from a cropped image')
peaksnr_crop_wm = psnr(EX_CR,uint8(W))
% temp = sum(not(xor(W(:),EX_N(:))));
% BCR = (temp/(256*256))*100
% r = corrcoef(double(W),double(EX_N))
ssim_wmcr = ssim(EX_CR,uint8(W))
peaksnr_crop=psnr(uint8(crop_IM),uint8(A))
ssimval_crop = ssim(uint8(crop_IM),uint8(A))
% psnr_watermark_blur = psnr(E_CW,W)
% ssim_watermark_blur = ssim(E_CW,W)
end