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

th1 = mod(th1,2*pi);
th2 = mod(th2,2*pi); 
% il comando mod mi restituisce il resto della divisione ex: mod(7*pi, 2*pi)  = pi, in modo che sia compreso tra 0 e 2*pi


% Problema: atan restituisce solo angoli compresi tra -pi/2 e pi/2, il resto non viene considerato --> utilizzare atan2
E1 = 2 * atan2(sqrt(1-e)*sin(th1/2), sqrt(1+e)*cos(th1/2));
E2 = 2 * atan2(sqrt(1-e)*sin(th2/2), sqrt(1+e)*cos(th2/2));

% atan2 restituisce un angolo
% tra 0 e pi--> moltiplicando per 2
% otterrò sempre un angolo tra [0 2*pi] :)

% If th1 or th2 are greater than pi E needs to be corrected in order for
% the atan to give the correct anomaly


% Case when th2<th1: a whole period needs to be added

if th2>th1
    deltat = sqrt(a^3 / mu) * ((E2-E1)-e*(sin(E2)-sin(E1)));

else
    T = 2*pi * sqrt(a^3 / mu);  % Period
    deltat = sqrt(a^3 / mu) * ((E2-E1)-e*(sin(E2)-sin(E1))) + T;
end

end

