function O = cvKirschCompass(I, thresh)
% Description
%   Compass Operator using Kirsch kernel
%
% Synopsis
%   O = cvKirschCompass(I, [thresh], [direction])
%
% Inputs ([]s are optional)
%   (matrix) I        N x M x C matrix representing the input image
%   (scalar) [thresh = []]
%                     The sensitivity threshold. Ignores all edges
%                     that are not stronger than thresh. 
%                     If empty([]) is given, no thresholding. 
%                     Can be a 1 x C vector for a color image. 
%
% Outputs ([]s are optional)
%    (matrix) O       N x M x C matrix representing the output.
%
% Examples
%   I = cvuImread('cube.bmp');
%   O = cvKirschCompass(I, 96);
%   figure; imshow(I);
%   figure; imshow(O);
%   O = cvKirschCompass(I, []);
%   figure; imshow(O);
%
%
% Requirements
%   cvKirsch (requires cvConv2)

% Authors
%   Thai Ho
%
% Changes
%   22/11/2011 First Edition

if ~exist('thresh', 'var') || isempty(thresh)
    thresh = [];
end

cN = cvKirsch(I, [], 'N');
cW = cvKirsch(I, [], 'W');
cS = cvKirsch(I, [], 'S');
cE = cvKirsch(I, [], 'E');
cNW = cvKirsch(I, [], 'NW');
cSW = cvKirsch(I, [], 'SW');
cSE = cvKirsch(I, [], 'SE');
cNE = cvKirsch(I, [], 'NE');

[N, M, C] = size(I);
O = zeros(N, M, C);

for c = 1:C
	for j = 1:M
		for i = 1:N
			temp = [cN(i, j, c) cW(i, j, c) cS(i, j, c) cE(i, j, c) cNW(i, j, c) cSW(i, j, c) cSE(i, j, c) cNE(i, j, c)];
			O(i, j, c) = max(temp);
		end
	end
end

O = uint8(cvuNormalize(O, [0, 255]));

if ~isempty(thresh) % thresh in [0, 255]
    if isscalar(thresh), thresh = repmat(thresh, 1, C); end;
    for c = 1:C
        O(:,:,c) = 255*(O(:,:,c) > thresh(c));
    end
end
end