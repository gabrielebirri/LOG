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
[rr_i,vv_i] = par2car(a_i,e_i,inc_i,RAAN_i,w_i,theta_i,mu);
plotOrbit (a_i,e_i,inc_i,RAAN_i,w_i,th0,thf,dth,mu);
hold on

% Final Orbit

rx_f = -17874.100000;
vx_f = 2.779000;
vy_f = -4.117000;
vz_f = -1.761000;
rr = [rx_f,0,0];
vv = [vx_f,vy_f,vz_f];
[a_f,e_f,inc_f,RAAN_f,w_f,theta_f] = car2par(rr,vv,mu);
plotOrbit (a_f,e_f,inc_f,RAAN_f,w_f,th0,thf,dth,mu);

% il seguente codice ha l'obiettivo di trovare il trasferimento che
% minimizza il DeltaV necessario tentativo1

% calcolo af/ai
rapporto = a_f/a_i; % =  0.9708

% poiché il rapporto è molto minore di 11,94 deduco che il trasferimento
% bitangente è più conveniente 

% per minimizzare il costo dovuto al cambio di piano, la manovra viene
% eseguita il più lontano possibile dal corpo attrattore, seguendo questo
% ragionamento il cambio di piano viene eseguito dopo il trasferimento
% bitangente


[DeltaV1, DeltaV2, T2] = bitangentTransfer(a_i, e_i,a_f, e_f,'pa',mu);

% T1 = tempo per raggiungere l'apocentro
[T1] = TOF(a_i, e_i, theta_i, 0, mu);

% manovra di cambio piano

[DeltaV3, omf, theta] = changeOrbitalPlane(a_f, e_f, inc_i, RAAN_i, w_i, inc_f, RAAN_f, mu);

[T3] = TOF(a_f, e_f, pi, theta, mu);

[DeltaV, thi, thf] = changePericenterArg(a_f, e_f, w_i, w_f, mu);

[T4] = TOF(a_f, e_f, theta, thi(1), mu);

[T5] = TOF(a_f, e_f, thi(1), theta_f, mu);