% Ricerca traiettoria di trasfermiento eliocentrica tra Terra e Marte che
% minimizza il DeltaV richiesto

clear
clc
close all

% costante planetaria SOLE:
mu = 132712440018;                  % [km^3/s^2] costante planetaria

% Orbita terra eliocentrica:
a_i = 149.60e6;                     % [km]  semiasse maggiore
e_i = 0.0167086;                    % [-]   eccentricità
i_i = 7.155*pi/180;                 % [rad] inclinazione del piano orbitale
OM_i = 174.9*pi/180;                % [rad] ascensione retta del nodo ascendente
om_i = 288.1*pi/180;                % [rad] anomalia del pericentro

% orbita Marte eliocentrica:
a_f = 227936637;                    % [km]  semiasse maggiore
e_f = 0.09341233;                   % [-]   eccentricità
i_f = 5.65*pi/180;                  % [rad] inclinazione del piano orbitale
OM_f = 49.57854*pi/180;             % [rad] ascensione retta del nodo ascendente
om_f = 286.46230*pi/180;            % [rad] anomalia del pericentro


%% grafico delle orbite iniziali e finali

fig = figure('Color', 'k'); % Imposta il colore di sfondo della finestra su nero
ax = axes('Parent', fig, 'Color', 'k', ...
          'XColor', 'w', 'YColor', 'w', 'ZColor', 'w'); % Assi neri, testo/griglia bianchi
hold(ax, 'on');
grid(ax, 'on');
axis(ax, 'equal'); % Mantiene le proporzioni corrette tra gli assi

plotOrbit(a_i,e_i,i_i,OM_i,om_i,0,2*pi,0.01,mu,'b');
plotOrbit(a_f,e_f,i_f,OM_f,om_f,0,2*pi,0.01,mu,'r');
hold on

% Raggi esagerati per rendere visibili i corpi celesti nel grafico
raggio_sole = 0.35e8;
raggio_pianeta = 0.15e8;

xt = -147127000;
yt = 21255400;
zt = -1015860;

xm = 99922200;
ym = 201623000;
zm = 5407930;

crea_corpo_celeste('Sun.jpg' , raggio_sole, 0, 0, 0);
crea_corpo_celeste('Earth.jpg' , raggio_pianeta, xt, yt, zt);
crea_corpo_celeste('Mars.jpg' , raggio_pianeta, xm, ym, zm);

%%  RICRCA ORBITA ELIOCENTRICA CHE COLLEGA PUNTO 1 E 2 GARANTENDO IL MINIMO DELTA-V

% variabile libera: om_T [0,2pi]

% definizione dei punti iniziali e finali:
[r1,v1] = par2car(a_i,e_i,i_i,OM_i,om_i,0,mu);

[r2,v2] = par2car(a_f,e_f,i_f,OM_f,om_f,pi,mu);

% determinazione piano orbitale di trasferimento:

h = cross(r1,r2);
h = h/norm(h);

i_T = acos(dot(h,[0,0,1]));

N = cross([0,0,1],h);
N = N/norm(N);

if dot(N, [0,1,0]) >= 0
    OM_T = acos(dot(N,[1,0,0]));
else
    OM_T = 2*pi - cos(dot(N,[1,0,0]));   
end

% GRID-SEARCH
omVal = linspace(0,2*pi,10);
DeltaV = [];

for om_T = omVal
    % matrice da sdr inerziale a perifocale
    Rom = [cos(om_T), sin(om_T), 0;
           -sin(om_T), cos(om_T), 0;
           0,           0,        1];

    Ri = [1,    0,      0;
          0, cos(i_T), sin(i_T);
          0, -sin(i_T), cos(i_T)];

    ROM = [cos(OM_T), sin(OM_T), 0;
           -sin(OM_T), cos(OM_T), 0;
           0,           0,        1];

    T = Rom*Ri*ROM;

    r1T = T*r1;
    r2T = T*r2;

    %anomalie vere sull'orbita di riferimento
    th1_t = atan2(r1(1)/norm(r1), r1(2)/norm(r1));
    th1_t = mod(th1_t,2*pi);

    th2_t = atan2(r2(1)/norm(r2), r2(2)/norm(r2));
    th2_t = mod(th2_t,2*pi);

    % parametri di forma

    e_t = (norm(r2) - norm(r1))/(norm(r1)*cos(th1_t) - norm(r2)*cos(th2_t));
    a_t = norm(r1)*(1 + e_t*cos(th1_t))/(1 - e_t^2);

    v1T = T*v1;
    v2T = T*v2;

    DeltaV = [DeltaV; norm(v1T - v1) + norm(v2 - v2T)];

    plotOrbit(a_t,e_t,i_T,OM_T,om_T,th1_t,th2_t,0.01,mu,'k');
end

min(DeltaV)