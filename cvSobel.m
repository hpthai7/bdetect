function O = cvSobel(I, thresh, direction)
% Description
%		Directional Sobel Edge Detection
%
% Synopsis
%		O = cvSobel(I, [thresh], [direction])
%
% Inputs ([]s are optional)
%		(matrix) I	N x M x C matrix representing the input image
%		(scalar) [thresh = []]
%						thresh in [0, 255]
%						The sensitivity threshold. Ignores all edges
%						that are not stronger than thresh. 
%						If empty([]) is given, no thresholding. 
%						Can be a 1 x C vector for a color image. 
%   (string) [direction = 'horizontal']
%						'horizontal' or 'vertical' or '45' or '135'.
%
% Outputs ([]s are optional)
%		(matrix) O       N x M x C matrix representing the output.
%
% Examples
%		I = cvuImread('lena.bmp');
%		figure; imshow(I);
%		O = cvSobel(I, 96, '45');
%		figure; imshow(O);
%		O = cvSobel(I, [], '45');
%		O = abs(O);
%		figure; imshow(uint8(cvuNormalize(O, [0, 255])));

if ~exist('direction', 'var') || isempty(direction)
    direction = '45';
end
if ~exist('thresh', 'var') || isempty(thresh)
    thresh = [];
end
if ~isa(I, 'double')
    I = double(I);
end

if strcmp(direction, 'horizontal')
    mask = [-1 -2 -1;
            0  0  0 ;
            1  2  1];
elseif strcmp(direction, 'vertical')
    mask = [-1 0 1;
            -2 0 2;
            -1 0 1];
elseif strcmp(direction, '135')
    mask = [0  1 2;
           -1  0 1;
           -2 -1 0];
elseif strcmp(direction, '45')
    mask = [-2 -1 0;
            -1  0 1;
             0  1 2];
end

[N, M, C] = size(I);
O = zeros(N, M, C);
for c = 1:C
    O(:,:,c) = cvConv2(I(:,:,c), mask, 'reflect');
end

% No thresholding then O is negative and unnormalized
if ~isempty(thresh)
	O = abs(O);
	O = uint8(cvuNormalize(O, [0, 255]));
    if isscalar(thresh), thresh = repmat(thresh, 1, C); end;
    for c = 1:C
        O(:,:,c) = 255*(O(:,:,c) > thresh(c));
    end
end
end