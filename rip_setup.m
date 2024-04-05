% Pendulum Initialization

% Motor 
kt=0.042;% torque constant
km=0.042;% motor back-emf constant
R=8.4;% terminal resistance
L=0.85e-3;% terminal inductance

% Inverted Pendulum Parameters
base_size=7; % length of pendulum base cube
% Rotary arm parameters
rod_rad=1;% rotary arm radius
rod_length=8.5;% rotary arm length
rod_mass=0.095;% rotary arm mass
% Pendulum parameters
p_rad=1;% pendulum radius
p_length=12.9;% pendulum length
p_mass=0.024;% pendulum mass
rt1=base_size/2;
rt2=rod_length-0.4;
rt4=p_length/2;
D_r=0.0015/2;
D_p=0.0005/2;

alpha_0=192;

% State Space Initialization

% Inverted Pendulum Parameters
% Rotary arm parameters
L_r=rod_length/100;%convert cm to m
r_r=rod_rad/100;%convert cm to m
m_r=rod_mass;
J_r=(1/4)*m_r*r_r^2+(1/3)*m_r*L_r^2;% rotary arm moment of inertia
% Pendulum parameters
L_p=p_length/100;
m_p=p_mass;
r_p=p_rad/100;
J_p=(1/4)*m_p*r_p^2+(1/3)*m_p*L_p^2;% pendulum moment of inertia

M=[m_p*L_r^2+J_r 0.5*m_p*L_p*L_r;
   -0.5*m_p*L_p*L_r J_p+0.25*m_p*L_p^2];
G=[D_r+kt*km/R 0;0 D_p];
K=[0 0;0 -0.5*m_p*L_p*9.8];
F=[kt/R;0];

%Linearized System Matrices
A=[zeros(2) eye(2);-inv(M)*K -inv(M)*G];
B=[0;0;inv(M)*F];
C=[1 0 0 0;
   0 1 0 0];
D=[0;0];

% Observer based state-feedback controller
%Feedback controller design
K_c=place(A,B,[-8 -5 -6 -1]);
%Observer design
L_o=place(A',C',5*[-8 -5 -6 -1])';