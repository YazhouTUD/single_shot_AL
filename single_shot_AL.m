function SVM_acc = single_shot_AL(Xtr, Ytr, ini_set, Xte, Yte, num_query, choice, num_pseudo)
%% set up Dl and Du
% Dl  - the index of labeled instances
% Du  - the index of unlabeled instances
Dl = ini_set;
Du = 1:length(Ytr);
Du(Dl) = [];
%% query num_query data points
num_query = num_query+length(Dl);

switch choice
    case 1 % random sampling
        query_index = [Dl Du(randperm(length(Du),num_query-length(Dl)))];        
    case 2 % ALRL_MaxE
        query_index = ALRL(Xtr, Ytr, Dl, Du, num_query,num_pseudo,'MaxE');
    case 3 % ALRL_MVAL
        disp('The program is running, please wait')
        query_index = ALRL(Xtr, Ytr, Dl, Du, num_query,num_pseudo,'MVAL');
        
    otherwise
        error('There are error about "choice". Please choose it from {1,2,3}!')
end
Dl = query_index;
%% compute the performance on test set

xtr = Xtr(Dl,:);
ytr = Ytr(Dl);

model = mysvmtrain(ytr, xtr,'-t 0 -c 10 -q 1');
[~, acc, ~] = mysvmpredict(Yte, Xte, model,'-q');
SVM_acc = acc(1);
end
