function O = cvKirsch(I, thresh, direction)
% cvKirsch - Kirsch Filtering
%
% Synopsis
%   O = cvKirsch(I, [thresh], [direction])
%
% Description
%   Filtering using Kirsch kernel
%
% Inputs ([]s are optional)
%   (matrix) I        N x M x C matrix representing the input image
%   (scalar) [thresh = []]
%                     The sensitivity threshold. Ignores all edges
%                     that are not stronger than thresh. 
%                     If empty([]) is given, no thresholding. 
%                     Can be a 1 x C vector for a color image. 
%   (string) [direction = 'horizontal']
%						'N' or 'W' or 'S' or 'E' or 'NW' or 'SW' or 'SE' or 'NE'
%
% Outputs ([]s are optional)
%    (matrix) O       N x M x C matrix representing the output.
%
% Examples
%   I = cvuImread('cube.bmp');
%   O = cvKirsch(I, 96, 'N');
%   figure; imshow(I);
%   figure; imshow(O);
%   O = cvKirsch(I, [], 'SW');
%
%
% Requirements
%   cvConv2 (requires conv2)

% Authors
%   Thai Ho
%
% Changes
%   22/11/2011 First Edition

if ~exist('direction', 'var') || isempty(direction)
    direction = 'N';
end
if ~exist('thresh', 'var') || isempty(thresh)
    thresh = [];
end
if ~isa(I, 'double')
    I = double(I);
end

if strcmp(direction, 'E')
    mask = [-3	-3 5;
				-3 0 5;
				-3 -3 5];
elseif strcmp(direction, 'NE')
    mask = [-3 5 5;
				-3 0 5;
				-3 -3 -3];
elseif strcmp(direction, 'N')
    mask = [5 5 5;
				-3 0 -3;
				-3 -3 -3];
elseif strcmp(direction, 'NW')
    mask = [5 5 -3;
				5 0 -3;
				-3 -3 -3];
elseif strcmp(direction, 'W')
    mask = [5 -3 -3;
				5 0 -3;
				5 -3 -3];
elseif strcmp(direction, 'SW')
    mask = [-3 -3 -3;
				5 0 -3;
				5 5 -3];
elseif strcmp(direction, 'S')
    mask = [-3 -3 -3;
				-3 0 -3;
				5 5 5];
elseif strcmp(direction, 'SE')
    mask = [-3 -3 -3;
				-3 0 5;
				-3 5 5];
end

[N, M, C] = size(I);
O = zeros(N, M, C);
for c = 1:C
    O(:,:,c) = cvConv2(I(:,:,c), mask, 'reflect');
end

O = abs(O);

% This threshold is inconsistent because the filtered imaged above
% because its components may surge above 255.
% Use within suitable range.
if ~isempty(thresh)
	O = uint8(cvuNormalize(O, [0, 255]));
    if isscalar(thresh), thresh = repmat(thresh, 1, C); end;
    for c = 1:C
        O(:,:,c) = 255*(O(:,:,c) > thresh(c));
    end
end
end