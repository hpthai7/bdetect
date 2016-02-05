function idx = cvZeroCross(I, thresh, direction)
if ndims(I) >= 3
    error('The input must be a two dimensional array.');
end
if ~exist('thresh', 'var') || isempty(thresh)
    thresh = 0;
end
if ~exist('direction', 'var') || isempty(direction)
    % all directions
    idx = cvZeroCross(I, thresh, 'horizontal');
    idx = idx | cvZeroCross(I, thresh, 'vertical');
    idx = idx | cvZeroCross(I, thresh, '45');
    idx = idx | cvZeroCross(I, thresh, '135');
    return;
end

if strcmp(direction, 'horizontal')
    mask = [0  0  0;
            -1  0  1;
            0  0  0];
elseif strcmp(direction, 'vertical')
    mask = [0  -1  0;
            0  0  0 ;
            0  1  0];
elseif strcmp(direction, '135')
    mask = [-1  0 0;
            0  0 0;
            0  0 1];
elseif strcmp(direction, '45')
    mask = [0  0  1;
            0  0  0;
           -1  0  0];
end

%% check if there is a change in sign
s = sign(I);
chkAbsEqual = cvConv2(s, mask, 'reflect');
grad = cvConv2(I, mask, 'reflect'); % getMaxPeak
idx = ((abs(chkAbsEqual) == 2) & (abs(grad) > 2*abs(I)));
% To consider 0 for changes in sign, use (abs(t) > 0)
%% thresholding
if thresh > 0
    idx = idx & (abs(grad) > thresh);
end