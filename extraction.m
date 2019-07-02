function [ EX_WM ] = extraction(A,S,W,W_IM ,alpha,Uw,Vw)
B_W = dct(double(W_IM));
F_W=reshape(B_W,[512,512]);
[Ub,Sb,Vb] = svd(F_W);
for i=1:256
    EX_S(i,i)=(Sb(i,i)-S(i,i))/alpha;
end
EX=Uw*EX_S*Vw';
EX = idct(EX);
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
% temp = sum(not(xor(W(:),EX_WM(:))));
% BCR = (temp/(256*256))*100
% r = corrcoef(double(W),double(EX_WM))
end

