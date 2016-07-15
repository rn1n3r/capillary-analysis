% Make sure to start parallel processing pool!
function fov = tryDifferentFM(measure, var, fname)

[~, idList] = getCapillaries(var);
fov = cell(size(idList, 1), 2);
fov(:, 1) = num2cell(idList(:, 1));

tic    
parfor i = 1:size(idList, 1)
    temp = getFocusPath(fname, var, idList(i), measure);
    fov{i, 2} = temp;
end                                                                                                                                                                                                                                                                                                                                                                                                                           
toc


end
