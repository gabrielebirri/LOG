% Standard maneuver for the orbital change
% ----------------------------------------------------------------------
% This script implements the standard procedure for an orbital change
% maneuver

% Final result of the script will consist of the total deltaV of the 
% maneuver and the total time necessary

clear
clc
close all

% Starting Orbit
a_i = 24400.00;         %[km] semi-major axis
e_i = 0.728300;         %[-]  initial eccentricity
inc_i = 0.104700;       %[rad] initial inclination
RAAN_i = 1.136000;      %[rad] initial RAAN
w_i = 3.107000;         %[rad] initial pericenter anomaly
theta_i = 2.371000;     %[rad] initial true anomaly
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
delta_t_1 = TOF(a_i, e_i, theta_i, th_cp, mu); % TOF vuole come input la initial true anomaly

%% Change of the pericenter argument
[deltaV_cw, th_cw, th_cw1] = changePericenterArg(a_i, e_i, om_2, w_f, mu); % devo considerare l'orbita cambiata di piano 
delta_t_2 = TOF(a_i, e_i, th_cp, th_cw(2), mu);

% We are choosing the true anomaly that minimizes delta t to get to the
% maneuver point for the bitangent transfer
 

%% Pericentro Apocentro

[deltaV_PA1, deltaV_PA2, delta_t_4_PA] = bitangentTransfer(a_i, e_i, a_f, e_f, 'pa', mu);
delta_t_3_PA = TOF(a_i, e_i, th_cw1(1), 0, mu); % Attesa fino all'Apocentro iniziale
delta_t_5_PA = TOF(a_f, e_f, pi, theta_f, mu);    % Arrivo al Pericentro finale

% Transfer Orbit Parameters
r_p_t_PA = a_i * (1-e_i);
r_a_t_PA = a_f *(1+e_f);
a_t_PA = (r_a_t_PA+r_p_t_PA) / 2;
e_t_PA = abs(r_p_t_PA - r_a_t_PA) / (r_p_t_PA + r_a_t_PA);

% Total deltaV and time
deltaV_tot = abs(deltaV_cp) + abs(deltaV_cw) + abs(deltaV_PA1) + abs(deltaV_PA2);
delta_t_tot = delta_t_1+ delta_t_2 + delta_t_3_PA + delta_t_4_PA + delta_t_5_PA;

fprintf('\nRISULTATI TRASFERIMENTO: Pericentro-Apocentro (pa) \n');
fprintf('Costo Totale (Delta V) : %.4f km/s\n', deltaV_tot);
fprintf('Tempo Totale (Delta T) : %.2f secondi\n', delta_t_tot);
fprintf('Tempo in Ore           : %.2f ore\n', delta_t_tot / 3600);

 

%% APOCENTRO PERICENTRO
[deltaV_AP1, deltaV_AP2, delta_t_4_AP] = bitangentTransfer(a_i, e_i, a_f, e_f, 'ap', mu);
delta_t_3_AP= TOF(a_i, e_i, th_cw1(1), pi, mu);  % Attesa fino al Pericentro iniziale
delta_t_5_AP = TOF(a_f, e_f, 0, theta_f, mu);   % Arrivo all'Apocentro finale

% Transfer Orbit Parameters
r_p_t_AP = a_i * (1+e_i);
r_a_t_AP = a_f *(1-e_f);
a_t_AP = (r_a_t_AP+r_p_t_AP) / 2;
e_t_AP = abs(r_p_t_AP - r_a_t_AP) / (r_p_t_AP + r_a_t_AP);

% Total deltaV and time
deltaV_tot = abs(deltaV_cp) + abs(deltaV_cw) + abs(deltaV_AP1) + abs(deltaV_AP2);
delta_t_tot = delta_t_1 + delta_t_2 + delta_t_3_AP+ delta_t_4_AP + delta_t_5_AP;

fprintf('\nRISULTATI TRASFERIMENTO: Apocentro-Pericentro (ap) \n');
fprintf('Costo Totale (Delta V) : %.4f km/s\n', deltaV_tot);
fprintf('Tempo Totale (Delta T) : %.2f secondi\n', delta_t_tot);
fprintf('Tempo in Ore           : %.2f ore\n', delta_t_tot / 3600);



%% Pericentro Pericentro
[deltaV_PA1, deltaV_PA2, delta_t_4_PA] = bitangentTransfer(a_i, e_i, a_f, e_f, 'pp', mu);
delta_t_3_PA = TOF(a_i, e_i, th_cw1(1), 0, mu); % Attesa fino all'Apocentro iniziale
delta_t_5_PA = TOF(a_f, e_f, 0, theta_f, mu);    % Arrivo al Pericentro finale

% Transfer Orbit Parameters
r_p_t_PP = a_i * (1-e_i);
r_a_t_PP = a_f *(1-e_f);
a_t_PP = (r_a_t_PP+r_p_t_PP) / 2;
e_t_PP = abs(r_p_t_PP - r_a_t_PP) / (r_p_t_PP + r_a_t_PP);


% Total deltaV and time
deltaV_tot = abs(deltaV_cp) + abs(deltaV_cw) + abs(deltaV_PA1) + abs(deltaV_PA2);
delta_t_tot = delta_t_1+ delta_t_2 + delta_t_3_PA + delta_t_4_PA + delta_t_5_PA;

fprintf('\nRISULTATI TRASFERIMENTO: Pericentro-Apocentro (pa) \n');
fprintf('Costo Totale (Delta V) : %.4f km/s\n', deltaV_tot);
fprintf('Tempo Totale (Delta T) : %.2f secondi\n', delta_t_tot);
fprintf('Tempo in Ore           : %.2f ore\n', delta_t_tot / 3600);


%% Apocentro Apocentro
[deltaV_PA1, deltaV_PA2, delta_t_4_PA] = bitangentTransfer(a_i, e_i, a_f, e_f, 'aa', mu);
delta_t_3_PA = TOF(a_i, e_i, th_cw1(1), pi, mu); % Attesa fino all'Apocentro iniziale
delta_t_5_PA = TOF(a_f, e_f, pi, theta_f, mu);    % Arrivo al Pericentro finale

% Transfer Orbit Parameters
r_p_t_AA = a_i * (1+e_i);
r_a_t_AA = a_f *(1+e_f);
a_t_AA = (r_a_t_AA+r_p_t_AA) / 2;
e_t_AA = abs(r_p_t_AA - r_a_t_AA) / (r_p_t_AA+ r_a_t_AA);

% Total deltaV and time
deltaV_tot = abs(deltaV_cp) + abs(deltaV_cw) + abs(deltaV_PA1) + abs(deltaV_PA2);
delta_t_tot = delta_t_1+ delta_t_2 + delta_t_3_PA + delta_t_4_PA + delta_t_5_PA;

fprintf('\nRISULTATI TRASFERIMENTO: Pericentro-Apocentro (pa) \n');
fprintf('Costo Totale (Delta V) : %.4f km/s\n', deltaV_tot);
fprintf('Tempo Totale (Delta T) : %.2f secondi\n', delta_t_tot);
fprintf('Tempo in Ore           : %.2f ore\n', delta_t_tot / 3600);

%% Plotting orbits
th0 = 0;
thf = 2*pi;
dth = 0.01;


%% Change Plane 
figure('Color', 'k')
axes('Color', 'k', 'XColor', 'w', 'YColor', 'w', 'ZColor', 'w');
hold on; 
grid on; 
axis equal;

plotOrbit(a_i, e_i, inc_i, RAAN_i, w_i, th0, thf, dth, mu,'b')
hold on
plotOrbit(a_i, e_i, inc_f, RAAN_f, om_2, th0, thf, dth, mu,'g')
hold on
% PLOT EART
R_earth = 6378.1;       
[sx, sy, sz] = sphere(40);
% PLOT EART
surf(sx*R_earth, sy*R_earth, sz*R_earth,'FaceColor', [0, 0.4470, 0.7410],'EdgeColor', 'none', 'FaceAlpha', 0.8,'HandleVisibility', 'off');


%% Change Pericenter Arg

figure('Color', 'k')
axes('Color', 'k', 'XColor', 'w', 'YColor', 'w', 'ZColor', 'w');
hold on; 
grid on; 
axis equal;

plotOrbit(a_i, e_i, inc_f, RAAN_f, om_2, th0, thf, dth, mu,'g')
hold on
plotOrbit(a_i, e_i, inc_f, RAAN_f, w_f, th0, thf, dth, mu, 'y'); 
hold on
% PLOT EART
surf(sx*R_earth, sy*R_earth, sz*R_earth,'FaceColor', [0, 0.4470, 0.7410],'EdgeColor', 'none', 'FaceAlpha', 0.8,'HandleVisibility', 'off');

%% Transfer Conditions

figure('Color', 'k')
axes('Color', 'k', 'XColor', 'w', 'YColor', 'w', 'ZColor', 'w');
hold on; 
grid on; 
axis equal;

plotOrbit(a_i, e_i, inc_f, RAAN_f, w_f, th0, thf, dth, mu, 'y'); 
hold on
plotOrbit(a_f, e_f, inc_f, RAAN_f, w_f, th0, thf, dth, mu,'r');
hold on

% PLOT EART
surf(sx*R_earth, sy*R_earth, sz*R_earth,'FaceColor', [0, 0.4470, 0.7410],'EdgeColor', 'none', 'FaceAlpha', 0.8,'HandleVisibility', 'off');


%% Pericenter Apocenter Plot

figure('Name','Pericenter-Apocenter','Color', 'k')
axes('Color', 'k', 'XColor', 'w', 'YColor', 'w', 'ZColor', 'w');
hold on; 
grid on; 
axis equal;
title('Pericenter-Apocenter')

plotOrbit(a_i, e_i, inc_f, RAAN_f, w_f, th0, thf, dth, mu, 'y'); 
hold on
plotOrbit(a_f, e_f, inc_f, RAAN_f, w_f, th0, thf, dth, mu,'r');
hold on
plotOrbit(a_t_PA,e_t_PA,inc_f,RAAN_f,w_f,th0,thf,dth,mu,'m');
% PLOT EART
surf(sx*R_earth, sy*R_earth, sz*R_earth,'FaceColor', [0, 0.4470, 0.7410],'EdgeColor', 'none', 'FaceAlpha', 0.8,'HandleVisibility', 'off');


%% Apocenter Pericenter Plot

figure('Name','Pericenter-Apocenter','Color', 'k')
axes('Color', 'k', 'XColor', 'w', 'YColor', 'w', 'ZColor', 'w');
hold on; 
grid on; 
axis equal;
title('Apocenter-Pericenter')

plotOrbit(a_i, e_i, inc_f, RAAN_f, w_f, th0, thf, dth, mu, 'y'); 
hold on
plotOrbit(a_f, e_f, inc_f, RAAN_f, w_f, th0, thf, dth, mu,'r');
hold on
plotOrbit(a_t_AP,e_t_AP,inc_f,RAAN_f,w_f,th0,thf,dth,mu,'m');
% PLOT EART
surf(sx*R_earth, sy*R_earth, sz*R_earth,'FaceColor', [0, 0.4470, 0.7410],'EdgeColor', 'none', 'FaceAlpha', 0.8,'HandleVisibility', 'off');



%% Pericenter Pericenter Plot

figure('Name','Pericenter-Pericenter','Color', 'k')
axes('Color', 'k', 'XColor', 'w', 'YColor', 'w', 'ZColor', 'w');
hold on; 
grid on; 
axis equal;
title('Pericenter-Pericenter')

plotOrbit(a_i, e_i, inc_f, RAAN_f, w_f, th0, thf, dth, mu, 'y'); 
hold on
plotOrbit(a_f, e_f, inc_f, RAAN_f, w_f, th0, thf, dth, mu,'r');
hold on
plotOrbit(a_t_PP,e_t_PP,inc_f,RAAN_f,w_f+pi,th0,thf,dth,mu,'m');
% PLOT EART
surf(sx*R_earth, sy*R_earth, sz*R_earth,'FaceColor', [0, 0.4470, 0.7410],'EdgeColor', 'none', 'FaceAlpha', 0.8,'HandleVisibility', 'off');

%% Apocenter Apocenter Plot

figure('Name','Apocenter-Apocenter','Color', 'k')
axes('Color', 'k', 'XColor', 'w', 'YColor', 'w', 'ZColor', 'w');
hold on; 
grid on; 
axis equal;
title('Apocenter-Apocenter')

plotOrbit(a_i, e_i, inc_f, RAAN_f, w_f, th0, thf, dth, mu, 'y'); 
hold on
plotOrbit(a_f, e_f, inc_f, RAAN_f, w_f, th0, thf, dth, mu,'r');
hold on
plotOrbit(a_t_AA,e_t_AA,inc_f,RAAN_f,w_f+pi,th0,thf,dth,mu,'m');
% PLOT EART
surf(sx*R_earth, sy*R_earth, sz*R_earth,'FaceColor', [0, 0.4470, 0.7410],'EdgeColor', 'none', 'FaceAlpha', 0.8,'HandleVisibility', 'off');

