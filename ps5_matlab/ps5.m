%% ps5


[x_grid,y_grid] = meshgrid(1:40, 1:30);

I_rx = x_grid/100;
I_ry = y_grid/100;

I = cumsum(I_rx,2) + cumsum(I_ry,1);
I = I./max(max(I));

figure(1);tightsubplot(1,1,1)
imshow(I)



%%

cumsum([1 3 5])