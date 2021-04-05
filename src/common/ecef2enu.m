function enu=ecef2enu(pos,LOS)

E=xyz2enu(pos);
enu=E*LOS';

return;