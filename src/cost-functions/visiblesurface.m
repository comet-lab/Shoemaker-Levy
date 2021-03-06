function [s, seenMap] = visiblesurface(alpha)

% define the robot's range of motion
maxDisplacement = 1; % [mm]
maxRotation     = 4 * pi; % [rad]
maxAdvancement  = 10; % [mm]

% Load cavity model
path = fullfile('..', 'anatomical-models', 'synthetic-model.stl');
% path = fullfile( 'anatomical-models', 'synthetic-model.stl');

[vertices, faces, ~, ~] = stlRead(path);
earModel.vertices = vertices;
earModel.faces = faces;

% Load segmentation
load(fullfile('..', 'anatomical-models', 'mesegmentation.mat'), 'ROImap');

% Calculate the base transform for the robot
t = [35 10 10];
R = [0 0 -1; 0 1 0; 1 0 0];
T = [R t'; 0 0 0 1];
earModel.baseTransform = T;

% Create a robot
%alpha = 0;
cutouts = [];
cutouts.w = [1 1 1 1 1 1];
cutouts.u = [1 1 1 1 1 1];
cutouts.h = [1 1 1 1 1 1];
cutouts.alpha = [0 0 0 alpha 0 0];

robot = Wrist(1.6, 1.85, 6, cutouts);

% Run RRT to estimate the reachable workspace of the robot
nPoints = 100;

[~,qList,pList,aList] = rrt(robot, ...
    [maxDisplacement maxRotation maxAdvancement], ...
    earModel, ...
    nPoints);

% Re-load the cavity model (a finer mesh this time)
path = fullfile('..', 'anatomical-models', 'synthetic-model-finer-cropped.stl');
[vertices, faces, ~, ~] = stlRead(path);
earModel.vertices = vertices;
earModel.faces = faces;

% Calculate the visibility map
seenMap = zeros(size(pList, 2), size(earModel.faces, 1));

for ii = 1 : size(pList, 2)
    seenMap(ii,:) = visibilitymap(pList(:,ii), aList(:,ii), earModel);
end

seenMap = sum(seenMap, 1);
seenMap(seenMap > 1) = 1;

seenMap = seenMap & ROImap;

% Use the visibility map to estimate the total visible area
% s = seenArea(earModel, seenMap);

visibleRatio = seenMap/ROImap; % must be 0<= visibleratio <=1
s = 1-visibleRatio;

end
