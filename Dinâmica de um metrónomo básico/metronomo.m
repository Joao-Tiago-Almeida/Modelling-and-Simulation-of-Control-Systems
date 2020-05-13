%%  clear workspace and close all figures
clear; close all;
clc; 

s = set_system5();

%% SIMULINK
metron;

%%  Question 5 - Schematic system whit multiple blocks
c = set_controller(1);  % set c.schematic = 1 - multiple blocks
y=sim('metron','StopTime', '5');

plotYY(y,'Response to Initial Condition -  multiple blocks');
plotSS(y,'State Space to Initial Condition -  multiple blocks');

%%  Question 6 - Schematic system state-system block
c = set_controller();   % set c.schematic = 2 - SS block
y=sim('metron','StopTime', '5');

plotYY(y,'Response to Initial Condition -  State-Space block');
plotSS(y,'State Space -  State-Space block');

%%  Question 7 - Try system response for differents values of beta={0,1}

s = friction(0,s);
y=sim('metron','StopTime', '5');
plotYY(y,'Response to Initial Condition -  $\beta$ = 0 Nm/rad');
plotSS(y,'State Space $\dot{\theta}(\theta)$ -  $\beta$ = 0 Nm/rad');
quiverSS(s.sys.A,y);

s = friction(1,s);
y=sim('metron','StopTime', '5');
plotYY(y,'Response to Initial Condition -  $\beta$ = 1 Nm/rad');
plotSS(y,'State Space $\dot{\theta}(\theta)$ -  $\beta$ = 1 Nm/rad');
quiverSS(s.sys.A,y);

%%  SS for new initial condition and beta variable
%
% explain variables relation, it is easier if we analyse the no friction
% situation

s = friction(0,s);

s.x0 =[0;pi];
l1 = ['$(x_1,x_2)$ =' mat2str(s.x0,3)];   % legend
y=sim('metron','StopTime', '5');
f = plotSS(y,'State Space $\dot{\theta}(\theta)$ -  $\beta$ = 0.1 Nm/rad');

s.x0 =[pi/8;-pi];
l2 = ['$(x_1,x_2)$ =' mat2str(s.x0,3)];   % legend
y=sim('metron','StopTime', '5');
plotSS(y);

s.x0 =[-pi/4;0];
l3 = ['$(x_1,x_2)$ =' mat2str(s.x0,3)];   % legend
y=sim('metron','StopTime', '5');
plotSS(y);

s.x0 =[-pi/4;pi];
l4 = ['$(x_1,x_2)$ =' mat2str(s.x0,3)];   % legend
y=sim('metron','StopTime', '5');
plotSS(y);

fLegend({l1 l2 l3 l4},'bestoutside');
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
y=sim('metron','StopTime', '5');
f = plotSS(y,'State Space $\dot{\theta}(\theta)$ -  $\beta$ = 0.1 Nm/rad');

s.x0 = V(:,2); %    eigenvector 2
l2 = ['$(x_1,x_2)$ =' mat2str(s.x0,3)];   % legend
y=sim('metron','StopTime', '5');
plotSS(y);

fLegend({l1 l2},'bestoutside');
quiverSS(s.sys.A, f);

%% Question 9 - find mass and length values for multiples BPM

bpm_w = [52 142]; % Adagio[55-65] Vivace[140-159]

t = {'Variation of the frequency of oscillation with the','distance from the mass to the center and its mass.'};
[l_ls,m] = fromBPM(bpm_w,t); % get length and mass for each bpm wanted

c.schematic = 2;
c.torque = 0;

s = set_system9(l_ls(1),m);
y=sim('metron','StopTime','15');    % quarter of a minute
getBPM(y,s,'Linear System -  BPM = ','theoretical analysis');

s = set_system9(l_ls(2),m);
y=sim('metron','StopTime','15');    % quarter of a minute
getBPM(y,s,'Linear System -  BPM = ','theoretical analysis');

%% Question 10 - nonlinear system

c.schematic = 3;

s = set_system9(l_ls(1),m);
y=sim('metron','StopTime','15');    % quarter of a minute
getBPM(y,s,'NonLinear System -  BPM = ','theoretical analysis');

s = set_system9(l_ls(2),m);
y=sim('metron','StopTime','15');    % quarter of a minute
getBPM(y,s,'NonLinear System -  BPM = ','theoretical analysis');

%% new values for l

c.schematic = 3;

l_nls = lgetNLS(bpm_w,l_ls,s,c);
% Due to lower length, nonlinear system's frequency is higher

s = set_system9(l_nls(1),m);
y=sim('metron','StopTime','15');    % quarter of a minute
getBPM(y,s,'NonLinear System -  BPM = ');

s = set_system9(l_nls(2),m);
y=sim('metron','StopTime','15');    % quarter of a minute
getBPM(y,s,'NonLinear System -  BPM = ');


%% Question 11 - External torque in a nonlinear system

c.schematic = 3;
c.torque = 1;
% Due to external torque aplication, velocity in theta arround 0 increases,
% so BPM will also increases

s = set_system9(l_nls(1),m);
y=sim('metron','StopTime','30');    % quarter of a minute
getBPM(y,s,'Torque (impulses) $|\theta|$ \textless 1 rad - BPM = ');

s = set_system9(l_nls(2),m);
y=sim('metron','StopTime','30');    % quarter of a minute
getBPM(y,s,'Torque (impulses) $|\theta|$ \textless 1 rad - BPM = ');

%% new values for l (show how the system change afect BPM) (NOT ASKED)

c.schematic = 3;
c.torque = 1;

l_nls = lgetNLS(bpm_w,l_ls,s,c);
% Due to lower length, nonlinear system's frequency is higher

s = set_system9(l_nls(1),m);
y=sim('metron','StopTime','15');    % quarter of a minute
getBPM(y,s,'NonLinear System -  BPM = ');

s = set_system9(l_nls(2),m);
y=sim('metron','StopTime','15');    % quarter of a minute
getBPM(y,s,'NonLinear System -  BPM = ');

%% Question 12 - bode diagram

multiBodes(l_ls,m,'Bode Diagram - Linear System');

%% Question 13 - 
s = set_system9(l_ls(1),m);
mass = get_m_fromSimulation(s,c);
disp(['[COMPUTED] mass: ' mat2str(round(mass,4)) ' Kg']);

s = set_system9(l_ls(2),m);
mass = get_m_fromSimulation(s,c);
disp(['[COMPUTED] mass: ' num2str(mass, '%.4f') ' Kg']);
%% EZ 4 DEBUG, CUZ IT'S THE LAST LINE
debug = 0;

%% Anexos - HTMLs
publishOptions.evalCode = false;    % does not evaluate the code
fLegend.html = publish('fLegend.m',publishOptions);
friction.html = publish('friction.m',publishOptions);
fromBPM.html = publish('fromBPM.m',publishOptions);
get_m_fromSimulation.html = publish('get_m_fromSimulation.m',publishOptions);
getBPM.html = publish('getBPM.m',publishOptions);
lgetNLS.html = publish('lgetNLS.m',publishOptions);
multiBodes.html = publish('multiBodes.m',publishOptions);
plotSS.html = publish('plotSS.m',publishOptions);
plotYY.html = publish('plotYY.m',publishOptions);
quiverSS.html = publish('quiverSS.m',publishOptions);
set_controller.html = publish('set_controller.m',publishOptions);
set_system5.html = publish('set_system5.m',publishOptions);
set_system9.html = publish('set_system9.m',publishOptions);
%%
% <fLegend.html fLegend>    Formats legend.
%
% <friction.html friction>  Changes friction.
%
% <fromBPM.html fromBPM>    Computes fixed m and l1,2 from specific BPM.
%
% <get_m_fromSimulation.html get_m_fromSimulation>  Computes m used suring
% simulation.
%
% <getBPM.html getBPM>  Computes simlation's BPM.
%
% <lgetNLS.html lgetNLS>    Calculates the length of the nonlinear system
% simulation response from a specific BPM.
%
% <multiBodes.html multiBodes>  Overlaps multiple goat diagrams.
%
% <plotSS.html plotSS>  Plots Steady-Space: y2(y1).
%
% <plotYY.html plotYY>  Plots Time Response: y1(t) and y2(t).
%
% <quiverSS.html quiverSS>  Draws a velocity plot.
%
% <set_controller.html set_controller>  Declares controller struct.
%
% <set_system5.html set_system5>    Declares system struct with question 5
% values.
%
% <set_system9.html set_system9>	Declares system struct with question 9
% values.

%%
close all
close_system