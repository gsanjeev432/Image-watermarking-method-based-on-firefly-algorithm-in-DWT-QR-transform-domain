function ber = biterr(image1,image2)
[M,N] = size(image1);
temp = sum((xor(image1(:),image2(:))));
ber = (temp/(M*N));