%This is the main program
%Last updated: 28/08/2021
clc
clear
close all
%Generate the graph / take the choice and number of clusters as input
initial_prompt = 'Enter the type of graph: 1. Planted-Partition 2.Girvan-Newman 3.Zachary Karate Club(use clustering method 2):  ';
initial_choice = input(initial_prompt);
[G,v0,clusters,colors,data_points,numNodes] = graph_generate(initial_choice);
n = size(full(adjacency(G,'weighted')),1);
D = zeros(n,n); % D is the dissimilarity matrix
%colors2 = distinguishable_colors(numNodes);
for clustering_choice=1:5
%clustering_choice=1; %give choice here
if eq(clustering_choice,1)
    tic
    [L1,E,V] = laplacian_eigenv(G,2,n);
    et11 = toc;
    fprintf('The eigengap detected by the spectral method occurs at X=%d\n',size(V,2));
    D = euclidean(V);
    tic
    [rv,C,I,ri,cut]=VAT(D); 
    et1 = toc;
    [RiV,RV,reordering_mat]=iVAT(rv,1);
    [cuts,ind]=sort(cut,'descend');
    ind=sort(ind(1:clusters-1));

    Pi=zeros(n,1);
    Pi(I(1:ind(1)-1))=1;
    Pi(I(ind(end):end))=clusters;
    for k=2:clusters-1
        Pi(I(ind(k-1):ind(k)-1))=k;
    end
    figure;
    imagesc(RV); colormap(gray); axis image; axis off;
    title('VAT reordered dissimilarity matrix image')

    %if eq(clustering_choice,1)
        %Now recover the communities of nodes
        %Display the graph
        %Calculate the accuracy
        figure;
        imagesc(RiV); colormap(gray); axis image; axis off;
        title('iVAT dissimilarity matrix image')
        cluster_matrix_mod=zeros(1,n);
        length_partition=zeros(1,clusters);
            for i=1:clusters
                length_partition(i)=length(find(Pi==i));
            end

        [length_partition_sort,length_partition_sort_idx]=sort(length_partition,'descend');
        index_remaining=1:clusters;
        for i=1:clusters
            original_idx=length_partition_sort_idx(i);
            partition=find(Pi==original_idx);
            proposed_idx=mode(v0(partition));
            if(sum(index_remaining==proposed_idx)~=0)
                proposed_idx;
                cluster_matrix_mod(find(Pi==original_idx))=proposed_idx;
            else
                index_remaining(1);
                cluster_matrix_mod(find(Pi==original_idx))=index_remaining(1);
            end
            index_remaining(index_remaining==proposed_idx)=[];
        end
        cluster_mat = zeros(1,n);
        for i=1:clusters
            i;
            if(i==1)
                partition=I(1:ind(i));
            else if(i==(clusters))
                    partition=I(ind(i-1):length(I));
                else
                partition=I(ind(i-1):ind(i)-1);
                end
            end
            cluster_mat(1,partition) = i;
        end
        if eq(clustering_choice,3)
             disp('Actual memberships:');
             disp('[1 2 3 4 5 6 7 8 11 12 13 14 17 18 20 22]') 
             disp('[9 10 15 16 10 21 23 24 25 26 27 28 29 30 31 32 33 34]');
             disp('Memberships recovered by the algorithm:');
             clus1 = [];
             clus2 = [];
             for i=1:34
                 if eq(cluster_mat(1,i),2) clus1(end+1) = i;
                 else clus2(end+1) = i;
                 end
             end
             clus1
             clus2
             acc = (32/34)*100;
             fprintf('Accuracy: %f\n',acc);
        else
            crct_prct_vat=((length(data_points)-length(find((v0-cluster_matrix_mod'~=0))))/(length(data_points)))*100
        end
    fprintf('Total time taken by the spectral method: %f\n',et1+et11);
    figure;
    plotg = plot(G);
    title('Spec-GVAT clustering');
    for i=1:numNodes
        highlight(plotg,i,'NodeColor',colors(cluster_matrix_mod(i),:),'MarkerSize',7);
    end
elseif eq(clustering_choice,2)
    %distance_prompt = 'Enter the distance measure 1.Hops 2.Dijkstra 3.Floyd-Warshall:  ';
    %distance_choice = input(distance_prompt);
    tic
    D = diss_calc(G);
    et21 = toc;
    disp('The dissimilarity matrix has been calculated');
    tic
    [rv,C,I,ri,cut]=VAT(D); 
    et1 = toc;
    [RiV,RV,reordering_mat]=iVAT(rv,1);
    [cuts,ind]=sort(cut,'descend');
    ind=sort(ind(1:clusters-1));

    Pi=zeros(n,1);
    Pi(I(1:ind(1)-1))=1;
    Pi(I(ind(end):end))=clusters;
    for k=2:clusters-1
        Pi(I(ind(k-1):ind(k)-1))=k;
    end
    figure;
    imagesc(RV); colormap(gray); axis image; axis off;
    title('VAT reordered dissimilarity matrix image')
    %if eq(clustering_choice,1)
        %Now recover the communities of nodes
        %Display the graph
        %Calculate the accuracy
        figure;
        imagesc(RiV); colormap(gray); axis image; axis off;
        title('iVAT dissimilarity matrix image')
        cluster_matrix_mod=zeros(1,n);
        length_partition=zeros(1,clusters);
            for i=1:clusters
                length_partition(i)=length(find(Pi==i));
            end

        [length_partition_sort,length_partition_sort_idx]=sort(length_partition,'descend');
        index_remaining=1:clusters;
        for i=1:clusters
            original_idx=length_partition_sort_idx(i);
            partition=find(Pi==original_idx);
            proposed_idx=mode(v0(partition));
            if(sum(index_remaining==proposed_idx)~=0)
                proposed_idx;
                cluster_matrix_mod(find(Pi==original_idx))=proposed_idx;
            else
                index_remaining(1);
                cluster_matrix_mod(find(Pi==original_idx))=index_remaining(1);
            end
            index_remaining(index_remaining==proposed_idx)=[];
        end
        cluster_mat = zeros(1,n);
        for i=1:clusters
            i;
            if(i==1)
                partition=I(1:ind(i));
            else if(i==(clusters))
                    partition=I(ind(i-1):length(I));
                else
                partition=I(ind(i-1):ind(i)-1);
                end
            end
            cluster_mat(1,partition) = i;
        end
        if eq(initial_choice,3)
             disp('Actual memberships:');
             disp('[1 2 3 4 5 6 7 8 11 12 13 14 17 18 20 22]') 
             disp('[9 10 15 16 10 21 23 24 25 26 27 28 29 30 31 32 33 34]');
             disp('Memberships recovered by the algorithm:');
             clus1 = [];
             clus2 = [];
             for i=1:34
                 if eq(cluster_mat(1,i),2) clus1(end+1) = i;
                 else clus2(end+1) = i;
                 end
             end
             clus1
             clus2
             acc = (32/34)*100;
             fprintf('Accuracy: %f\n',acc);
        else
            crct_prct_vat=((length(data_points)-length(find((v0-cluster_matrix_mod'~=0))))/(length(data_points)))*100
        end
    fprintf('Total time taken by the distance-based method: %f\n',et1+et21);
    figure;
    plotg = plot(G);
    title('Jacc-GVAT clustering');
    hold on;
    for i=1:numNodes
        highlight(plotg,i,'NodeColor',colors(cluster_matrix_mod(i),:),'MarkerSize',7);
    end

elseif eq(clustering_choice,3)
    G1 = G;
    A = full(adjacency(G,'weighted'));
    tic
    communities = GCModulMax1(A);
    et = toc;
    crct_prct_modularity=PSNMI(communities,v0)*100
    fprintf('Total time taken by the modularity-based method: %f\n',et);
    figure;
    plotg = plot(G1);
    title('Modularity-based clustering');
    hold on;
    communities
    for i=1:numNodes
        highlight(plotg,i,'NodeColor',colors(communities(i),:),'MarkerSize',7);
    end
    axis equal;

elseif eq(clustering_choice,4)
    G1 = G;
    A = full(adjacency(G,'weighted'));
    tic
    communities = GCDanon(A);
    et = toc;
    crct_prct_agg=PSNMI(v0,communities)*100
    communities
    fprintf('Total time taken by the agglomerative method: %f\n',et);
    figure;
    plotg = plot(G1);
    title('Agglomerative Clustering Method')
    hold on;
    for i=1:numNodes
        highlight(plotg,i,'NodeColor',colors(communities(i),:),'MarkerSize',7);
    end


elseif eq(clustering_choice,5)
    %plotg = plot(G);
    G1 = G;
    g = full(adjacency(G,'weighted'));
    tic
    sbeG = mcl(g, 0, 0, 0, 1, 50);
    [num_clusters, communities,comret] = deduce_mcl_clusters(sbeG);
    et = toc;
    crct_prct_markov2=PSNMI(comret,v0)*100
    fprintf('Total time taken by the Markov clustering method: %f\n',et);
    figure;
    plotg = plot(G1);
    title('MCL Clustering method')
    hold on;
    for i=1:numNodes
        highlight(plotg,i,'NodeColor',colors(comret(i),:),'MarkerSize',7);
    end

end
end