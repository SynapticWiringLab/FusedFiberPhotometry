function [signal_out] = dwnsmp(signal_in,Fq_in, Fq_out)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
bins = round(1:Fq_in/Fq_out:(length(signal_in)));
for bin_idx = 1:length(bins)-1
    signal_out(bin_idx)  = mean(signal_in(bins(bin_idx):bins(bin_idx+1)));
end
end

