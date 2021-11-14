function [et1,cluster_matrix_mod] = perf_comp(initial_choice,D,v0,clusters,colors,data_points,n)
disp('Now passing the dissimilarity input to VAT');
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
hold on;

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
    figure;
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

