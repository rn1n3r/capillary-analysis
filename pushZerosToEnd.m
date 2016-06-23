function y = pushZerosToEnd (x)

y = zeros (size(x));
i = find(x(:,1));
y(1:length(i), :) = x(find(x(:, 1)), :); %#ok<FNDSB>

end