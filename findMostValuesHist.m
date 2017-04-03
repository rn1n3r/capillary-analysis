% Finds the value within the focus measure histogram which includes around
% 95% of the entire distribution
% TODO: Somehow fix for VOLA since there are negative values
function cutoffVal = findMostValuesHist(values, edges)

    target = floor(0.95*sum(values));
    bins = length(values);
    size(values)
    upper = bins;
    guess = floor(bins/2);

    for i = 1:bins
        sum(values(1:guess));

        diff = sum(values(1:guess)) - target;
     
        if diff <= 2 && diff >= -2
            break;
        elseif diff > 2
            upper = guess;
            guess = guess - floor((upper - guess/2));
        elseif diff < -2
            upper = 0;
            guess = guess - floor((upper - guess/2));
        end

    end
  
    cutoffVal = edges(guess+1);
    
end