function [DeltaV, thi, thf] = changePericenterArg(a, e, omi, omf, mu)

% Change of Pericenter Argument maneuver
%
% [DeltaV, thi, thf] = changePericenterArg(a, e, omi, omf, mu)
%
% -------------------------------------------------------------------------
% Input arguments:
% a      [1x1]   semi-major axis             [km]
% e      [1x1]   eccentricity                [-]
% omi    [1x1]   initial pericenter anomaly  [rad]
% omf    [1x1]   final pericenter anomaly    [rad]
% mu     [1x1]   gravitational parameter     [km^3/s^2]
%
% -------------------------------------------------------------------------
% Output arguments:
% DeltaV [1x1]   maneuver impulse            [km/s]
% thi    [2x1]   initial true anomalies      [rad]
% thf    [2x1]   final true anomalies        [rad]
% -------------------------------------------------------------------------

% First real anomaly option for the manouver
thi1 = (omf-omi)/2;
thf1 = 2*pi - thi1;

% First real anomaly option for the manouver
thi2 = pi + (omf-omi)/2;
thf2 = pi - (omf-omi)/2;

% Vectors containing real anomalies in which the manouver is possible
thi = [thi1; thi2];
thf = [thf1; thf2];

% Cost of the manouver (expressed in delta V)
p = a*(1-e^2);
DeltaV = 2*sqrt(mu/p)*e*sin((omf-omi)/2);


end