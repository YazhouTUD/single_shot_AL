function [X, Y, train_list, test_list, init] = pre_process(X, Y, num_repeat,num_instance, num_fea)
% num_instance: the number of instances after sub-sampling
% num_fea:  feature dimensionality after using PCA

%% pre-processing: sub-sampling and use PCA to improve the computational efficiency
if num_instance< length(Y) && num_instance > length(unique(Y))
    rand_num = randperm(size(X, 1));
    X = X(rand_num(1: num_instance),:);
    Y = Y(rand_num(1: num_instance),:);
end
% PCA
options = [];
options.ReducedDim = num_fea;
[eigvector,~] = myPCA(X,options);
X = X*eigvector;                       
%%
length_X = size(X,1);
num_train = floor(length_X/2); % half for training and half for test
train_list =[];
test_list =[];

init = []; % initial set

n_class = length(unique(Y));

for i =1:num_repeat    
    rand_num = randperm(length_X);
    train_list = [train_list; rand_num(1: num_train)];
    test_list = [test_list; rand_num(num_train+1:end)];
    train_label = Y(rand_num(1: num_train),:);        
    %% important: randomly select one instance per class as the initial labeled set
    
    mi = unique(Y);
    for ii=1:n_class
        inde=find(train_label==mi(ii));
        query_index(ii)=inde(randi(length(inde),1));
    end
    
    init = [init; query_index];
end

end