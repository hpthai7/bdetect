function O = cvPrewitt(I, thresh, direction)
% Description
%		Directional Prewitt Edge Detection
%
% Synopsis
%		O = cvPrewitt(I, [thresh], [direction])
%
% Inputs ([]s are optional)
%		(matrix) I	Nx M x C matrix representing the input image
%		(scalar) [thresh = []]
%						thresh in [0, 255]
%						The sensitivity threshold. Ignores all edges that are not stronger than thresh. 
%						If empty([]) is given, no thresholding. Can be a 1 x C vector for a color image. 
%		(string) [direction = 'horizontal']
%						'horizontal' or 'vertical' or '45' or '135'.
%
% Outputs ([]s are optional)
%		(matrix) O	N x M x C matrix representing the output.
%
% Examples
%		I = cvuImread('lena.bmp');
%		O = cvPrewitt(I, 96, '45');
%		figure; imshow(I);
%		figure; imshow(O);
%		O = cvPrewitt(I, [], '45');
%		O = abs(O);
%		figure; imshow(uint8(cvuNormalize(O, [0, 255])));
%
% Requirements
%		cvConv2 (requires conv2)

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
    mask = [-1 -1 -1;
            0  0  0 ;
            1  1  1];
elseif strcmp(direction, 'vertical')
    mask = [-1 0 1;
            -1 0 1;
            -1 0 1];
elseif strcmp(direction, '135')
    mask = [0  1 1;
           -1  0 1;
           -1 -1 0];
elseif strcmp(direction, '45')
    mask = [-1 -1 0;
            -1  0 1;
             0  1 1];
end

[N, M, C] = size(I);
O = zeros(N, M, C);
for c = 1:C
    O(:,:,c) = cvConv2(I(:,:,c), mask, 'reflect');
end

if ~isempty(thresh)
	O = abs(O);
	O = uint8(cvuNormalize(O, [0, 255]));
    if isscalar(thresh), thresh = repmat(thresh, 1, C); end;
    for c = 1:C
        O(:,:,c) = 255*(O(:,:,c) > thresh(c));
    end
end
end