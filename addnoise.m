function [ N_IM,EX_N ] = addnoise(A,S,W,W_IM ,alpha,Uw,Vw)
N_IM = imnoise(W_IM,'salt & pepper',0.03);
figure
subplot(1,2,1)
imshow(W_IM)
title('watermarked image')
subplot(1,2,2)
imshow(N_IM)
title('noisy image')
B_N = dct(double(N_IM));
F_N=reshape(B_N,[512,512]);
[Un,Sn,Vn] = svd(F_N);
for i=1:256
    EX_N(i,i)=(Sn(i,i)-S(i,i))/alpha;
end
EX=Uw*EX_N*Vw';
EX = idct(EX);
EX=reshape(EX,[256,256]);
EX=real(EX);
EX_N=uint8(EX);
figure
subplot(1,2,1)
imshow(uint8(W))
title('original watemark')
subplot(1,2,2)
imshow(EX_N)
title('extracted watermark from a noisy image')
% peaksnr_noise=psnr(N_IM,uint8(A))
% peaksnr_noise_wm = psnr(EX_N,uint8(W))
ssimval_noise=ssim(N_IM,uint8(A))
% temp = sum(not(xor(W(:),EX_N(:))));
% BCR = (temp/(256*256))*100
% r = corrcoef(double(W),double(EX_N))
ssim_wmnoi = ssim(EX_N,uint8(W))
end


