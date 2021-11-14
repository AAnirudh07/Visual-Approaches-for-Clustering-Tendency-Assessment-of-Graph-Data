function [A,V0]=GGPlantedPartition(NN,pi,pe,Diag)
K=length(NN)-1;
N=NN(K+1);

A0=eye(N);
for k=1:K
    N1=NN(k)+1;
    N2=NN(k+1);
    A0(N1:N2,N1:N2)=1;
	N0=N2-N1;
	MiMax(k)=N0*(N0-1)/2;
end

A=eye(N);
for n1=1:N
    for n2=n1+1:N
        if A0(n1,n2)==1 & rand(1)<pi; A(n1,n2)=1; A(n2,n1)=1; end
        if A0(n1,n2)==0 & rand(1)<pe; A(n1,n2)=1; A(n2,n1)=1; end
    end
end
%A=A-eye(N);

i=1;
for k=1:K
	V0(NN(k)+1:NN(k+1),1)=k;
	MI(k,1)=sum(sum(A(NN(k)+1:NN(k+1),NN(k)+1:NN(k+1))))/2;
	MT(k,1)=sum(sum(A(NN(k)+1:NN(k+1),:)))/2;
	ME(k,1)=MT(k,1)-MI(k,1);
	aa(k,1)=ME(k)/MI(k);
	bb(k,1)=MI(k)/MiMax(k);
end

if Diag~=0
	for n=1:N; A(n,n)=1; end
else	
	for n=1:N; A(n,n)=0; end
end
