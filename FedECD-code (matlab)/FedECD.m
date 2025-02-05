function [CausalS, Time] = FedECD(Datasets, Alpha, Threshold)
% by Xianjie Guo, 2024.08.30, Singapore, NTU
% Enhancing Causal Discovery in Federated Settings with Limited Local Samples

% Input:
% Datasets: a cell array of datasets on all clients. Note that the sample size can be different for each dataset but the feature dimensions must be the same.
% Alpha: the significant level for conditional independence tests, e.g. 0.01 or 0.05.
% Threshold: the threshold to determine whether to remove the causal edge in the weight skeleton.

% Output:
% CausalS: the learned causal structure.
% Time: the running time.

if (nargin < 3)
   Threshold=0.10;
end

maxK=3;
m=length(Datasets); % m is the number of clients.
[~,n_vars]=size(Datasets{1});

%#################################START#################################
start=tic;

skeleton = ones(n_vars,n_vars); % All connected Graph
skeleton=setdiag(skeleton,0);

% Phase 1: Optimizing causal skeleton based on Boostrapping
for condset_size=0:1:maxK
    skele_n=cell(1,m);
    for k=1:m
        [skele_n{k},is_converg] = ...
            skele_learn_single_layer_d(Datasets{k},skeleton,condset_size,Alpha);
    end
    
    if is_converg
        break; % Iterative convergence
    end
    
    % Aggregate the latest skeleton based on the current skele_n and obtain
    % which edges are about to be removed.
    [new_skele,edge_dele_pre]=skele_aggre(skele_n,skeleton);
    
    % Using Boostrapping based ensemble learning strategy to fix causal
    % edges that may be mistakenly deleted.
    % A two-layer causal skeleton aggregation strategy is adopted.
    % The first layer is to aggregate the causal skeleton learned from the
    % resampling data set within the client, and the second layer is to 
    % aggregate the causal skeleton returned by each client on the server.
    [edge_retain] = ...
        boostrapping_correct_skele(Datasets,edge_dele_pre,skeleton,condset_size,Alpha,Threshold);
    
    % Supplement the recovered causal edges back into the global skeleton.
    skeleton=new_skele+edge_retain;
end


% Phase 2: Optimizing causal structure based on Boostrapping

% On each client, the consistent skeleton is orientation corrected by Bootstrapping.
% A two-layer causal structure aggregation strategy is adopted. The first
% layer aggregates the causal structures learned from the resampling data set within the client, 
% and the second layer aggregates the causal structures returned by each client on the server.
DAGs=cell(1,m);
for k=1:m
    [Gs] = boostrapping_correct_dag(Datasets{k},skeleton);
    DAGs{k}=dag_aggre(Gs); % merge Gs within each client
end
CausalS=dag_aggre(DAGs); % merge DAGs on the server

Time=toc(start);
%#################################END#################################

end