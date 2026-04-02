function [DeltaV1, DeltaV2, DeltaV3, Deltat1, Deltat2] = biellipticTransfer(ai, ei, af, ef, ra_t, mu)
% Bitangent transfer for elliptic orbits
% 
% [DeltaV1, DeltaV2, DeltaV3, Deltat1, Deltat2] = biellipticTransfer(ai, ei, af, ef, ra_t, mu)
% 
% -----------------------------------------------------------------------------------------------
% Imput arguments:
%  ai           [1x1] initial semi-major axis            [km]
%  ei           [1x1] initial eccentricity               [-]
%  af           [1x1] final semi-major axis              [km]
%  ef           [1x1] final eccentricity                 [-]
%  ra_t         [1x1] transfer orbits apocenter distance [km]
%  mu           [1x1] gravitational parameter            [km^3/s^2]
% 
% ----------------------------------------------------------------------------------------------
% Output arguments:
% DeltaV1       [1x1] 1st maneuver impulse              [km/s]
% DeltaV2       [1x1] 2nd maneuver impulse              [km/s]
% DeltaV3       [1x1] 3nd maneuver impulse              [km/s]
% Deltat1       [1X1] maneuver time 1                   [s]
% Deltat2       [1x1] maneuver time 2                   [s]
% 
% ---------------------------------------------------------------------------------------------



% transfer orbit parameter
rp_t1 = ai*(1 - ei); % apocenter radius transfer orbit 1
rp_t2 = af*(1 - ef); % apocenter radius transfer orbit 2
rp_i = rp_t1; % pericenter radius transfer orbit 1
rp_f = rp_t2; % pericenter radius transfer orbit 1

a1_t = (ra_t + rp_t1)/2;
a2_t = (ra_t + rp_t2)/2;

% impulse 
DeltaV1 = sqrt(mu)*(sqrt(2/rp_t1 - 1/a1_t) - sqrt(2/rp_i - 1/ai));
DeltaV2 = sqrt(mu)*(sqrt(2/ra_t - 1/a2_t) - sqrt(2/ra_t - 1/a1_t));
DeltaV3 = sqrt(mu)*(sqrt(2/rp_f - 1/af) - sqrt(2/rp_t2 - 1/a2_t));
Deltat1 = pi*sqrt(a1_t^3/mu);
Deltat2 = pi*sqrt(a2_t^3/mu);

end

