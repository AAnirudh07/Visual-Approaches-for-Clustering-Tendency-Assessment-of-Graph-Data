function [A,V0]=GGGirvanNewman(N1,K,zi,ze,Diag)
pi=zi/(N1-1);
pe=ze/(N1*(K-1));
NN=[0];
for k=1:K
     NN(1,k+1)=k*N1;
end
[A,V0]=GGPlantedPartition(NN,pi,pe,Diag);
