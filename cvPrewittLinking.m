function O = cvPrewittLinking(I, gthresh, amplink, anglink)
% Description
%		Linking edges detected by Prewitt operator
%
% Synopsis
%		O = cvPrewittLinking(I, gthresh, amplink, anglink)
%
% Inputs ([]s are optional)
%   (matrix) I		N x M x C matrix representing the input image
%   (scalar) [gthresh = []]
%						The sensitivity threshold. Ignores all edges that are not stronger than gthresh. 
%						If empty([]) is given, no thresholding. Can be a 1 x C vector for a color image. 
%   (scalar) [amplink = []]
%						GradAmplitude difference for edge linking
%   (scalar) [anglink = []] radian
%						GradAngle difference for edge linking
%
% Outputs ([]s are optional)
%		(matrix) O	N x M x C matrix representing the output.
%
% Examples
%		I = cvuImread('lena.bmp');
%		O = cvPrewittLinking(I, [], [], []);
%		figure; imshow(O);
%		O = cvPrewittLinking(I, 40, 30, pi/3);
%		figure; imshow(O);
%
% Requirements
%		cvPrewitt (requires conv2)
%
% Authors
%		Thai Ho
%
% Changes
%		22/11/2011 First Edition

if ~exist('gthresh', 'var') || isempty(gthresh)
    gthresh = 10;
end
if ~exist('amplink', 'var') || isempty(amplink)
    amplink = 0;
end
if ~exist('anglink', 'var') || isempty(anglink)
    anglink = pi/32;
end
if ~isa(I, 'double')
    I = double(I);
end

Sh = cvPrewitt(I, [], 'horizontal');
Sv = cvPrewitt(I, [], 'vertical');

[N, M, C] = size(I);
S = zeros(N, M, C);
S = abs(Sh) + abs(Sv);
S = uint8(cvuNormalize(S, [0, 255]));
% Angle versus x-axis (horizontal)
agl = zeros(N, M, C);
agl = atan(Sh./Sv);

% Globally thresholded matrix of binary values. Global threshold should be in [0, 255]
B = zeros(N, M, C);
if ~isempty(gthresh)
    if isscalar(gthresh), gthresh = repmat(gthresh, 1, C); end;
    for c = 1:C
        B(:,:,c) = (S(:,:,c) > gthresh);
    end
end
B = uint8(B);
% Grayscale matrix after global thresholding
fEd = B.*S;

Oa = zeros(N, M, C); % binary amplitude-contrained matrix
Og = zeros(N, M, C); % binary angle-contrained matrix
O = zeros(N, M, C);

for k = 1:C
	for j = 2:(M-1)
		for i = 2:(N-1)
			if fEd(i,j,k) > gthresh
				if ((abs(fEd(i,j,k)-fEd(i,j+1,k)) <= amplink) & (fEd(i,j+1,k) > gthresh))
					Oa(i,j+1,k) = 1;
				end
				if ((abs(fEd(i,j,k)-fEd(i,j-1,k)) <= amplink) & (fEd(i,j-1,k) > gthresh))
					Oa(i,j-1,k) = 1;
				end
				if ((abs(fEd(i,j,k)-fEd(i+1,j,k)) <= amplink) & (fEd(i+1,j,k) > gthresh))
					Oa(i+1,j,k) = 1;
				end
				if ((abs(fEd(i,j,k)-fEd(i-1,j,k)) <= amplink) & (fEd(i-1,j,k) > gthresh))
					Oa(i-1,j,k) = 1;
				end
				if ((abs(fEd(i,j,k)-fEd(i-1,j-1,k)) <= amplink) & (fEd(i-1,j-1,k) > gthresh))
					Oa(i-1,j-1,k) = 1;
				end
				if ((abs(fEd(i,j,k)-fEd(i+1,j+1,k)) <= amplink) & (fEd(i+1,j+1,k) > gthresh))
					Oa(i+1,j+1,k) = 1;
				end
				if ((abs(fEd(i,j,k)-fEd(i-1,j+1,k)) <= amplink) & (fEd(i-1,j+1,k) > gthresh))
					Oa(i-1,j+1,k) = 1;
				end
				if ((abs(fEd(i,j,k)-fEd(i+1,j-1,k)) <= amplink) & (fEd(i+1,j-1,k) > gthresh))
					Oa(i+1,j-1,k) = 1;
				end
			end
		end
	end
end

for k = 1:C
	for j = 2:(M-1)
		for i = 2:(N-1)
			if fEd(i,j,k) > gthresh
				if ((abs(agl(i,j,k)-agl(i,j+1,k)) <= anglink) & (fEd(i,j+1,k) > gthresh))
					Og(i,j+1,k) = 1;
				end
				if ((abs(agl(i,j,k)-agl(i,j-1,k)) <= anglink) & (fEd(i,j-1,k) > gthresh))
					Og(i,j-1,k) = 1;
				end
				if ((abs(agl(i,j,k)-agl(i+1,j,k)) <= anglink) & (fEd(i+1,j,k) > gthresh))
					Og(i+1,j,k) = 1;
				end
				if ((abs(agl(i,j,k)-agl(i-1,j,k)) <= anglink) & (fEd(i-1,j,k) > gthresh))
					Og(i-1,j,k) = 1;
				end
				if ((abs(agl(i,j,k)-agl(i-1,j-1,k)) <= anglink) & (fEd(i-1,j-1,k) > gthresh))
					Og(i-1,j-1,k) = 1;
				end
				if ((abs(agl(i,j,k)-agl(i+1,j+1,k)) <= anglink) & (fEd(i+1,j+1,k) > gthresh))
					Og(i+1,j+1,k) = 1;
				end
				if ((abs(agl(i,j,k)-agl(i-1,j+1,k)) <= anglink) & (fEd(i-1,j+1,k) > gthresh))
					Og(i-1,j+1,k) = 1;
				end
				if ((abs(agl(i,j,k)-agl(i+1,j-1,k)) <= anglink) & (fEd(i+1,j-1,k) > gthresh))
					Og(i+1,j-1,k) = 1;
				end
			end
		end
	end
end

O = 255*Oa.*Og;