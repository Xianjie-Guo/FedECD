function [weight_skele] = skele_learn_single_layer_d_sub(sample_data,init_skele,condset_size,alpha,edge_dele_pre)
% Based on the skeleton obtained in the previous layer, learn a weight
% skeleton about the edge to be deleted from the extracted data, which only supports discrete datasets.

skeleton=init_skele;
[n_vars]=size(skeleton,1);
weight_skele=zeros(n_vars,n_vars);

[X,Y] = find(skeleton);
for i=1:length(X)
    x = X(i); y = Y(i);
    
    if (skeleton(x,y) ~= 0)&&(edge_dele_pre(x,y) ~= 0)
        ws=[]; % Store the weights corresponding to the confidence of a subset of conditions that make two variables independent.
        nbrs = mysetdiff(myneighbors(skeleton, y), x); % If the adj of Y can not separate the edges between x and y, the next round will consider whether the adj of X can separate.
        SS = subsets1(nbrs, condset_size);
        for si=1:length(SS)
            S = SS{si};
            ns=max(sample_data);
            [pval]=my_g2_test(x,y,S,sample_data,ns,alpha);
            if (~isnan(pval))&&(pval>alpha)
                [w]=calculate_weight(pval, alpha);
                ws=[ws w];
            end
        end
        if ~isempty(ws)
            weight_skele(x,y)=mean(ws);
            weight_skele(y,x)=mean(ws);
        end
    end
end

end
