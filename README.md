# LOG
Progetto di gruppo Analisi di Missioni Spaziali

%% 
function [rr,vv] = par2car(a,e,i,OM,om,th,mu)
% Transformation from Cartesian coordinates to Kelperian parameters
%
% Input Arguments:
% a     [1x1] semi-major axis           [km]
% e     [1x1] eccentricity              [-]    
% i     [1x1] inclination               [rad]
% OM    [1x1] RAAN                      [rad]   
% om    [1x1] pericenter anomaly        [rad]
% th    [1x1] true anomaly              [rad]
% mu    [1x1] gravitational parameter   [km^3/s^2]
%
% Output Arguments: 
% rr    [3x1] position vector           [km]
% vv    [3x1] velocity vector           [km/s]

R_OM = rotz(rad2deg(OM))'; % Rotation Matrix around z-axis by OM-angle (degrees)
R_i = rotx(rad2deg(i))'; % Rotation Matrix around x-axis by i-angle (degrees)
R_om = rotz(rad2deg(om))'; % Rotation Matrix around z-axis by om-angle (degrees)
T = R_om * R_i * R_OM; % Total Rotation Matrix ECI --> PF

p = a*(1-e^2);
r = p / (1+e*cos(th));
r_til = r* [ cos(th); sin(th); 0];
v_til = sqrt(mu/p) * [-sin(th); e+cos(th); 0];
rr = T'* r_til; % T' PF --> ECI
vv = T' * v_til;

end

%% 
function [a,e,i,OM,om,th] = car2par(rr,vv,mu)
% Transformation from Cartesian coordinates to Kelperian parameters
%
% Input Arguments:
% rr    [3x1] position vector           [km]
% vv    [3x1] velocity vector           [km/s]
% mu    [1x1] gravitational parameter   [km^3/s^2] 
%
% Output Arguments: 
% a     [1x1] semi-major axis           [km]
% e     [1x1] eccentricity              [-]    
% i     [1x1] inclination               [rad]
% OM    [1x1] RAAN                      [rad]   
% om    [1x1] pericenter anomaly        [rad]
% th    [1x1] true anomaly              [rad]

r = norm(rr);
v = norm(vv);
a = (2/r - v^2/mu)^-1;
hh = cross(rr,vv); % angular momentum vector
h = norm(hh); % angular momentum vector norm
ee = cross(vv,hh)/mu - rr/r;
e = norm(ee);
i =acos (hh(3)/h); % hh x k = hh(3) component along k, hh*k
k = [0;0;1] ; % k- unit vector;
N = cross(k,hh) / norm(cross(k,hh));

if N(2) >= 0 % N(2) = N*j
    OM = acos(N(1)); % N(1) = N*i
else
    OM = 2*pi-acos(N(1));
end

if ee(3) >=0
    om = acos(dot(N,ee)/e);
else
    om = 2*pi-acos(dot(N,ee)/e);
end

vr = dot(vv,rr)/r;

if vr >=0 % ci allontaniamo dal pericentro
    th = acos(dot(rr,ee)/(r*e));
else % ci avviciniamo al pericentro
    th = 2*pi-acos(dot(rr,ee)/(r*e));
end


%%
function plotOrbit (a,e,i,OM,om,th0,thf,dth,mu)

% 3D orbit plot
%
% Input Arguments:
% a     [1x1] semi-major axis           [km]
% e     [1x1] eccentricity              [-]    
% i     [1x1] inclination               [rad]
% OM    [1x1] RAAN                      [rad]   
% om    [1x1] pericenter anomaly        [rad]
% th0   [1x1] initial true anomaly      [rad]
% thf   [1x1] final true anomaly        [rad]
% dth   [1x1] true anomaly step size    [rad]
% mu    [1x1] gravitational parameter   [km^3/s^2]

th = th0:dth:thf; % true anomaly vector
n = length(th);
rr = zeros(3,n);
vv = zeros(3,n);
for  k = 1:length(th)
    [rr_k,vv_k] = par2car(a,e,i,OM,om,th(k),mu);
    rr(:,k) = rr_k;
    vv(:,k) = vv_k;
end
plot3(rr(1,:),rr(2,:),rr(3,:), 'LineWidth',2, 'Color' ,'k');
axis equal;
xlabel('X [km]'); 
ylabel('Y [km]'); 
zlabel('Z [km]');
title('Orbital Trajectory Simulation');
view(3); % 3D standard view
grid on;
hold on;

%% PLot of Earth Surface (as a Sphere)

[sx, sy, sz] = sphere(30);
R_earth = 6378;
surf (R_earth*sx, R_earth*sy,R_earth*sz,'FaceColor', 'blue', 'EdgeColor', 'none', 'FaceAlpha', 1); % surface plot of Earth


end
end

