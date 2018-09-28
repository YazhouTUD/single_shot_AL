function next_index = ALRL(X, Y, Dl, Du, num_query,num_pseudo, method)

Distance = pdist2(X,X);

tem_Dl = singleshot_random_labeling(X, Y, Dl, Du, num_pseudo, Distance, num_query,method);

next_index = tem_Dl;
end


function tem_Dl = singleshot_random_labeling(X, Y, Dl, Du, num_pseudo, Distance, num_query,method)

tem_Dl = Dl;
tem_Du = Du;

old_Dl = tem_Dl;
old_Du = tem_Du;

while length(tem_Dl)<num_query
    %     fprintf('iter: %f \n',length(tem_Dl)/total_num);
    cand_set = zeros(num_pseudo, length(tem_Dl)+1);
    for i_r = 1:num_pseudo
        use_label = random_labelling(Y,Dl,tem_Dl);
        
        
        if strcmp(method,'MVAL')
            % active learner: MVAL using logistic regression as the classifier on multi-class tasks
            [query_index, fnum] = MVAL_logistic_multi(X, use_label, tem_Dl, tem_Du);
        end
        if strcmp(method,'MaxE')
            % active learner: MaxE
            [query_index, fnum] = MaxE(X, use_label, tem_Dl, tem_Du);
        end
        
        tem_Dl = [tem_Dl query_index];
        tem_Du(fnum) = [];
        
        cand_set(i_r,:)= tem_Dl;
        % reset
        tem_Dl = old_Dl;
        tem_Du = old_Du;
        
    end
    Dis = MNND(Y, Dl, Du, cand_set, Distance);
    [~, ind]= sort(Dis,'ascend');
    tem_Dl =cand_set(ind(1),:);
    tem_Du = 1:length(Y);
    tem_Du(tem_Dl)=[];
    
    old_Dl = tem_Dl;
    old_Du = tem_Du;        
end

end


function use_label = random_labelling(Y,Dl,tem_Dl)
% randomly and uniformly annotate each instance in Q

cand_labels = unique(Y);

use_label = Y;

ini = length(Dl)+1;
if length(tem_Dl)>= ini
    for i = ini:length(tem_Dl)
        ri = cand_labels(randi(length(cand_labels),1));
        use_label(tem_Dl(i)) = ri;
    end
end
use_label(Dl) =Y(Dl); % make sure that instances in L are truly labeled.

if size(use_label,1)~=size(Y,1)
    use_label= use_label';
end

end


function Dis = MNND(Y, Dl, Du, BAS, Distance)
% MNND: Minimizing Nearest Neighbor Distance

Dis = zeros(size(BAS,1),1);

for bi=1:size(BAS,1)
    S = BAS(bi,:);
    U = 1:length(Y);
    U(S)=[];
        
    Dis(bi) =nearest_neighhor_distance(Dl, U, S, Distance);
end
end



function score = nearest_neighhor_distance(Dl, Du, S, Distance)  
dis = Distance;
Du_dis = dis(Du,S);
score = sum(min(Du_dis,[],2));
end

