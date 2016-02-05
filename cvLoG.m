% Description
%   LoG (Laplacian of Gaussian) Edge Detection. 
%   Analytically, same with cvGaussFilter2 -> cvLaplacian. 
%
% Synopsis
%   O = cvLoG(I)
%
% Inputs ([]s are optional)
%   (matrix) I        N x M x C matrix representing the input image
%   (scalar) [thresh = []]
%                     The sensitivity threshold of zero-crossing. If empty([]), no zero-crossing detection.
%                     If 0, only changes in sign is considered for zero-crossing. 
%                     For others, the strength of zero-crossing is also considered and ignores all edges that are not 
%                     stronger than thresh. Can be a 1 x C vector for a color image. 
%
% Outputs ([]s are optional)
%   (matrix) O        N x M x C matrix representing the output.
%
% Examples
%   I = cvuImread('lena.bmp');
%   figure; imshow(I);
%   O = cvLoG(I, 50);
%   figure; imshow(O);
%   O = cvLoG(I);
%   figure; imshow(uint8(cvuNormalize(O, [0, 255])));
%
% Requirements
%   cvConv2 (requires conv2), cvZeroCross2
%
% To Do
%   supports arbitrary filter size \sigma. 
function O = cvLoG(I, thresh)
if ~exist('thresh', 'var') || isempty(thresh)
    thresh = [];
end
if ~isa(I, 'double')
    I = double(I);
end

%mask = -fspecial('log', [5 5], 2);
mask = [0 0 -1 0 0;
    0 -1 -2 -1 0;
    -1 -2 16 -2 -1;
    0 -1 -2 -1 0;
    0 0 -1 0 0];

[N, M, C] = size(I);
O = zeros(N, M, C);
O = double(O);

for c = 1:C
    O(:,:,c) = cvConv2(I(:,:,c), mask, 'reflect');
end

if ~isempty(thresh)
    if isscalar(thresh), thresh = repmat(thresh, 1, C); end;
    for c = 1:C
        O(:,:,c) = cvZeroCross2(O(:,:,c), thresh(c));
    end
    O = double(O);
end