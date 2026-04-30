% FIRST SCENARIO: Final maneuver order
clear
clc

% Plotting parameters
th0   = 0;
thf_plot = 2*pi;
dth   = 0.01;

% Starting Orbit
a_i     = 24400.00;     % [km]
e_i     = 0.728300;     % [-]
inc_i   = 0.104700;     % [rad]
RAAN_i  = 1.136000;     % [rad]
w_i     = 3.107000;     % [rad]
theta_i = 2.371000;     % [rad]
mu      = 398600;       % [km^3/s^2]

[rr_i, vv_i] = par2car(a_i, e_i, inc_i, RAAN_i, w_i, theta_i, mu);
plotOrbit(a_i, e_i, inc_i, RAAN_i, w_i, th0, thf_plot, dth, mu, 'g');
hold on

% Final Orbit
rx_f =  -17874.100000;  % [km]
ry_f =  -12975.567000;  % [km]
rz_f =   2124.941500;   % [km]
vx_f =    2.779000;     % [km/s]
vy_f =   -4.117000;     % [km/s]
vz_f =   -1.761000;     % [km/s]

rr = [rx_f, ry_f, rz_f];
vv = [vx_f, vy_f, vz_f];
[a_f, e_f, inc_f, RAAN_f, w_f, theta_f] = car2par(rr, vv, mu);

plotOrbit(a_f, e_f, inc_f, RAAN_f, w_f, th0, thf_plot, dth, mu, 'r');


% STRATEGIA DELLE MANOVRE

% rapporto a_f/a_i ≈ 0.97  -> trasferimento bitangente (non biellittico)
% Ordine manovre:
%   1) Trasferimento bitangente (pa o ap)
%   2) Cambio di piano orbitale (nel nodo ottimale sull'orbita finale)
%   3) Cambio dell'argomento di pericentro (usando omf, NON w_i)

rapporto = a_f / a_i;
fprintf('Rapporto a_f/a_i = %.4f\n', rapporto);




%  CASO 1 — TRASFERIMENTO BITANGENTE PERICENTRO → APOCENTRO  (pa)
fprintf('TRASFERIMENTO BITANGENTE: Pericentro -> Apocentro (pa)\n');

[DV1_pa, DV2_pa, T2_pa] = bitangentTransfer(a_i, e_i, a_f, e_f, 'pa', mu);
a_pa = (a_i*(1-e_i) + a_f*(1+e_f))/2;
e_pa = (a_f*(1+e_f) - a_i*(1-e_i))/(a_f*(1+e_f) + a_i*(1-e_i));
plotOrbit(a_pa, e_pa, inc_i, RAAN_i, w_i, th0, thf_plot, dth, mu, 'c');

% T1: tempo dall'anomalia vera corrente al PERICENTRO (theta=0) dell'orbita iniziale
T1_pa = TOF(a_i, e_i, theta_i, 0, mu);

% Cambio di piano: eseguito nel nodo ottimale sull'orbita finale.
% NOTA: omf è il nuovo argomento del pericentro dopo il cambio piano;
% theta_cp è l'anomalia vera del nodo di cambio piano

% Il bitangente 'pa' porta al PERICENTRO di a_f: si parte da theta=0
[DV3_pa, omf_pa, theta_cp_pa] = changeOrbitalPlane(a_f, e_f, inc_i, RAAN_i, w_i, inc_f, RAAN_f, mu);
T3_pa = TOF(a_f, e_f, 0, theta_cp_pa, mu);   % da pericentro al nodo CP

% Cambio argomento di pericentro: usare omf_pa (non w_i!) come angolo iniziale
[DV4_pa, thi_pa, thf_pa] = changePericenterArg(a_f, e_f, omf_pa, w_f, mu);
T4_pa = TOF(a_f, e_f, theta_cp_pa, thi_pa(1), mu);  % dal nodo CP al punto di manovra
T5_pa = TOF(a_f, e_f, thi_pa(1),   theta_f,   mu);  % dal punto di manovra alla posizione finale

DeltaVtot_pa = abs(DV1_pa) + abs(DV2_pa) + abs(DV3_pa) + abs(DV4_pa);
Ttot_pa      = T1_pa + T2_pa + T3_pa + T4_pa + T5_pa;

fprintf('DeltaV1 (bitangente imp.1) : %.4f km/s\n', abs(DV1_pa));
fprintf('DeltaV2 (bitangente imp.2) : %.4f km/s\n', abs(DV2_pa));
fprintf('DeltaV3 (cambio piano)     : %.4f km/s\n', abs(DV3_pa));
fprintf('DeltaV4 (cambio peric.arg) : %.4f km/s\n', abs(DV4_pa));
fprintf('Costo Totale (Delta V)     : %.4f km/s\n', DeltaVtot_pa);
fprintf('Tempo Totale               : %.2f s  (%.2f ore)\n', Ttot_pa, Ttot_pa/3600);




%  CASO 2 — TRASFERIMENTO BITANGENTE APOCENTRO → PERICENTRO  (ap)
fprintf('TRASFERIMENTO BITANGENTE: Apocentro -> Pericentro (ap)\n');

[DV1_ap, DV2_ap, T2_ap] = bitangentTransfer(a_i, e_i, a_f, e_f, 'ap', mu);
a_ap = (a_i*(1+e_i) + a_f*(1-e_f))/2;
e_ap = (a_i*(1+e_i) - a_f*(1-e_f))/(a_i*(1+e_i) + a_f*(1-e_f));
plotOrbit(a_ap, e_ap, inc_i, RAAN_i, w_i, th0, thf_plot, dth, mu, 'm');

% T1: tempo dall'anomalia vera corrente all'APOCENTRO dell'orbita iniziale
T1_ap = TOF(a_i, e_i, theta_i, pi, mu);

% Il bitangente 'ap' porta all'APOCENTRO di a_f → si parte da theta=pi
[DV3_ap, omf_ap, theta_cp_ap] = changeOrbitalPlane(a_f, e_f, inc_i, RAAN_i, w_i, inc_f, RAAN_f, mu);
T3_ap = TOF(a_f, e_f, pi, theta_cp_ap, mu);   % dall'apocentro al nodo CP

% Cambio argomento di pericentro: usare omf_ap
[DV4_ap, thi_ap, thf_ap] = changePericenterArg(a_f, e_f, omf_ap, w_f, mu);
T4_ap = TOF(a_f, e_f, theta_cp_ap, thi_ap(1), mu);
T5_ap = TOF(a_f, e_f, thi_ap(1),   theta_f,   mu);

DeltaVtot_ap = abs(DV1_ap) + abs(DV2_ap) + abs(DV3_ap) + abs(DV4_ap);
Ttot_ap      = T1_ap + T2_ap + T3_ap + T4_ap + T5_ap;

fprintf('DeltaV1 (bitangente imp.1) : %.4f km/s\n', abs(DV1_ap));
fprintf('DeltaV2 (bitangente imp.2) : %.4f km/s\n', abs(DV2_ap));
fprintf('DeltaV3 (cambio piano)     : %.4f km/s\n', abs(DV3_ap));
fprintf('DeltaV4 (cambio peric.arg) : %.4f km/s\n', abs(DV4_ap));
fprintf('Costo Totale (Delta V)     : %.4f km/s\n', DeltaVtot_ap);
fprintf('Tempo Totale               : %.2f s  (%.2f ore)\n', Ttot_ap, Ttot_ap/3600);
%  CASO 3 — CAMBIO PIANO INIZIALE + BITANGENTE PA
fprintf('\nCASO 3: Cambio Piano Iniziale -> Bitangente PA -> Cambio w\n');

% 1) Cambio piano su orbita iniziale
[DV1_c3, omf_c3, theta_cp_c3] = changeOrbitalPlane(a_i, e_i, inc_i, RAAN_i, w_i, inc_f, RAAN_f, mu);
T1_c3 = TOF(a_i, e_i, theta_i, theta_cp_c3, mu);

% 2) Trasferimento bitangente PA (da pericentro ad apocentro)
T2_c3 = TOF(a_i, e_i, theta_cp_c3, 0, mu);
[DV2_c3, DV3_c3, T3_c3] = bitangentTransfer(a_i, e_i, a_f, e_f, 'pa', mu);

% 3) Cambio argomento di pericentro
[DV4_c3, thi_c3, thf_c3] = changePericenterArg(a_f, e_f, omf_c3, w_f, mu);
T4_c3 = TOF(a_f, e_f, pi, thi_c3(1), mu);
T5_c3 = TOF(a_f, e_f, thi_c3(1), theta_f, mu);

DeltaVtot_c3 = abs(DV1_c3) + abs(DV2_c3) + abs(DV3_c3) + abs(DV4_c3);
Ttot_c3 = T1_c3 + T2_c3 + T3_c3 + T4_c3 + T5_c3;

fprintf('DeltaV1 (cambio piano)     : %.4f km/s\n', abs(DV1_c3));
fprintf('DeltaV2 (bitangente imp.1) : %.4f km/s\n', abs(DV2_c3));
fprintf('DeltaV3 (bitangente imp.2) : %.4f km/s\n', abs(DV3_c3));
fprintf('DeltaV4 (cambio peric.arg) : %.4f km/s\n', abs(DV4_c3));
fprintf('Costo Totale (Delta V)     : %.4f km/s\n', DeltaVtot_c3);
fprintf('Tempo Totale               : %.2f s  (%.2f ore)\n', Ttot_c3, Ttot_c3/3600);


%  CASO 4 — CAMBIO PIANO INIZIALE + BITANGENTE AP
fprintf('\nCASO 4: Cambio Piano Iniziale -> Bitangente AP -> Cambio w\n');

% 1) Cambio piano su orbita iniziale
[DV1_c4, omf_c4, theta_cp_c4] = changeOrbitalPlane(a_i, e_i, inc_i, RAAN_i, w_i, inc_f, RAAN_f, mu);
T1_c4 = TOF(a_i, e_i, theta_i, theta_cp_c4, mu);

% 2) Trasferimento bitangente AP (da apocentro a pericentro)
T2_c4 = TOF(a_i, e_i, theta_cp_c4, pi, mu);
[DV2_c4, DV3_c4, T3_c4] = bitangentTransfer(a_i, e_i, a_f, e_f, 'ap', mu);

% 3) Cambio argomento di pericentro
[DV4_c4, thi_c4, thf_c4] = changePericenterArg(a_f, e_f, omf_c4, w_f, mu);
T4_c4 = TOF(a_f, e_f, 0, thi_c4(1), mu);
T5_c4 = TOF(a_f, e_f, thi_c4(1), theta_f, mu);

DeltaVtot_c4 = abs(DV1_c4) + abs(DV2_c4) + abs(DV3_c4) + abs(DV4_c4);
Ttot_c4 = T1_c4 + T2_c4 + T3_c4 + T4_c4 + T5_c4;

fprintf('DeltaV1 (cambio piano)     : %.4f km/s\n', abs(DV1_c4));
fprintf('DeltaV2 (bitangente imp.1) : %.4f km/s\n', abs(DV2_c4));
fprintf('DeltaV3 (bitangente imp.2) : %.4f km/s\n', abs(DV3_c4));
fprintf('DeltaV4 (cambio peric.arg) : %.4f km/s\n', abs(DV4_c4));
fprintf('Costo Totale (Delta V)     : %.4f km/s\n', DeltaVtot_c4);
fprintf('Tempo Totale               : %.2f s  (%.2f ore)\n', Ttot_c4, Ttot_c4/3600);


legend('Initial Orbit', 'Final Orbit', 'Transfer Orbit PA', 'Transfer Orbit AP', 'TextColor', 'w', 'Color', 'k', 'Location', 'best');

%  CONFRONTO FINALE
fprintf('\nCONFRONTO FINALE DELLE STRATEGIE\n');
fprintf('Caso 1 (Bitangente PA -> Cambio Piano -> Cambio w): %.4f km/s\n', DeltaVtot_pa);
fprintf('Caso 2 (Bitangente AP -> Cambio Piano -> Cambio w): %.4f km/s\n', DeltaVtot_ap);
fprintf('Caso 3 (Cambio Piano -> Bitangente PA -> Cambio w): %.4f km/s\n', DeltaVtot_c3);
fprintf('Caso 4 (Cambio Piano -> Bitangente AP -> Cambio w): %.4f km/s\n', DeltaVtot_c4);

costs = [DeltaVtot_pa, DeltaVtot_ap, DeltaVtot_c3, DeltaVtot_c4];
[min_cost, best_idx] = min(costs);

fprintf('\n>> La strategia più conveniente è il CASO %d, con Delta V totale = %.4f km/s\n', best_idx, min_cost);