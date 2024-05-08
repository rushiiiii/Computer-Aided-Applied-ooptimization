clc
clear
close all
format long g
%% Problem settings
[P,S,F,SC] = Data;
lb = [2 2 2 2 2 2 18000 18000 18000 18000];
ub = [10 10 10 10 10 10 1800000 1800000 1800000 1800000];
prob = @OBJ; % Fitness function
Contracts= 50;
%% Algorithm parameters
Np = 100; % Population Size
T = 100; % No. of iterations
B= 270000; % Ambiance and Marketing budget
TotProfit=zeros(Contracts);
for j=1:Contracts
rng(1,'twister') % Controlling the random number generator used by rand, randi
[bestsol,bestfitness,BestFitIter,~,~] = TLBO(prob,lb,ub,Np,T,B)
[f,profit]=OBJ(bestsol,ub,lb,B)
TotProfit(j)=profit;
Stat(1,1) = min(bestfitness); % Determining the best fitness function value
Stat(1,2) = max(bestfitness); % Determining the worst fitness function value
Stat(1,3) = mean(bestfitness); % Determining the mean fitness function value
Stat(1,4) = median(bestfitness); % Determining the median fitness function value
Stat(1,5) = std(bestfitness); % Determining the standard deviation
B=.2*max(360000,profit)
plot(TotProfit,'LineWidth',2)
xlabel('Contracts')
ylabel('Profit')
end