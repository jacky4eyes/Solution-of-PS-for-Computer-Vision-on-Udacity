%%  using mean-shift method to find the best match for the template
% this function uses mean shift method based on histograms of patches
% the template size decides the patch size
% using naive box kernel, of which L is the length
% 
% [u, v] = mean_shift_tracking(template, img, num_of_bins, u0, v0)
function [u, v,hist_template,hist_patch] = mean_shift_tracking(template, img, num_of_bins, u0, v0, L, max_iter)

    if ~exist('max_iter','var')
        max_iter = 20;
    end
    
    % size-related variables
    n = size(template,1);
    m = size(template,2);    

    hist_template = patch_RGB_histogram(template,num_of_bins);
    hist_template = hist_template./(num_of_bins(1)*num_of_bins(2)*num_of_bins(3));
    u = u0;
    v = v0;
    stuck_count = 0;
    iter_n = 0;
    best_val = inf;
    while (iter_n <= max_iter)&&(stuck_count <3)&&(best_val>5)
            
        T_arr = zeros([L L]);

        for i = 1:L
            u_p = u-(L+1)/2+i;
            u_p = min(size(img,2)-(m-1)/2-1, max((m-1)/2+1, u_p));
            for j = 1:L
                v_p = v-(L+1)/2+j;
                v_p = min(size(img,1)-(n-1)/2-1, max((n-1)/2+1, v_p));
                patch = img(v_p-(n-1)/2:v_p+(n-1)/2, u_p-(m-1)/2:u_p+(m-1)/2,:);
                hist_patch = patch_RGB_histogram(patch, num_of_bins);
                hist_patch = hist_patch./(num_of_bins(1)*num_of_bins(2)*num_of_bins(3));

                % Test score
                hist_template(hist_template==0) = nan;  % this is necessary
                T = nansum(nansum(nansum((hist_template - hist_patch ).^2./hist_template)));
                T_arr(i,j) = T;
            end
        end
%         hist_template
%         hist_patch
%         T_arr
        [vals,inds] = min(T_arr);
        [best_val,ind_v] = min(vals);
        ind_u = inds(ind_v);
        u_new = u + ind_u - (L+1)/2;
        v_new = v + ind_v - (L+1)/2;
%         [u v iter,best_val]

        
        if ((u_new==u)&&(v_new==v))
            stuck_count = stuck_count + 1;
        end
        u = u_new;
        v = v_new;
        iter_n = iter_n +1;
    end

end