% This function computes the euclidean distance between the data points.
% These data points are essentially the reduced coordinates of the
% eigenvectors of the normalized laplacian matrix. It generates a
% dissimilarity matrix.
%Inputs: 
%Vred - n*k matrix, n being the number of vertices
%Outputs:
%D - n*n dissimilarity matrix where Dij=euclidean distance between i and j
function [D] = euclidean(Vred)
       %Each row of Vred is the feature vector of the vertices 
       n = size(Vred,1);
       D = zeros(n,n);
       for i=1:n
           for j=1:n
               D(i,j) = norm(Vred(i,:)-Vred(j,:));
           end
       end
end
       