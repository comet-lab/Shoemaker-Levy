function OT = ModelDrillShaftOT(DrillStart, DrillTarget, DrillD)
PointsAlongShaft = 1000;
DVect = DrillTarget - DrillStart;

npts = 50;
[xx, yy] = cylinder(DrillD/2 + Sagitta(DrillD/2, 2*pi/(npts-1)), npts);

xx = repmat(xx(1,:), PointsAlongShaft, 1);
yy = repmat(yy(1,:), PointsAlongShaft, 1);
zz = norm(DVect)*repmat((0:1/(PointsAlongShaft-1):1).', 1, size(xx, 2));
DrillShaftOrigin = [reshape(xx, 1 , numel(xx)); reshape(yy, 1 , numel(yy)); reshape(zz, 1, numel(zz))];

R = Vectors2Rotation([0;0;1], DVect);
T = DrillStart(:);
DrillShaft = R*DrillShaftOrigin + repmat(T, 1, size(DrillShaftOrigin, 2));

OT = OcTree(DrillShaft.', 'MaxSize', 0.5, 'Aligned', 'PCA');
end