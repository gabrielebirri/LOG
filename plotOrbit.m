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

