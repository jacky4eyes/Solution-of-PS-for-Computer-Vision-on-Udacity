%% ps6
clear all; clc;

% first, make sure your current directory is where this script is
% then add to path all functions essential to this project
addpath(genpath('../utilities'));  

%% 1a 

% implay('./input/pres_debate.avi')

fileID = fopen('./input/pres_debate.txt','r');
win_loc = fscanf(fileID,'%f');
% win_loc = round(win_loc);

pres_debate = VideoReader('./input/pres_debate.avi');
img_1 = double(read(pres_debate,[1]))./255;
img_1_gray = rgb2gray(img_1);

%%

% similarity window size (m, n)
m = floor(win_loc(3)/2)*2+1;  % an odd number will make life easier!
n = floor(win_loc(4)/2)*2+1;

u = (round(win_loc(1))+round(win_loc(1)+m-1))/2;
v = (round(win_loc(2))+round(win_loc(2)+n-1))/2;

% confirming template
template = img_1(v-(n-1)/2:v+(n-1)/2, u-(m-1)/2:u+(m-1)/2,:);

loc_x = u -(m-1)/2;
loc_y = v -(n-1)/2;
img_1_disp = draw_window(img_1,[loc_x loc_y  m n]);
% img_new_disp = draw_window(img,[u_p, v_p, n, m]);



%% initialisation

% hyperparameters
N = 500;  % sample size
sigma_MSE = 0.25; 


% initial round: uniform random sampling (excluding the margin area)
W = int16((m-1)/2+1:pres_debate.Width-(m-1)/2);
H = int16((n-1)/2+1:pres_debate.Height-(n-1)/2);
S = [randsample(W,N,true); randsample(H,N,true)]';


%% iterations making video

v_temp = VideoWriter('temp.avi');
% v_temp.Quality = 95;
open(v_temp)


for t = 1:1:200
    
    img_t = double(read(pres_debate,[t]))./255;
    w_t = calc_particle_weights(template, img_t, S, sigma_MSE);

    % [argvalue, argmax] = max(w_arr)
    % S(argmax,:)
    
    % resampling
    i_new = randsample(size(S,1),N,true,w_t);
    S = S(i_new,:);

    S(:,1) = min(pres_debate.Width-(m-1)/2-1, max((m-1)/2+1,S(:,1) + int16(round(normrnd(0,5,[N 1])))));
    S(:,2) = min(pres_debate.Height-(n-1)/2-1, max((n-1)/2+1,S(:,2) + int16(round(normrnd(0,5,[N 1])))));
    
    loc_x = round(mean(S(i_new,1)))-(m-1)/2;
    loc_y = round(mean(S(i_new,2)))-(n-1)/2;
    img_new_disp = draw_window(img_t,[loc_x, loc_y, m,n ]);
    
    writeVideo(v_temp, img_new_disp)
end


v_temp.close()


%%


%%


ccc = gcf;
delete(ccc.Children);
figure(1);

vl_tightsubplot(2,2,1);
imshow(img_1)

vl_tightsubplot(2,2,2);
imshow(mean(img_1,3))

vl_tightsubplot(2,2,3);
imshow(img_1_disp)


vl_tightsubplot(2,2,4);
imshow(img_new_disp)



%%



implay('./temp.avi')
