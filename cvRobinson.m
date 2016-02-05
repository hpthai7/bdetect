function O = cvRobinson(I, thresh, direction)
% cvRobinson - Robinson Filtering
%
% Synopsis
%   O = cvRobinson(I, [thresh], [direction])
%
% Description
%   Filtering using cvRobinson kernel
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
%   O = cvRobinson(I, 96, 'N');
%   figure; imshow(I);
%   figure; imshow(O);
%   O = cvRobinson(I, [], 'SW');
%   figure; imshow(uint8(cvuNormalize(O, [0, 255])));
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

if strcmp(direction, 'N')
    mask = [1	2	1;
				0	0	0;
				-1	-2	-1];
elseif strcmp(direction, 'NE')
    mask = [0	1	2;
				-1	0	1;
				-2 -1 0];
elseif strcmp(direction, 'E')
    mask = [-1	0	1;
				-2	0	2;
				-1	0	1];
elseif strcmp(direction, 'SE')
    mask = [-2	-1	0;
				-1	0	1;
				0	1	2];
elseif strcmp(direction, 'S')
    mask = [-1	-2	-1;
				0	0	0;
				1	2	1];
elseif strcmp(direction, 'SW')
    mask = [0	-1	-2;
				1	0	-1;
				2	1	0];
elseif strcmp(direction, 'W')
    mask = [1	0	-1;
				2	0	-2;
				1	0	-1];
elseif strcmp(direction, 'NW')
    mask = [1	2	0;
				1	0	-1;
				0	-1	-2];
end

[N, M, C] = size(I);
O = zeros(N, M, C);
for c = 1:C
    O(:,:,c) = cvConv2(I(:,:,c), mask, 'reflect');
end

O = abs(O);

if ~isempty(thresh)
	O = uint8(cvuNormalize(O, [0, 255]));
    if isscalar(thresh), thresh = repmat(thresh, 1, C); end;
    for c = 1:C
        O(:,:,c) = 255*(O(:,:,c) > thresh(c));
    end
end
end