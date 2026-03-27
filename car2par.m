
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
