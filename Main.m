% The Matlab code of "Single Shot Active Learning using Pseudo Annotators".
%  If you are using this code, please consider citing the following reference:
%
%  Yang, Yazhou, and Marco Loog. "Single Shot Active Learning using Pseudo Annotators." eprint arXiv:1805.06660, 2018.
%
%  (C) Yazhou Yang, 2018
%  Email: yazhouy@gmail.com
%  Delft University of Technology
%

%% choice:  choose the active learning algorithms
%     1 -- Random sampling
%     2 -- ALRL_MaxE: our method with MaxE
%     3 -- ALRL_MVAL: our method with MVAL

%%
rng('default');

choice = 2;
num_repeat = 20; % repeat 20 times
num_query = [20:20:120]; % varied budgets of the number of queried samples
num_pseudo = 10; % the number of pseudo annotators

addpath(genpath(pwd));

% load the test dataset: Caltech10
load('Caltech10_zscore_SURF_L10.mat');
X = Xt;
Y = Yt;
num_instance = 500; % the number of instances after sub-sampling
num_fea = 50; % feature dimensionality after using PCA
%% pre-process the data and find the initial labeled data
[X, Y, train_list, test_list, init] = pre_process(X, Y, num_repeat, num_instance, num_fea);
%%

Accuracy = zeros(num_repeat,length(num_query));

for i=1:num_repeat  
    
    train_X = X(train_list(i,:),:);
    test_X = X(test_list(i,:),:);
    train_Y = Y(train_list(i,:),:);
    test_Y = Y(test_list(i,:),:);
    ini_set = init(i,:);
    
    for j=1:length(num_query)    
        fprintf('repetition number: %i, labeling budget: %i. \n \n', i, num_query(j));
        SVM_acc = single_shot_AL(train_X, train_Y, ini_set, test_X, test_Y, num_query(j), choice, num_pseudo);
        Accuracy(i,j) = SVM_acc;
    end    
    fprintf('\n');
end

% plot the average performance

figure,
plot(mean(Accuracy),'->','MarkerSize',14);
axis tight
ylabel('Average Accuracy (SVM)');
xlabel('Number of queried samples')
xticks([1 2 3 4 5 6])
xticklabels([20 40 60 80 100 120]);

