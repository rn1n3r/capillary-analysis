for i = 1:size(idList, 1)
[~,~,~,~,~,b] = testSliding(var, frames, idList(i, 1));
fprintf('ID: %d\n', idList(i, 1));
nanmean(b(:, 2))
nanstd(b(:, 2))
end