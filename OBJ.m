function [f,profit] = OBJ(x,ub,lb,B)
% number of higher, upper middle, lower middle and lower class population
P=[200000 270000 270000 180000]';
% salary of each type of contractor/architect
S=[300000 200000 135000 90000 72000 45000]';
% avg extra requirements from each type of occupant at each house
F=[1000 400 300 150]';
% Working capacity
WC=[1400 1200 900 2700 1800 900]';
EmpCap = 35; % Maximum number of contractors/architects to be occupied
SalMax= 7000000; % Available Budget for Salary of contractors/architects
TotalArch=x(1)+x(2)+x(3); % Total number of architects in architect chosen scheme
TotalContractor=x(4)+x(5)+x(6); % Total number of contractors in contractor chosen scheme
LocationCost1=x(7); % Amount allocated for location in architect chosen scheme
LocationCost2=x(8); % Amount allocated for location in contractor chosen scheme
MarketingCost1=x(9); % Amount allocated for marketing in architect chosen scheme
MarketingCost2=x(10); % Amount allocated for marketing in contractor chosen scheme
%% Evaluation of probability of classes of occupants booking houses
PR=[0 0 0 0]';
PR(1)= 0.5*(x(1)/TotalArch)+0.3*(x(2)/TotalArch)+0.2*(x(3)/TotalArch);
PR(2)= -0.1*(x(1)/TotalArch)+0.5*(x(2)/TotalArch)+0.6*(x(3)/TotalArch);
PR(3)= 0.2*(x(4)/TotalContractor)+0.5*(x(5)/TotalContractor)+0.3*(x(6)/TotalContractor);
PR(4)= 0.1*(x(4)/TotalContractor)+0.2*(x(5)/TotalContractor)+0.7*(x(6)/TotalContractor);
%% Evaluation of New population based on the nature of investment in Location and Marketing
NewPop=P; % initially new population equals initial population pool
% Following factors determines the relative amounts allocated to
% Location nad Marketing in Architect and Contractor chosen scheme
L_factor(1)=min(LocationCost1/B,1)*B/ub(7);
L_factor(2)=min(LocationCost2/B,1)*B/ub(8);
M_factor(1)=min(MarketingCost1/B,1)*B/ub(9);
M_factor(2)=min(MarketingCost2/B,1)*B/ub(10);
% Following factors account for the loss of occupants due to lack of
% investing in Location and Marketing in Architect and Contractor
% chosen schemes
MLoss(1)=0.3*(1-M_factor(1))*P(1);
MLoss(2)=0.6*(1-M_factor(1))*P(2);
MLoss(3)=0.5*(1-M_factor(2))*P(3);
MLoss(4)=0.7*(1-M_factor(2))*P(4);
L_loss(1)=0.7*(1-L_factor(1))*P(1);
L_loss(2)=0.4*(1-L_factor(1))*P(2);
L_loss(3)=0.5*(1-L_factor(2))*P(3);
L_loss(4)=0.3*(1-L_factor(2))*P(4);
NewPop(1)=P(1)-MLoss(1)-L_loss(1);
NewPop(2)=P(2)-MLoss(2)-L_loss(2);
NewPop(3)=P(3)-MLoss(3)-L_loss(3);
NewPop(4)=P(4)-MLoss(4)-L_loss(4);
%% Revenue Calculations
% Calculating working capacity of the employees
ContractorWorkCap=0; % Working capacity of employees in contractor scheme
ArchWorkCap=0; % Working capacity of chefs in fine architect scheme
for j=1:length(WC)
if j>=4
ContractorWorkCap = ContractorWorkCap + WC(j)*x(j);
else
ArchWorkCap = ArchWorkCap + WC(j)*x(j);
end
end
% Calculating revenue generated
Revenue=0;
WorkingCap=ArchWorkCap;
for j = 1: length(F)
if j>=3
WorkingCap=ContractorWorkCap;
end
Revenue = Revenue + F(j)*(min(NewPop(j),WorkingCap))*PR(j);
end
%% Cost Calculations
% Chef salary calculation
EmpSalary=0;
for j = 1: length(S)
EmpSalary = EmpSalary + S(j)*x(j);
end
%% Penalties and Constraints
% Employee Salary constraint
PenaltySalary = 0; % penalty due to exceeding employee salary budget
if EmpSalary > SalMax
PenaltySalary = (100*(EmpSalary - SalMax))^2;
end
% Total Employee Count constraint
TotalEmp = TotalArch + TotalContractor;
PenaltyEmp = 0; % penalty due to exceeding maximum employee count
if TotalEmp > EmpCap
PenaltyEmp = (100*(TotalEmp - EmpCap))^2;
end
% Location and marketing budget constraint
PenaltyExtraBudget = 0; % penalty due to exceeding Location and marketing budget
if x(7)+x(8)+x(9)+x(10) > B
PenaltyExtraBudget = (x(7)+x(8)+x(9)+x(10) - B)^2;
end
% Number of senior employee constraint in architect
PenaltySenior1 = 0; % penalty due to violating senior worker constraint in architect scheme
if 2*x(1) < x(2)+x(3)
PenaltySenior1 = (10000*(2*x(1) - (x(2)+x(3))))^2;
end
% Number of senior employee constraint in contractor
PenaltySenior2 = 0; % penalty due to violating senior chef constraint in contractor scheme
if 2*x(4) < x(5)+x(6)
PenaltySenior2 = (100*(2*x(4) - x(5)+x(6)))^2;
end
%% Profit and Fitness Calculations
profit = Revenue - (EmpSalary + LocationCost1 + LocationCost2 + MarketingCost1 + MarketingCost2); % Profit
f = -profit + 10^15*(PenaltyEmp + PenaltySenior1 + PenaltySenior2 + PenaltyExtraBudget + PenaltySalary); % Fitness value2