function [Gs_aggre] = dag_aggre(Gs)

n_vars=size(Gs{1},1);
m=length(Gs);

% merge Gs
Gs_aggre=zeros(n_vars,n_vars);
for k=1:m
    Gs_aggre=Gs_aggre+Gs{k};
end

% Compare the element values at the corresponding diagonal positions
for i=1:n_vars
    for j=1:i-1
        if Gs_aggre(i,j)~=0||Gs_aggre(j,i)~=0
            if Gs_aggre(i,j)>=Gs_aggre(j,i)
                Gs_aggre(i,j)=1;
                Gs_aggre(j,i)=0;
            else
                Gs_aggre(i,j)=0;
                Gs_aggre(j,i)=1;
            end
        end
    end
end

end

