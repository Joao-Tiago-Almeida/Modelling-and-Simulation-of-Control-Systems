%%  clear workspace and close all figures
clear; close all;
clc; 

s = set_system5();
sig = set_signal();

%%  Question 5 - Schematic system whit multiple blocks
c = set_controller(5);  % set c.schematic = 5 - multiple blocks
sig.y=sim('metron','StopTime', '5');

plotYY(sig.y,'Response to Initial Condition -  multiple blocks');
plotSS(sig.y,'State Space to Initial Condition -  multiple blocks');

%%  Question 6 - Schematic system state-system block
c = set_controller();   % set c.schematic = 6 - SS block
sig.y=sim('metron','StopTime', '5');

plotYY(sig.y,'Response to Initial Condition -  State-Space block');
plotSS(sig.y,'State Space -  State-Space block');

%%  Question 7 - Try system response for differents values of beta={0,1}

s = friction(0,s);
sig.y=sim('metron','StopTime', '5');
plotYY(sig.y,'Response to Initial Condition -  $\beta$ = 0 Nm/rad');
plotSS(sig.y,'State Space $\dot{\theta}(\theta)$ -  $\beta$ = 0 Nm/rad');
quiverSS(s.sys.A,sig.y);

s = friction(1,s);
sig.y=sim('metron','StopTime', '5');
plotYY(sig.y,'Response to Initial Condition -  $\beta$ = 1 Nm/rad');
plotSS(sig.y,'State Space $\dot{\theta}(\theta)$ -  $\beta$ = 1 Nm/rad');
quiverSS(s.sys.A,sig.y);

%%  SS for new initial condition and beta variable
%
% explain variables relation, it is easier if we analyse the no friction
% situation

s = friction(0,s);

s.x0 =[0;pi];
l1 = ['$(x_1,x_2)$ =' mat2str(s.x0,3)];   % legend
sig.y=sim('metron','StopTime', '5');
f = plotSS(sig.y,'State Space $\dot{\theta}(\theta)$ -  $\beta$ = 0.1 Nm/rad');

s.x0 =[pi/8;-pi];
l2 = ['$(x_1,x_2)$ =' mat2str(s.x0,3)];   % legend
sig.y=sim('metron','StopTime', '5');
plotSS(sig.y);

s.x0 =[-pi/4;0];
l3 = ['$(x_1,x_2)$ =' mat2str(s.x0,3)];   % legend
sig.y=sim('metron','StopTime', '5');
plotSS(sig.y);

s.x0 =[-pi/4;pi];
l4 = ['$(x_1,x_2)$ =' mat2str(s.x0,3)];   % legend
sig.y=sim('metron','StopTime', '5');
plotSS(sig.y);

fLegend({l1 l2 l3 l4},'outside');
quiverSS(s.sys.A, f);

%% eigenvalues and eigenvectors for fifferents for beta=1;

s = friction(1,s); 

[V,D] = eig(s.sys.A, 'vector');

%% Question 8 - rectilinear trajectory for choosen initial conditions
%
% As a result of both eigenvalues are negative the axes implode with a 
% rectilinear trajectory

s.x0 = V(:,1); %    eigenvector 1
l1 = ['$(x_1,x_2)$ =' mat2str(s.x0,3)];   % legend
sig.y=sim('metron','StopTime', '5');
f = plotSS(sig.y,'State Space $\dot{\theta}(\theta)$ -  $\beta$ = 0.1 Nm/rad');

s.x0 = V(:,2); %    eigenvector 2
l2 = ['$(x_1,x_2)$ =' mat2str(s.x0,3)];   % legend
sig.y=sim('metron','StopTime', '5');
plotSS(sig.y);

fLegend({l1 l2},'outside');
quiverSS(s.sys.A, f);

%% Question 9 - find mass and length values for multiples BPM

bpm_w = [50 150];

[l_ls,m] = fromBPM(bpm_w); % get length and mass for each bpm wanted

c.schematic = 6;

s = set_system9(l_ls(1),m);
sig.y=sim('metron','StopTime','15');    % quarter of a minute
bpm_c = getBPM(sig.y,s,'Linear System -  BPM = ');

s = set_system9(l_ls(2),m);
sig.y=sim('metron','StopTime','15');    % quarter of a minute
bpm_c = getBPM(sig.y,s,'Linear System -  BPM = ');

%% Question 10 - nonlinear system

c.schematic = 10;

s = set_system9(l_ls(1),m);
sig.y=sim('metron','StopTime','15');    % quarter of a minute
bpm_c_1 = getBPM(sig.y,s,'NonLinear System -  BPM = ');

s = set_system9(l_ls(2),m);
sig.y=sim('metron','StopTime','15');    % quarter of a minute
bpm_c_2 = getBPM(sig.y,s,'NonLinear System -  BPM = ');

%% new values for l

l_nls = lgetNLS(bpm_w,l_ls,s,c);
% Due to a lower length, nonlinear system's frequency is higher

c.schematic = 10;

s = set_system9(l_nls(1),m);
sig.y=sim('metron','StopTime','15');    % quarter of a minute
bpm_c_1 = getBPM(sig.y,s,'NonLinear System -  BPM = ');

s = set_system9(l_nls(2),m);
sig.y=sim('metron','StopTime','15');    % quarter of a minute
bpm_c_2 = getBPM(sig.y,s,'NonLinear System -  BPM = ');


%% Question 11 - External torque in a nonlinear system

c.schematic = 11;

s = set_system9(l_nls(1),m);
sig.y=sim('metron','StopTime','30');    % quarter of a minute
plotYY(sig.y,'Torque (impulses) $|\theta|$ \textless 1 rad');

s = set_system9(l_nls(2),m);
sig.y=sim('metron','StopTime','30');    % quarter of a minute
plotYY(sig.y,'Torque (impulses) $|\theta|$ \textless 1 rad');

%% EZ 4 DEBUG, CUZ IT'S THE LAST LINE
debug = 0;

