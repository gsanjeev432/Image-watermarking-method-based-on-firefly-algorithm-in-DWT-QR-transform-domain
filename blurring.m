function[ Blur_IM ] = blurring(A,S,W,W_IM ,alpha,Uw,Vw)
H = fspecial('disk',5);
Blur_IM = imfilter(W_IM,H,'replicate');
figure
subplot(1,2,1)
imshow(W_IM)
title('watermarked image')
subplot(1,2,2)
imshow(Blur_IM)
title('Blurred Image')
B_B = dct(double(Blur_IM));
F_B=reshape(B_B,[512,512]);
[Ub,Sb,Vb] = svd(F_B);
for i=1:256
    EX_B(i,i)=(Sb(i,i)-S(i,i))/alpha;
end
EX=Uw*EX_B*Vw';
EX = idct(EX);
EX=reshape(EX,[256,256]);
EX=real(EX);
EX_B=uint8(EX);
figure
subplot(1,2,1)
imshow(uint8(W))
title('original watemark')
subplot(1,2,2)
imshow(EX_B)
title('extracted watermark from a blurred image')
peaksnr_blur=psnr(Blur_IM,uint8(A))
ssimval_blur=ssim(Blur_IM,uint8(A))
peaksnr_blur_wm = psnr(EX_B,uint8(W))
% peaksnr_wm = psnr(EX_N,uint8(W))
% temp = sum(not(xor(W(:),EX_N(:))));
% BCR = (temp/(256*256))*100
% r = corrcoef(double(W),double(EX_N))
ssim_wmblu = ssim(EX_B,uint8(W))
end
