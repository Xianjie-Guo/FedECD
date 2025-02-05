function [edge_retain] = boostrapping_correct_skele(Datasets,edge_dele_pre,old_skele,condset_size,alpha,threshold)
% Using Boostrapping based ensemble learning strategy to fix causal edges that may be mistakenly deleted

rng(666); % Lock the random seed
num_sub_data=15;
m=length(Datasets);

weight_skele_ss=zeros(size(old_skele,1),size(old_skele,1));
edge_retain=zeros(size(old_skele,1),size(old_skele,1));
for k=1:m
    [n_samps,n_vars]=size(Datasets{k});
    
    weight_skele_s=zeros(n_vars,n_vars);
    for nsd=1:num_sub_data
        index=ceil(rand(1,n_samps)*n_samps);
        index=index';
        Data_Bootstrap = Datasets{k}(index,:); % Generate a new dataset through Bootstrap sampling

        [weight_skele] = ...
            skele_learn_single_layer_d_sub(Data_Bootstrap,old_skele,condset_size,alpha,edge_dele_pre);
        weight_skele_s=weight_skele_s+weight_skele;
    end
    weight_skele_s=weight_skele_s/num_sub_data;
    
    weight_skele_ss=weight_skele_ss+weight_skele_s;
end
weight_skele_ss=weight_skele_ss/m;

for i=1:n_vars
    for j=1:i-1
        if (edge_dele_pre(i,j)~=0)&&(weight_skele_ss(i,j)<=threshold) % If the desire of deleting edge is low, the causal edge is retained.
            edge_retain(i,j)=1;
            edge_retain(j,i)=1;
        end
    end
end

end

