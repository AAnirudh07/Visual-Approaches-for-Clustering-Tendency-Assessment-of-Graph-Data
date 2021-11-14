% This function computes the eigenvectors of the normalized laplacian
% matrix of a graph. It then reduces the eigenvectors to a 3-dimensional
% space.
%Inputs: 
% G - matlab representation of a graph.
% kmin - minimum number of clusters
% kmax - maximum number of clusters
%Outputs: 
% L1 - normalized laplacian matrix
% E - eigen values of L1
% v - eigen vectors of L1
function [L1,E,v] = laplacian_eigenv(G,kmin,kmax)
    N = full(adjacency(G,'weighted'));
    n = size(N,1);
    D = calc_diag_mat(N);
    L = zeros(n,n);
    L = D-N;
    L1 = D^(-1/2)*L*D^(-1/2);
    [V,E] = eig(L1);
    %Estimate the optimal number of clusters 'k' using the eigengap heuristic
    %Reduce the number of eigenvectors to 'k' (k varies from kmin to kmax)
    e=diag(E);
    [vsort, index] = sort(e,'ascend');
    eg = zeros(length(vsort)-1,1);
    for i=1:1:length(eg)
        if ((i<kmin) || (i> kmax))
            eg(i)=-1;
        else
            eg(i)=vsort(i+1)-vsort(i);
        end
    end
    [~,k] = max(eg); 
    v=zeros(size(V,1),k);
    for i=1:1:k 
        v(:,i) = V(:,index(i));
    end
      for i=1:1:length(v(:,1))
            v(i,:)=v(i,:)/sqrt(sum(v(i,:).*v(i,:)));
      end
end
    

