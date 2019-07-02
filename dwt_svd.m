function cost = dwt_svd(best)
%WATERMARK EMBEDDING.

lambda = best;
ber = [];
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
% figure
% subplot(1,3,1)
% imshow(uint8(A))
% title('original image')
% subplot(1,3,2)
% imshow(uint8(W))
% title('watermark')
% subplot(1,3,3)
% imshow(W_IM)
% title('watermarked image')
ssim_val=ssim(W_IM,uint8(A));
%%  
W_IM_1 = imnoise(W_IM,'salt & pepper',0.001);
% figure
% imshow(W_IM_1)
[LL_w1,LH_w,HL_w,HH_w] = dwt2(W_IM_1,'db1');
F_W=reshape(LL_w1,[256,256]);
[Ub,Sb,Vb] = svd(F_W);
for i=1:128
    Extract_S(i,i)=(Sb(i,i)-S(i,i))/lambda;
end
EX=Uw*Extract_S*Vw';
EX = idwt2(EX,LHw,HLw,HHw,'db1',size(W_IM));
EX=reshape(EX,[256,256]);
EX=real(EX);
EX_WM=uint8(EX);
% figure
% subplot(1,2,1)
% imshow(uint8(W))
% title('original watemark')
% subplot(1,2,2)
% imshow(EX_WM)
% title('extracted watermark from sp noise')
ber(1) = biterr(uint8(W),EX_WM);
 
 %%
W_IM_2 = imnoise(W_IM,'gaussian',0,0.002);
% figure
% imshow(W_IM_2)
[LL_w2,LH_w,HL_w,HH_w] = dwt2(W_IM_2,'db1');
F_W=reshape(LL_w2,[256,256]);
[Ub,Sb,Vb] = svd(F_W);
for i=1:128
    Extract_S(i,i)=(Sb(i,i)-S(i,i))/lambda;
end
EX=Uw*Extract_S*Vw';
EX = idwt2(EX,LHw,HLw,HHw,'db1',size(W_IM));
EX=reshape(EX,[256,256]);
EX=real(EX);
EX_WM=uint8(EX);
% figure
% subplot(1,2,1)
% imshow(uint8(W))
% title('original watemark')
% subplot(1,2,2)
% imshow(EX_WM)
% title('extracted watermark from gaussian noise')
ber(2) = biterr(uint8(W),EX_WM);
%%

W_IM_3 = imnoise(W_IM,'speckle',0.005);
% figure
% imshow(W_IM_3)
[LL_w3,LH_w,HL_w,HH_w] = dwt2(W_IM_3,'db1');
F_W=reshape(LL_w3,[256,256]);
[Ub,Sb,Vb] = svd(F_W);
for i=1:128
    Extract_S(i,i)=(Sb(i,i)-S(i,i))/lambda;
end
EX=Uw*Extract_S*Vw';
EX = idwt2(EX,LHw,HLw,HHw,'db1',size(W_IM));
EX=reshape(EX,[256,256]);
EX=real(EX);
EX_WM=uint8(EX);
% figure
% subplot(1,2,1)
% imshow(uint8(W))
% title('original watemark')
% subplot(1,2,2)
% imshow(EX_WM)
% title('extracted watermark from speckle noise')
ber(3) = biterr(uint8(W),EX_WM);
%%
imwrite(W_IM,'lena1.jpg','Mode','lossy','Quality',25);
W_IM_4 = imread ('lena1.jpg');
% figure
% imshow(W_IM_4)
[LL_w4,LH_w,HL_w,HH_w] = dwt2(W_IM_4,'db1');
F_W=reshape(LL_w4,[256,256]);
[Ub,Sb,Vb] = svd(F_W);
for i=1:128
    Extract_S(i,i)=(Sb(i,i)-S(i,i))/lambda;
end
EX=Uw*Extract_S*Vw';
EX = idwt2(EX,LHw,HLw,HHw,'db1',size(W_IM));
EX=reshape(EX,[256,256]);
EX=real(EX);
EX_WM=uint8(EX);
% figure
% subplot(1,2,1)
% imshow(uint8(W))
% title('original watemark')
% subplot(1,2,2)
% imshow(EX_WM)
% title('extracted watermark from jpeg compression')
ber(4) = biterr(uint8(W),EX_WM);
%%

W_IM_5 = imgaussfilt(W_IM, 3,'FilterSize',3);
% figure
% imshow(W_IM_5)
[LL_w5,LH_w,HL_w,HH_w] = dwt2(W_IM_5,'db1');
F_W=reshape(LL_w5,[256,256]);
[Ub,Sb,Vb] = svd(F_W);
for i=1:128
    Extract_S(i,i)=(Sb(i,i)-S(i,i))/lambda;
end
EX=Uw*Extract_S*Vw';
EX = idwt2(EX,LHw,HLw,HHw,'db1',size(W_IM));
EX=reshape(EX,[256,256]);
EX=real(EX);
EX_WM=uint8(EX);
% figure
% subplot(1,2,1)
% imshow(uint8(W))
% title('original watemark')
% subplot(1,2,2)
% imshow(EX_WM)
% title('extracted watermark from gauss filter')
ber(5) = biterr(uint8(W),EX_WM);
biterr_avg = sum(ber);
cost = cost_f(ssim_val,biterr_avg);
 