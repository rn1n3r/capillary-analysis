function compareFocalPlanes(varargin)

targetID = 600;

for i = 1:length(varargin)
    
    
    fov = varargin{i};
    nameStr = inputname(i);
    
    
    maxVal = 0;
   
    maxValCV = 0;
    
    for j = 1:size(fov, 1)
        if fov{j, 1} == targetID || targetID == 0
            values = nanmean(fov{j, 2}, 2);
            if maxVal < max(nanmean(values, 2))
                maxVal = max(values);
            end
            
            subplot(2, length(varargin), i);
            hold on;
            scatter(1:520, nanmean(values, 2), [], 'b');
            scatter(1:520, nanstd(fov{j ,2}, 0, 2), [], 'r');
            hold off
            title([nameStr ' - ' num2str(fov{j, 1})]);
            xlabel('Y-coordinate on path');
            ylabel('Average focus level');
            
            subplot(2, length(varargin), i+length(varargin));
            
            scatter(1:520, nanstd(fov{j ,2}, 0, 2)./values);
            %axis([1 520 minVal maxVal]);
            title([nameStr ' - ' num2str(fov{j, 1}) ' CV']);
            fprintf('%d\n', fov{j, 1});
            fprintf('Average mean = %d\n', nanmean(values));
            fprintf('Average std = %d\n', nanmean(nanstd(fov{j ,2}, 0, 2)));
            fprintf('Average CV = %d\n', nanmean(nanstd(fov{j ,2}, 0, 2)./values));
            
            if maxValCV < max(nanstd(fov{j ,2}, 0, 2)./values)
                maxValCV = max(nanstd(fov{j ,2}, 0, 2)./values);
            end
        end
    
    end


end

for i = 1:length(varargin)
    subplot(2, length(varargin), i);

    axis([1 520 0 maxVal]);
    
    subplot(2, length(varargin), i+length(varargin));
    axis([1 520 0 maxValCV]);
end



end