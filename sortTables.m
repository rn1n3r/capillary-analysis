col = input('Which column to sort by? ');
tables = who('total*');

for i = 1:numel(tables)
    
    eval(sprintf('%s = flipud(sortrows(%s, %d));', tables{i}, tables{i}, col));
    
    
end

clear i col tables;