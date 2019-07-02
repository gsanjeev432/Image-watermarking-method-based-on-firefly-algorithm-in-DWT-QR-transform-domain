%WATERMARK EMBEDDING.
clc;
clear all;
close all;

%INPUT/ORIGINAL/HOST IMAGE
original_image_1 = imread('lena.jpg');
original_image=rgb2gray(original_image_1);

%RESIZE HOST IMAGE (256*256)
ORG_IMG_RESIZE= imresize(original_image,[256 256]);
figure(1);imshow(ORG_IMG_RESIZE);title('HOST IMAGE');

%INTEGER TO DOUBLE CONVERSION (USED TO CALCULATE SSIM)
ORG_IMG_RESIZE_double=double(ORG_IMG_RESIZE);

%CONVERT IMAGE INTO COLUMN VECTOR
COL_VECTOR = reshape(ORG_IMG_RESIZE,[],1);
%figure(2);imshow(uint8(COL_VECTOR)); title('IMAGE COLUMN VECTOR');

%SORT PIXEL VALUES IN ASCENDING ORDER
[ASCENDING_MAT,IND]=sort(COL_VECTOR);
%figure(3);imshow(ASCENDING_MAT);title('ASCENDING ORDER');

%SCRAMBLED IMAGE (256*256)
Scrambled_IMG =reshape(ASCENDING_MAT,256,256);
figure(4);imshow(Scrambled_IMG);title('SCRAMBLED IMAGE')
SIZE_Scrambled = size(Scrambled_IMG);

%DWT
[LL,LH,HL,HH]=dwt2(Scrambled_IMG,'db1');
figure(5)
subplot(2,2,1);imagesc(LL);title('LL band of image');
colormap gray;
subplot(2,2,2);imagesc(LH);title('LH band of image');
subplot(2,2,3);imagesc(HL);title('HL band of image');
subplot(2,2,4);imagesc(HH);title('HH band of image');

%BINARY WATERMARK (32*32)
watermark_1 = imread('lg.jpg');
watermark_2=im2bw(watermark_1 );
watermark= imresize(watermark_2,[32 32]);
figure(6);imshow( watermark);title('WATERMARK')

lambda=1.2;
k=[1 1 1 1];

%CONVERSION OF 'LL'(128*128) SUBBAND INTO CELLS(4*4)  [TOTAL (32*32 CELLS)]
AB = mat2cell(LL, [4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 ],[4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4]);

for i=1:32
    for j=1:32
        [Q,R] = qr(AB{i,j});
        disp('Q:');
        disp(Q)
        disp('R:');
        disp(R)
        
        if  watermark(i,j)==1        %WATERMARK EMBEDDING
            R(1,:)=R(1,:)+(lambda .* k);
        else
            R(1,:)=R(1,:)-(lambda .* k);
        end
        
        Each_cell_1 = Q*R;
        Each_cell = mat2cell( Each_cell_1,4,4);
        AB(i,j) =  Each_cell;
    end
end



% WATERMARKED LL SUBBAND BY COMBINGING ALL CELLS
INV_LL=cell2mat(AB);
figure(7)
colormap gray;
imagesc(INV_LL)
title('WATERMARKED LL SUBBAND');

%INVERSE DWT
Idwt_mat = idwt2(INV_LL,LH,HL,HH,'db1',SIZE_Scrambled);
figure(8)
colormap gray;
imagesc(Idwt_mat)
title('I-DWT')

%CONVERT INVERSE DWT INTO COLUMN VECTOR
Idwt_mat1 = reshape(Idwt_mat,[],1);
figure(9)
colormap gray;
imagesc(Idwt_mat1)
title('IDWT COLUMN VECTOR');

% RETRIVE ORIGINAL POSITION OF EACH PIXEL
for i1=1:65536
    j1=IND(i1);
    ORG_POSITION(j1,:)=Idwt_mat1(i1);
end

%WATERMARKED IMAGE (256*256)
WATERMARKED_IMAGE_1 = reshape(ORG_POSITION,256,256);
WATERMARKED_IMAGE=uint8(WATERMARKED_IMAGE_1);
figure(11)
colormap gray;
imagesc(WATERMARKED_IMAGE)
title('WATERMARKED IMAGE');

%%
% MEAN SQUARE ERROR (BETWEEN ORIGINAL IMAGE AND WATERMARKED IMAGE)
D = (WATERMARKED_IMAGE_1-ORG_IMG_RESIZE_double).^2;
MSE = sum(D(:))/65536;
disp('MSE:');
disp(MSE)

% SSIM  (BETWEEN ORIGINAL IMAGE AND WATERMARKED IMAGE)
SSIM_1=ssim(WATERMARKED_IMAGE_1,ORG_IMG_RESIZE_double);
disp('SSIM:');
disp(SSIM_1)

%WATERMARK EXTRACTION.
W_COL_VECTOR = reshape(WATERMARKED_IMAGE,[],1);
figure(12); imshow(W_COL_VECTOR);title('WATERMARKED COLUMN VECTOR');

[ascending_w,ind_w]=sort(W_COL_VECTOR);
figure(13);imshow(ascending_w);title('WATERMARKED ASCENDING ORDER');

W_Scrambled_IMG =reshape(ascending_w,256,256);
figure(14);imshow(W_Scrambled_IMG);title('W SCRAMBLED IMAGE')
SIZE_Scrambled_W = size(W_Scrambled_IMG);

[LL_w,LH_w,HL_w,HH_w]=dwt2(W_Scrambled_IMG,'db1');
figure(15)
subplot(2,2,1);imagesc(LL_w);title('LL band of Watermarked image');
colormap gray;
subplot(2,2,2);imagesc(LH_w);title('LH band of Watermarked image');
subplot(2,2,3);imagesc(HL_w);title('HL band of Watermarked image');
subplot(2,2,4);imagesc(HH_w);title('HH band of Watermarked image');

AB_w = mat2cell(LL_w, [4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 ],[4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4]);

for i2=1:32
    for j2=1:32
   
        [Q_w1,R_w1] = qr(AB_w{i2,j2});
        
        disp('Q_w1:');
        disp(Q_w1)
        disp('R_w1:');
        disp(R_w1)
        
               
        if  (corr(R_w1(1,:),k )>=0)
            Extracted_watermark(i2,j2)=1;
            
        else 
            Extracted_watermark(i2,j2)=0;
        end
        
    end
end

% %EXTRACTED WATERMARK
Extracted_watermark_1 = (Extracted_watermark)
figure(16)
imshow((Extracted_watermark))
title('EXTRACTED WATERMARK');
