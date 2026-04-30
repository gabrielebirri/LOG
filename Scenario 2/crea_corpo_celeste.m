function crea_corpo_celeste(img_file, r, cx, cy, cz)
% crea_corpo_celeste(img_file, r, cx, cy, cz)
% funzione che genera l'immagine di un corpo celsete
%
% IMPUT:
% img_file    directory del file immagine del corpo celeste
% r           raggio del corpo celeste
% cx, cy, cz  coordinate del centro 

[x_sfera, y_sfera, z_sfera] = sphere(50); % Genera la geometria di una sfera (alta risoluzione)
surf(x_sfera * r + cx, y_sfera * r + cy, z_sfera * r + cz,'CData', imread(img_file),'FaceColor', 'texturemap','EdgeColor', 'none');
end

