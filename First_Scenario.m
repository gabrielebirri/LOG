%% First Scenario

clear
clc

% Starting Orbit

a_i = 24400.00;
e_i = 0.728300;
inc_i = 0.104700;
RAAN_i = 1.136000;
w_i = 3.107000;
theta_i = 2.371000;
mu = 398600;

th0 = 0;
thf = 2*pi;
dth = 0.01;
% [rr_i,vv_i] = par2car(a_i,e_i,inc_i,RAAN_i,w_i,theta_i,mu);
plotOrbit (a_i,e_i,inc_i,RAAN_i,w_i,th0,thf,dth,mu);

%% Final Orbit

rx_f = -17874.100000;
vx_f = 2.779000;
vy_f = -4.117000;
vz_f = -1.761000;
rr = [rx_f,0,0];
vv = [vx_f,vy_f,vz_f];
[a_f,e_f,inc_f,RAAN_F,w_f,theta_f] = car2par(rr,vv,mu);
plotOrbit (a_i,e_i,inc_i,RAAN_i,w_i,theta_i,th0,dth,mu);
