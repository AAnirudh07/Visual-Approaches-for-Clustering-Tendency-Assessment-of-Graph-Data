% This function is used to generate sample Girvan-Newman and 
% planted-partition graphs.
%Inputs:
% choice: 1. Planted-Parition Graph
%         2. Girvan-Newman Graph
%         3. Zacharay karate club
%Outputs:
% G - graph 
% v0 - membership vectors
% clusters - number of clusters present in the graph 
% colors - array of rgb triplets 
% data_points - coordinates of points extracted from the plot
%               used for plotting to check the clustering accuracy
% Visual Output: Ground truth plot - a plot of the graph with the nodes
%                                    colored according to community
function [G,v0,clusters,colors,data_points,numNodes] = graph_generate(choice)
    clusters = 0;
    if eq(choice,1)
        clusters = randi([15,20],1);
        memVectors = zeros(1,clusters+1);
        for i=1:clusters
            memVectors(:,i+1) = memVectors(:,i) + randi([20,100],1);
        end
        [A,v0] = GGPlantedPartition(memVectors,0.9,0.1,0);  
        numNodes = memVectors(end);
        rand_perm=randperm(numNodes);   
        A=A(rand_perm,rand_perm);
        v0=v0(rand_perm);
    elseif eq(choice,2)
        clusters = 4;
        int_half_edges = 16;
        ext_half_edges = randi([2,16],1);
        %Plot the standard Girvan-Newman graph as per literature
        [A,v0]=GGGirvanNewman(32,4,16,ext_half_edges,0);
        fprintf('Number of internal half edges: %d\n',int_half_edges);
        fprintf('Number of external half edges: %d\n',ext_half_edges);
        numNodes = 128;
        rand_perm=randperm(numNodes);   
        A=A(rand_perm,rand_perm);
        v0=v0(rand_perm);
    elseif eq(choice,3)
        %Load Zachary karate club dataset
        clusters = 2;
        numNodes = 34;
        websave karate2.mat https://blogs.mathworks.com/images/loren/2015/karate.mat;
        load karate2.mat
        G = graph;
        for i=1:78
            G = addedge(G,edges(i,1),edges(i,2));
        end
        A = full(adjacency(G,'weighted'));
        v0 = [1 1 1 1 1 1 1 1 2 2 1 1 1 1 2 2 1 1 2 1 2 1 2 2 2 2 2 2 2 2 2 2 2 2];
    end
    fprintf('Number of clusters: %d\n',clusters);
    G = graph(A);
    colors1=colormap;
    colors=zeros(numNodes,3);
    for i=1:clusters
        colors(i,:)=colors1(ceil(length(colors1)*i/clusters),:);
    end
    figure;
    plotg = plot(G);
    title('Generated Graph')
    for i=1:numNodes
        highlight(plotg,i,'NodeColor',colors(v0(i),:),'MarkerSize',7);
    end
    x = plotg.XData;
    y = plotg.YData;
    data_points = [x(:), y(:)];
end    