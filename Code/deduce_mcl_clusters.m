function [num_clusters, communities,comret] = deduce_mcl_clusters(g)
%DEDUCE_MCL_CLUSTERS - This function will interpret the MCL results and
% returns number of MCL clusters and their membership
% 
% [num_clusters, guiOutput] = deduce_mcl_clusters(sbeG, sbeNode)
%
% g     - Current network
%         ===============
%         The current loaded network.
%
% Example : [num_clusters, guiOutput] = deduce_mcl_clusters(g)
%        
% See also: mcl
%
% Systems Biology and Evolution Toolbox (SBEToolbox).
% Authors: Kranti Konganti, James Cai.
% (C) Texas A&M University.
%
% $LastChangedDate: 2013-05-24 11:18:16 -0500 (Fri, 24 May 2013) $
% $LastChangedRevision: 561 $
% $LastChangedBy: konganti $
%

deduced_indices = zeros(size(unique(g, 'rows')));

g = unique(g, 'rows');
for i = 1:size(g, 1)
    if ~isempty(find(g(i, :), 1))
        indices = find(g(i, :));
        for k = 1:length(indices)
            deduced_indices(i, indices(k)) = 1;
        end
    end
end
% Alternatively this could be used:
% deduced_indices = full(unique(g,'rows')~=0);

deduced_indices = unique(deduced_indices, 'rows');
communities = cell(1, size(g, 2));
comret = zeros(1,size(g, 2));
num_clusters = 0;
num_nodes = 0;

for nc = 1:size(deduced_indices, 1)
   nodeIndices = find(deduced_indices(nc, :));
   if length(nodeIndices) <= 0, continue; end
   num_clusters = num_clusters + 1;
   for nodeIndex = 1:length(nodeIndices);
       num_nodes = num_nodes + 1;
        communities{num_nodes} = sprintf('Node%04d\t%d',...
            nodeIndices(nodeIndex), num_clusters);
        comret(1,nodeIndices(nodeIndex)) = num_clusters;
   end
end