function cutoffVal = findMostValuesHist(values, edges)

   
    target = floor(0.95*sum(values));
    bins = length(values);
    upper = bins;
    guess = floor(bins/2);

    for i = 1:bins
        sum(values(1:guess));

        diff = sum(values(1:guess)) - target
     
        if diff <= 2 && diff >= -2
            break;
        elseif diff > 2
            upper = guess;
            guess = guess - floor((upper - guess/2));
        elseif diff < -2
            upper = 0;
            guess = guess - floor((upper - guess/2));
        end
        guess
    end
  
    cutoffVal = edges(guess+1);
    
end