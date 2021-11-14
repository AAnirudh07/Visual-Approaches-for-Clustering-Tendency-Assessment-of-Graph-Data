% This function calculates the degree of each node of the graph.
% The graph is represented as an adjacency matrix
%Inputs: 
% N -  n*n adjacency matrix
%         
%Outputs:
%D - n*n diagonal matrix of N
function [D] = calc_diag_mat(N)
n =  size(N,1);
D = zeros(n,n);
row_sum = 0;
    for row=1:n
        row_sum = 0;
           for col=1:n
               row_sum = row_sum + N(row,col);
           end
        D(row,row) = row_sum;
    end
end

               