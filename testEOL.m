

function eolTable = testEOL (areas, idList, frames)



eolTable = zeros(size(idList));
eolTable(:,3) = 0;
eolTable(:, 1) = idList(:, 1);

h = waitbar(0, 'Analysing frames...please wait');
for i = 1:100:1260
   

    % Calculation
    I = getFrame(frames, i);
    for j = 1:size(eolTable, 1)
        
        
         
%         I_new = I./65536;
%         ent = entropy(I_new(areas == eolTable(j, 1)));
%         vars = var(I(areas == eolTable(j, 1)));
%         vars = vars / numel(I(areas == eolTable(j, 1)));
%         vars = vars / mean(I(areas == eolTable(j, 1)));
%         
%         if eolTable(j, 2) < vars
%             eolTable(j, 2) = vars;
%         end
%         
%         
%         if eolTable(j, 3) < ent
%             eolTable(j, 3) = ent;
%         end

        bren = fmeasure(I(areas == eolTable(j, 1)), 'BREN');
        if eolTable(j, 2) < bren
            eolTable(j, 2) = bren;
        end        
            
       
    end
    if ~mod(i - 1, 100)
        waitbar(i/1260);
    end
end
close(h);
eolTable = flipud(sortrows(eolTable, 2));
end