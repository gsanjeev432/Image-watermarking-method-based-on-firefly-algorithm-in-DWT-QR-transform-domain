function cost = cost_f(ssim_val,biterr_avg)
cost = ((1 - ssim_val) + 30*0.2*(biterr_avg));
end