clc
clear
close all
initial_prompt = 'Enter the type of graph: 1. Planted-Partition 2.Girvan-Newman 3.Zachary Karate Club(use clustering method 2):  ';
initial_choice = input(initial_prompt);
[G,v0,clusters,colors,data_points,memVectors] = graph_generate(initial_choice);
nodes = size(full(adjacency(G,'weighted')),1);
nodes = nodes*nodes;
g = full(adjacency(G,'weighted'));
sbeG = mcl(g, 0, 0, 0, 0, 20);
[num_clusters, communities,comret] = deduce_mcl_clusters(sbeG);
num_clusters;
comret