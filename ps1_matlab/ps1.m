% ps1

%% 1-a
clc;
img = imread(fullfile('input', 'ps1-input0.png'));  % already grayscale
[img_edges, threshOut]  = edge(img,'canny',0.1,0.01);
figure(1)

subplot(2,2,1)
imshow(img);
subplot(2,2,2)
imshow(img_edges);
imwrite(img_edges, fullfile('output', 'ps1-1-a-1.png'));  % save as output/ps1-1-a-1.png

%% 2-a
% TODO: Plot/show accumulator array H, save as output/ps1-2-a-1.png
[H, theta, rho] = hough_lines_acc(img_edges);  % defined in hough_lines_acc.m
subplot(2,2,3)
imshow(imadjust(rescale(H)),'XData',theta,'YData',rho,'InitialMagnification','fit');
xlabel('\theta'), ylabel('\rho');
colormap(gca,hot);
axis on, axis normal;
imwrite(imadjust(rescale(H)), fullfile('output', 'ps1-2-a-1.png'));  % save as output/ps1-1-a-1.png

%% 2-b
% find and choose peaks 
peaks = hough_peaks(H, 6,'Threshold',0.2*max(H(:)),'NHoodSize',[5 5]);  % defined in hough_peaks.m
% peaks = houghpeaks(H, 15,'Threshold',0.4*max(H(:)),'NHoodSize',[5 5]);  % compare with MATLAB version 
% subplot(2,2,4)
% imshow(H,[],'XData',theta,'YData',rho,'InitialMagnification','fit');
% xlabel('\theta'), ylabel('\rho');
% axis on, axis normal, hold on;
% plot(theta(peaks(:,2)),rho(peaks(:,1)),'s','linewidth',10,'color','white');

%% 2-c 
% TODO: Highlight peak locations on accumulator array, save as output/ps1-2-b-1.png


hough_lines_draw(img, 'ps1-2-c-1.png', peaks, rho, theta)


%% TODO: Rest of your code here
