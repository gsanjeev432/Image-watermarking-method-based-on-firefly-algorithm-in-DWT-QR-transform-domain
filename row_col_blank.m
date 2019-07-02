function   [I] = row_col_blank(A, S,W,W_IM ,alpha,Uw,Vw  )
I = W_IM;
I(14,:) = 0;
I(169,:) = 0;
I(119,:) = 0;
I(:,26) = 0;
I(:,99) = 0;
I(:,192) = 0;
figure
subplot(1,2,1)
imshow(W_IM)
title('Watermarked Image')
subplot(1,2,2)
imshow(I)
title('After ROW.COL.BLANKING attack')
B_RC = dct(double(I));
F_RC=reshape(B_RC,[512,512]);
[Urc,Src,Vrc] = svd(F_RC);
for i=1:256
    EX_RC(i,i)=(Src(i,i)-S(i,i))/alpha;
end
EX=Uw*EX_RC*Vw';
EX = idct(EX);
EX=reshape(EX,[256,256]);
EX=real(EX);
EX_RC=uint8(EX);
figure
subplot(1,2,1)
imshow(uint8(W))
title('original watemark')
subplot(1,2,2)
imshow(EX_RC)
title('extracted watermark from a row column blanking image')
% peaksnr_wm = psnr(EX_N,uint8(W))
% temp = sum(not(xor(W(:),EX_N(:))));
% BCR = (temp/(256*256))*100
% r = corrcoef(double(W),double(EX_N))
psnr_R_C_blank = psnr(I,uint8(A))
ssim_R_C_blank = ssim(I,uint8(A))
ssim_wmbl = ssim(EX_RC,uint8(W))
peaksnr_R_C_wm = psnr(EX_RC,uint8(W))

end

