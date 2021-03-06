function D = disparity_ncorr(L, R, winsize)
    img_length = size(L, 1);
    img_width = size(L, 2);
    D = zeros(img_length, img_width);
    parfor row=1:(img_length - winsize + 1)
        strip_L = L(row:(row + winsize - 1),:);
        strip_R = R(row:(row + winsize - 1),:);
        for col=1:(img_width - winsize + 1)
            patch_L = strip_L(:, col:col+winsize-1);
            right_col_ind = max(1,col-winsize-floor(img_width/4)):min(col+winsize+floor(img_width/4), img_width-winsize+1);
            c = normxcorr2(patch_L, strip_R(:,right_col_ind));
            [~,best_R_col] = find(c==max(c(:)));
            best_R_col = best_R_col + (best_R_col~=0)*right_col_ind(1);
            D(row,col) = best_R_col - col; 
        end
    end    
end
    
    