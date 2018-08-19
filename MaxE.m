function [query_index, fnum] = MaxE(X, Y, Dl, Du)
% MaxE: the maximum entropy method, one example of uncertainty sampling

num_class = length(unique(Y));

% get the labeled data and unlabeled data
Ldata = X(Dl',:);
Udata = X(Du',:);
Llabel = Y(Dl',:);
Ulabel = Y(Du',:);

% train using liblinear, and calculate the posterior probability
model = lineartrain(Llabel, sparse(Ldata), '-s 0 -c 100 -B 1 -q');
[~, ~, dec_values] = linearpredict(Ulabel, sparse(Udata), model,'-b 1 -q');

value = dec_values .* log(dec_values+1e-100); % add 1e-100 to avoid the NaN
entropy = (-1)*sum(value,2)/log(num_class);

[~, ind] = sort(entropy, 'descend');

fnum = ind(1);
query_index = Du(fnum);
end