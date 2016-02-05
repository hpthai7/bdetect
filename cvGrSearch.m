function O = cvGrSearch(I, delta)
% cvGrSearch - Image Boundary Detection
%
% Synopsis
%		O = cvGrSearch(I, [delta])
%
% Description
%		Image Boundary Detection via Graph-Theoretic Techniques

% Inputs ([]s are optional)
%   (matrix) I		MxN matrix representing the input image
%   (scalar) [delta = []]
%						Sensitivity threshold. Ignores all edges whose
%						difference of upper and lower bound is less than delta. 
%						If empty([]) is given, take the default value 50.
%
% Outputs ([]s are optional)
%		(matrix) O	MxN matrix representing the output.
%
% Examples
%		I = cvuImread('world.gif');
%		O = cvGrSearch(I)
%		figure; imshow(I);
%		figure; imshow(O);
%		O = cvGrSearch(I, 80);
%		figure; imshow(I);
%
% See also
%		Digital Image Processing by Gonzalez, page 591
%		edge (edge.m does thining lines too)
%
% Authors
%		Thai Ho
%
% Changes
%		28/11/2011 First Edition
if ~exist('delta', 'var') || isempty(delta)
    delta = input('Enter the difference: delta = ');
end

J = max(max(I)) - I;
R = imrotate(I, -90);

% Falling and rising edge matrix
fall = cvGrSearchFall(I, delta);
rise = cvGrSearchFall(J, delta);

% Horizontal edges
hor = cvGrSearchFall(R, delta);
rhor = imrotate(hor, -270);

% Output
O = fall|rise|rhor;