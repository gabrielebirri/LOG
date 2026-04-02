function [DeltaV1, DeltaV2, Deltat] = bitangentTransfer(a_i, e_i,a_f, e_f,type,mu)
% Bitangent transfer for elliptic orbits
%
% [DeltaV1, DeltaV2, Deltat] = bitangentTransfer(a_i, e_i,a_f, e_f,type,mu)
%
% Input Arguments:
% ai    [1x1] initial semi-major axis           [km]
% ei    [1x1] initial eccentricity              [-]
% af    [1x1] final semi-major axis             [km] 
% ef    [1x1] final eccentricity                [-]
% type  [char] maneuver type                   
% mu    [1x1] gravitational parameter           [km^3/s^2]
%
% Output Arguments: 
% DeltaV1    [1x1] first maneuver impulse       [km/s]
% DeltaV2    [1x1] second maneuver impulse      [km/s]
% Deltat     [1x1] maneuver time                [s]

if type == "pa" % from Pericenter to Apocenter
    rp_T = a_i * (1-e_i); % Pericenter Radius Transfer Orbit = Pericenter Radius Initial Orbit
    ra_T = a_f*(1+e_f); % Apocenter Radius Transfer Orbit = Apocenter Radius Final Orbit
    a_T = (ra_T+rp_T) / 2; % Semi-major Axis Transfer Orbit
    DeltaV1 = sqrt(mu) * sqrt(2/rp_T-1/a_T) - sqrt(mu) *sqrt(2/rp_T-1/a_i);
    DeltaV2 = sqrt(mu) * sqrt(2/ra_T-1/a_f) - sqrt(mu) *sqrt(2/ra_T-1/a_T);

elseif  type == "ap" % from Apocenter to Pericenter
    ra_T = a_i * (1+e_i); % Apocenter Radius Transfer Orbit = Apocenter Radius Initial Orbit
    rp_T = a_f * (1-e_f); % Pericenter Radius Transfer Orbit = Pericenter Radius Final Orbit
    a_T = (ra_T+rp_T) / 2; % Semi-major Axis Transfer Orbit
    DeltaV1 = sqrt(mu) * sqrt(2/ra_T - 1/a_T)-sqrt(mu) *sqrt(2/ra_T-1/a_i);
    DeltaV2 = sqrt(mu) * sqrt(2/rp_T-1/a_f) - sqrt(mu) * sqrt(2/rp_T-1/a_T);

elseif type == "pp"
    rp_T = a_i * (1-e_i); % Transfer Pericenter Radius =  Initial Pericenter Radius
    ra_T = a_f * (1-e_f); % Transfer Apocenter Radius = Final Pericenter Radius
    a_T = (ra_T+rp_T) / 2; % Semi-major Axis Transfer Orbit
    DeltaV1 = sqrt(mu) * sqrt(2/rp_T - 1/a_T)-sqrt(mu) *sqrt(2/rp_T-1/a_i);
    DeltaV2 = sqrt(mu) * sqrt(2/ra_T-1/a_f) - sqrt(mu) * sqrt(2/ra_T-1/a_T);

elseif  type =="aa"
    rp_T = a_i * (1+e_i); % Transfer Pericenter Radius = Initial Apocenter Radius 
    ra_T = a_f * (1+e_f); % Transfer Apocenter Radius = Final Apocenter Radius
    a_T = (ra_T+rp_T) / 2; % Semi-major Axis Transfer Orbit
    DeltaV1 = sqrt(mu) * sqrt(2/rp_T - 1/a_T)-sqrt(mu) *sqrt(2/rp_T-1/a_i);
    DeltaV2 = sqrt(mu) * sqrt(2/ra_T-1/a_f) - sqrt(mu) * sqrt(2/ra_T-1/a_T);
end

Deltat = pi* sqrt( (a_T)^3 / mu ); % Time for the Maneuver


end


