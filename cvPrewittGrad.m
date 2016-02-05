function P = cvGradPrewitt(I, thresh)
% Description
%   Prewitt Edge Detection with Gradient Combination of Vertical and Horizontal Operator
%
% Synopsis
%   S = cvGradPrewitt(I, [thresh])
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
%    (matrix) P       N x M x C matrix representing the output.
%
% Examples
%		I = cvuImread('lena.bmp');
%		P = cvPrewittGrad(I, 96);
%		figure; imshow(I);
%		figure; imshow(P);
%		P = cvPrewittGrad(I, []);
%		figure; imshow(P);
%
% Requirements
%		cvPrewitt (requires cvConv2)
%
% Authors
%		Thai Ho
%
% Changes
%		22/11/2011 First Edition

if ~exist('thresh', 'var') || isempty(thresh)
    thresh = [];
end

Ph = cvPrewitt(I, [], 'horizontal');
Pv = cvPrewitt(I, [], 'vertical');

[N, M, C] = size(I);
P = zeros(N, M, C);
P = abs(Ph) + abs(Pv);
P = uint8(cvuNormalize(P, [0, 255]));

% The threshold should be in [0, 255]
if ~isempty(thresh)
    if isscalar(thresh), thresh = repmat(thresh, 1, C); end;
    for c = 1:C
        P(:,:,c) = 255*(P(:,:,c) > thresh(c));
    end
end
end