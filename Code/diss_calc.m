% This function calculates the shortest path between nodes in a graph
%Inputs: 
% G - matlab representation of a graph
%Outputs: D - dissimilarity matrix where Dij = Number of hops between i and j
function [return_matrix] = diss_calc(G)
    D = full(adjacency(G,'weighted'));
    %construct the jaccard distance matrix: 1 - (intersection)/union
    D(D~=1) = 0;
    for i=1:size(D,1)
        D(i,i)=1;
    end
    return_matrix = zeros(size(D,1),size(D,1));
    for i=1:size(D,1)
        for j=1:size(D,1)
            intersection = sum(and(D(i,:),D(j,:)));
            s = min(sum(D(i,:)==1),sum(D(j,:)==1));
            return_matrix(i,j) = 1-(intersection/(s));
        end
    end
end


