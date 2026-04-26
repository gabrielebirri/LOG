% Standard maneuver for first scenario orbital change
% ----------------------------------------------------------------------
% This script implements the standard procedure for an orbital change
% maneuver

% Final result of the script will consist of the total deltaV of the 
% maneuver and the total time necessary
% ----------------------------------------------------------------------

clear
clc

% Starting Orbit
a_i = 24400.00;         %[km]
e_i = 0.728300;
inc_i = 0.104700;       %[rad]
RAAN_i = 1.136000;      %[rad]
w_i = 3.107000;         %[rad]
theta_i = 2.371000;     %[rad]
mu = 398600;            %[km^3/s^2]

[rr_i,vv_i] = par2car(a_i,e_i,inc_i,RAAN_i,w_i,theta_i,mu);

% Final Orbit
rx_f = -17874.100000;   %[km]
ry_f = -12975.567000;   %[km]
rz_f = 2124.941500;     %[km]
vx_f = 2.779000;        %[km/s]
vy_f = -4.117000;       %[km/s]
vz_f = -1.761000;       %[km/s]

rr = [rx_f,ry_f,rz_f];
vv = [vx_f,vy_f,vz_f];
[a_f,e_f,inc_f,RAAN_f,w_f,theta_f] = car2par(rr,vv,mu);


%% Change of the orbital plane of the initial orbit
[deltaV_cp, om_2, th_cp] = changeOrbitalPlane(a_i, e_i, inc_i, RAAN_i, w_i, inc_f, RAAN_f, mu);

% Time 1
delta_t_1 = TOF(a_i, e_i, theta_i, th_cp, mu);

%% Change of the pericenter argument
clc

[deltaV_cw, th_cw, th_cw1] = changePericenterArg(a_i, e_i, om_2, w_f, mu);


% We are choosing the true anomaly that minimizes delta t to get to the
% maneuver point for the bitangent transfer

% Time 2 and 3
delta_t_2 = TOF(a_i, e_i, th_cp, th_cw(1), mu);
delta_t_3 = TOF(a_i, e_i, th_cw1(1), 0, mu);

%% Bitangent transfer
clc
[deltaV_PA1, deltaV_PA2, delta_t_4] = bitangentTransfer(a_i, e_i, a_f, e_f, 'pa', mu);

% Time 5 (to get to the final anomaly)
delta_t_5 = TOF(a_f, e_f, pi, theta_f, mu);

%% Total deltaV and time

deltaV_tot = abs(deltaV_cp) + abs(deltaV_cw) + abs(deltaV_PA1) + abs(deltaV_PA2);
disp(deltaV_tot)

delta_t_tot = delta_t_1 + delta_t_2 + delta_t_3 + delta_t_4 + delta_t_5;
disp(delta_t_tot)

%% Plotting orbits
clc
th0 = 0;
thf = 2*pi;
dth = 0.01;

plotOrbit(a_i, e_i, inc_i, RAAN_i, w_i, th0, thf, dth, mu)
hold on
plotOrbit(a_f, e_f, inc_f, RAAN_f, w_f, th0, thf, dth, mu)