function S = cvSobelGrad(I, thresh)
% Description
%		Sobel Edge Detection with Gradient Combination of Vertical and Horizontal Operator only
%
% Synopsis
%		S = cvSobelGrad(I, [thresh])
%
% Inputs ([]s are optional)
%		(matrix) I        N x M x C matrix representing the input image
%		(scalar) [thresh = []]
%                     The sensitivity threshold. For grayscale images, it ranges from 0 to 255.
%						Ignores all edges that are not stronger than thresh. 
%                     If empty([]) is given, no thresholding. Can be a 1 x C vector for a color image.
%
% Outputs ([]s are optional)
%		(matrix) O       N x M x C matrix representing the output.
%
% Examples
%		I = cvuImread('lena.bmp');
%		S = cvSobelGrad(I, 96);
%		figure; imshow(I);
%		figure; imshow(S);
%		S = cvSobelGrad(I, []);
%		figure; imshow(S);
%
% Requirements
%		cvSobel (requires conv2)
%
% Authors
%		Thai Ho
%
% Changes
%		22/11/2011 First Edition

if ~exist('thresh', 'var') || isempty(thresh)
    thresh = [];
end

Sh = cvSobel(I, [], 'horizontal');
Sv = cvSobel(I, [], 'vertical');

[N, M, C] = size(I);
S = zeros(N, M, C);
S = abs(Sh) + abs(Sv);
S = uint8(cvuNormalize(S, [0, 255]));

% The threshold should be in [0, 255]
if ~isempty(thresh)
    if isscalar(thresh), thresh = repmat(thresh, 1, C); end;
    for c = 1:C
        S(:,:,c) = 255*(S(:,:,c) > thresh(c));
    end
end
end