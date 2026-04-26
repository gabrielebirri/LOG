function [DeltaV, omf, theta] = changeOrbitalPlane(a, e, i_i, OMi, omi, i_f, OMf, mu)
% Change of Plane maneuver
%
% [DeltaV, omf, theta] = changeOrbitalPlane(a, e, i_i, OMi, omi, i_f, OMf, mu)
% 
% -----------------------------------------------------------------------------
% Imput arguments
% a                     [1x1]   semi-major axis
% e                     [1x1]   eccentricity
% i_i                   [1x1]   initial inclination
% OMi                   [1x1]   initial RAAN
% omi                   [1x1]   initial pericenter anomaly
% i_f                   [1x1]   final inclination
% OMf                   [1x1]   final RAAN
% mu                    [1x1]   gravitational parameter
% 
% ----------------------------------------------------------------------------
% Output arguments:
% DeltaV                [1x1]   maneuver impulse
% omf                   [1x1]   final pericenter anomaly
% theta                 [1x1]   true anomaly at maneuver

% solution of the sferical triangle
DeltaOM = OMf - OMi;            % RAAN variation
Deltai =  i_f - i_i;            % initial inclinatio variation

% ui, uf triangle sides and alfa corner between the two sides
alfa = acos(cos(i_i)*cos(i_f) + sin(i_i)*sin(i_f)*cos(abs(DeltaOM)));
sin_ui = sin(abs(DeltaOM))/sin(alfa)*sin(i_f);
sin_uf = sin(abs(DeltaOM))/sin(alfa)*sin(i_i);

if (DeltaOM > 0 && Deltai > 0)
        
    cos_ui = (-cos(i_f)+cos(alfa)*cos(i_i)) / (sin(alfa)*sin(i_i));
    cos_uf = (cos(i_i)-cos(alfa)*cos(i_f)) / (sin(alfa)*sin(i_f));
    
    ui = atan2(sin_ui, cos_ui);
    uf = atan2(sin_uf, cos_uf);

    theta = ui - omi;
    omf = uf - theta;

elseif (DeltaOM > 0 && Deltai < 0)

    cos_ui = (cos(i_f)-cos(alfa)*cos(i_i)) / (sin(alfa)*sin(i_i));
    cos_uf = (-cos(i_i)+cos(alfa)*cos(i_f)) / (sin(alfa)*sin(i_f));
    
    ui = atan2(sin_ui, cos_ui);
    uf = atan2(sin_uf, cos_uf);

    theta = 2*pi - ui - omi;
    omf = 2*pi - uf - theta;

elseif (DeltaOM < 0 && Deltai > 0)


    cos_ui = (-cos(i_f)+cos(alfa)*cos(i_i)) / (sin(alfa)*sin(i_i));
    cos_uf = (cos(i_i)-cos(alfa)*cos(i_f)) / (sin(alfa)*sin(i_f));
   

    ui = atan2(sin_ui, cos_ui);
    uf = atan2(sin_uf, cos_uf);

    theta = 2*pi - ui - omi;
    omf = 2*pi - uf - theta;
else

    cos_ui = (cos(i_f)-cos(alfa)*cos(i_i)) / (sin(alfa)*sin(i_i));
    cos_uf = (-cos(i_i)+cos(alfa)*cos(i_f)) / (sin(alfa)*sin(i_f));

    ui = atan2(sin_ui, cos_ui);
    uf = atan2(sin_uf, cos_uf);

    theta = ui - omi;
    omf = uf - theta;
end


% NOI VOGLIAMO SEMPRE L'ANGOLO COMPRESO TRA 0 E 2*PI !!!
theta = mod(theta,2*pi);
omf = mod(omf,2*pi);

p = a*(1 - e^2);

if (cos(theta) > 0)
    theta = mod(theta + pi,2*pi);
    disp('conviene manovrare nel punto di intersezione tra le orbite theta + pi');
    Vtheta2 = sqrt(mu/p)*(1 + e*cos(theta));
    DeltaV = 2*Vtheta2*sin(alfa/2);
else
    Vtheta = sqrt(mu/p)*(1 + e*cos(theta));
    DeltaV = 2*Vtheta*sin(alfa/2);    
end


end
