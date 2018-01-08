%extrafix

function cur = extraFix(cur, prev, birthFlag)
    
% give up on missing detection and conclude track prematurely

if birthFlag == true
    startNo = 2; % discount the first one if new birth
    targetSize = size(prev) + 1;
else
    startNo = 1;
    targetSize = size(prev);
end

highCost = 300;

while size(cur,1) > targetSize

    % minimize the cost!!!!!!!!!!! delete the extra one
    for j = startNo:length(cur)

        testCur = cur;
        testCur(j,:) = [];
        [assn, cost] = munkres(pdist2(prev, testCur));

        if cost < highCost
           theExtraOne = j;
           highCost = cost;
        end

    end

    cur(theExtraOne, :) = [];
    
end

end