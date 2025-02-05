function [new_skele,edge_dele] = skele_aggre(skele_n,old_skele)
% Aggregate the global skeleton returned from multiple clients.

n_vars=size(skele_n{1},1);
m=length(skele_n);
new_skele=zeros(n_vars,n_vars);
edge_dele=zeros(n_vars,n_vars); % Mark the edges that will be removed in this round

for k=1:m
    new_skele=new_skele+skele_n{k};
end
new_skele=new_skele/m;

for i=1:n_vars
    for j=1:i-1
        if old_skele(i,j)==1 % Edges that have been explicitly removed in the previous iteration will no longer be considered.
            if new_skele(i,j)>=0.5
                new_skele(i,j)=1;
                new_skele(j,i)=1;
            else
                new_skele(i,j)=0;
                new_skele(j,i)=0;
                
                % Mark the edges that will be removed in this round
                edge_dele(i,j)=1;
                edge_dele(j,i)=1;
            end
        end
    end
end

end

