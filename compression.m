function  [ compress_IM ] = compression(A,S,W,W_IM ,alpha,Uw,Vw)
imwrite(W_IM,'lena1.jpg','Mode','lossy','Quality',60);
compress_IM = imread ('lena1.jpg');
figure
subplot(1,2,1)
imshow(W_IM)
title('watermarked image')
subplot(1,2,2)
imshow(compress_IM)
title('compressed Image')
B_comp = dct(double(compress_IM));
F_comp=reshape(B_comp,[512,512]);
[Uc,Sc,Vc] = svd(F_comp);
for i=1:256
    EX_C(i,i)=(Sc(i,i)-S(i,i))/alpha;
end
EX=Uw*EX_C*Vw';
EX = idct(EX);
EX=reshape(EX,[256,256]);
EX=real(EX);
EX_C=uint8(EX);
figure
subplot(1,2,1)
imshow(uint8(W))
title('original watemark')
subplot(1,2,2)
imshow(EX_C)
title('extracted watermark from a compressed image')
% peaksnr_comp=psnr(compress_IM,uint8(A))
peaksnr_comp_wm = psnr(EX_C,uint8(W))
% peaksnr_wm = psnr(EX_N,uint8(W))
% temp = sum(not(xor(W(:),EX_N(:))));
% BCR = (temp/(256*256))*100
% r = corrcoef(double(W),double(EX_N))
peaksnr_comp=psnr(compress_IM,uint8(A))
ssimval_comp = ssim(compress_IM,uint8(A))
ssim_wmcomp= ssim(EX_C,uint8(W))
end