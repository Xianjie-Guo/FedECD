[Enhancing Causal Discovery in Federated Settings with Limited Local Samples](https://openreview.net/forum?id=Js64okXDUE) <br>

# Usage
"FedECD.m" is the main function. <br>
Note that the current code has only been debugged on Matlab (2018a) with a 64-bit Windows system and supports only discrete datasets.<br>
----------------------------------------------
function [CausalS, Time] = FedECD(Datasets, Alpha, Threshold) <br>
* INPUT: <br>
```Matlab
Datasets: a cell array of datasets on all clients. Note that the sample size can be different for each dataset but the feature dimensions must be the same.
Alpha: the significant level for conditional independence tests, e.g. 0.01 or 0.05.
Threshold: the threshold to determine whether to remove the causal edge in the weighted skeleton.
```
* OUTPUT: <br>
```Matlab
CausalS: the learned causal structure.
Time: the running time.
```

# Example for discrete dataset
```Matlab
clear;
clc;
addpath(genpath('com_func/'));

graph_path='./dataset/Child_graph.txt';
data_path='./dataset/Child_5000samples.txt';

alpha=0.01; % the significant level.
client_num=5; % the number of clients.
threshold=0.10; % the threshold.
ground_truth=load(graph_path);
data=importdata(data_path)+1;
[datasets] = split_dataset(data, client_num);
[dag,time] = FedECD(datasets, alpha, threshold); % dag is the learned causal structure.

% evaluate the learned causal structure.
[fdr,tpr,fpr,SHD,reverse,miss,extra,undirected,ar_f1,ar_precision,ar_recall]=eva_DAG(ground_truth,dag); 
```

# Reference
* Guo, Xianjie, et al. "Enhancing Causal Discovery in Federated Settings with Limited Local Samples." *International Workshop on Federated Foundation Models in Conjunction with NeurIPS 2024 (FL@FM-NeurIPS)* (2024).
