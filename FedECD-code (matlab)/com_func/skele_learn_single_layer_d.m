function [new_skele,is_converg] = skele_learn_single_layer_d(dataset,init_skele,condset_size,alpha)
% Learn a new global skeleton based on the skeleton obtained from the
% previous layer, which only supports discrete datasets.

skeleton=init_skele;
is_converg=1;

[X,Y] = find(skeleton);
for i=1:length(X)
    x = X(i); y = Y(i);
    
    if skeleton(x,y) ~= 0
        nbrs = mysetdiff(myneighbors(skeleton, y), x); % If the adj of Y can not separate the edges between x and y, the next round will consider whether the adj of X can separate.
        if length(nbrs) >= condset_size
            is_converg=0; 
            SS = subsets1(nbrs, condset_size);
            for si=1:length(SS)
                S = SS{si};
                
                ns=max(dataset);
                [pval]=my_g2_test(x,y,S,dataset,ns,alpha);
                if isnan(pval)
                    CI=0;
                else
                    if pval<=alpha
                        CI=0;
                    else
                        CI=1;
                    end
                end
                
                if(CI==1)
                    skeleton(x,y) = 0;
                    skeleton(y,x) = 0;
                    break; % no need to check any more subsets
                end
            end
        end
    end
end

new_skele=skeleton;

end
