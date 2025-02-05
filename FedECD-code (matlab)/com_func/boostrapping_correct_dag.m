function [Gs] = boostrapping_correct_dag(dataset,final_skele)

rng(666); % Lock the random seed
num_sub_data=15;
[n_samps,~]=size(dataset);

Gs=cell(1,num_sub_data);
for nsd=1:num_sub_data
    index=ceil(rand(1,n_samps)*n_samps);
    index=index';
    Data_Bootstrap = dataset(index,:); % Generate a new dataset through Bootstrap sampling
    
    cpm = tril(sparse(final_skele));
    LocalScorer = bdeulocalscorer(Data_Bootstrap, max(Data_Bootstrap));
    HillClimber = hillclimber(LocalScorer, 'CandidateParentMatrix', cpm);
    Gs{nsd} = HillClimber.learnstructure();
    Gs{nsd}=full(Gs{nsd});
end

end

