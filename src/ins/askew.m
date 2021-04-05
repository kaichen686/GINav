function matrix = askew(vector)
% convert 3x1 vector to 3x3 askew matrix.

matrix = [        0,  -vector(3),   vector(2);
          vector(3),           0,  -vector(1);
         -vector(2),   vector(1),           0];
return      