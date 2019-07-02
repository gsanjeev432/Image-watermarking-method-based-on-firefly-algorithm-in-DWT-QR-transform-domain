function  [ J] = translation( A, S,W,W_IM ,alpha,Uw,Vw)
I = W_IM;
J = imtranslate(I,[25, 25]);
figure
subplot(1,2,1);
imshow(I)
title('Watermarked Image')
subplot(1,2,2);
imshow(J)
title('Translated Image')
B_TR = dct(double(J));
F_TR=reshape(B_TR,[512,512]);
[Ut,St,Vt] = svd(F_TR);
for i=1:256
    EX_TR(i,i)=(St(i,i)-S(i,i))/alpha;
end
EX=Uw*EX_TR*Vw';
EX = idct(EX);
EX=reshape(EX,[256,256]);
EX=real(EX);
EX_TR=uint8(EX);
figure
subplot(1,2,1)
imshow(uint8(W))
title('original watemark')
subplot(1,2,2)
imshow(EX_TR)
title('extracted watermark from a translated image')
% peaksnr_wm = psnr(EX_N,uint8(W))
% temp = sum(not(xor(W(:),EX_N(:))));
% BCR = (temp/(256*256))*100
% r = corrcoef(double(W),double(EX_N))
peaksnr_TR=psnr(J,uint8(A))
ssimval_TR = ssim(J,uint8(A))
peaksnr_TR_wm=psnr(EX_TR,uint8(W))
ssim_wmtr = ssim(EX_TR,uint8(W))
end