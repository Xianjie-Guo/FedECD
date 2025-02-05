function [w]=calculate_weight(p_value, alpha)
% This function is used to convert the p-value into the weight.

% The p value in the interval (alpha, 1) is linearly mapped to the interval [0,1]
diff1=1-alpha;% Calculate the difference in length between the original interval and the new area: diff1=b-a and diff2=d-c;
diff2=1-0;
w=(p_value - alpha) / diff1 * diff2 + 0;

end

