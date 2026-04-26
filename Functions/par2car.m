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

