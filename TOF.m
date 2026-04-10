function [deltat] = TOF(a, e, th1, th2, mu)
% Time of Flight
%
% deltat = TOF(a, e, th1, th2, mu)
%
% ---------------------------------------------
% Input Arguments:
% a      [1x1]   semi-major axis             [km]
% e      [1x1]   eccentricity                [-]
% th1    [1x1]   initial true anomaly        [rad]
% th2    [1x1]   final true anomaly          [rad]
% mu     [1x1]   gravitational parameter     [km^3/s^2]
%
% -----------------------------------------------
% Output argument:
% deltat [1x1]  time of flight               [s]
% -----------------------------------------------


E1 = 2 * atan(sqrt((1-e)/(1+e))*tan(th1/2));
E2 = 2 * atan(sqrt((1-e)/(1+e))*tan(th2/2));

% If th1 or th2 are greater than pi E needs to be corrected in order for
% the atan to give the correct anomaly

if th1 > pi
    E1 = E1 + 2 * pi; % Adjust E1 for the case when th1 > pi
end

if th2 > pi
    E2 = E2 + 2 * pi; % Adjust E2 for the case when th2 > pi
end

% Case when th2<th1: a whole period needs to be added

if th2>th1
    deltat = sqrt(a^3 / mu) * ((E2-E1)-e*(sin(E2)-sin(E1)));

else
    T = 2*pi * sqrt(a^3 / mu);  % Period
    deltat = sqrt(a^3 / mu) * ((E2-E1)-e*(sin(E2)-sin(E1))) + T;
end

end

