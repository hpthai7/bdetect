function O = cvRobinsonLinking(I, gthresh, amplink, anglink)
% Description
%		Linking edges detected by Robinson compass operator
%
% Synopsis
%		O = cvRobinsonLinking(I, gthresh, amplink, anglink)
%
% Inputs ([]s are optional)
%   (matrix) I		N x M x C matrix representing the input image
%   (scalar) [gthresh = []]
%						The sensitivity threshold. Ignores all edges that are not stronger than gthresh. 
%						If empty([]) is given, no thresholding. Can be a 1 x C vector for a color image. 
%   (scalar) [amplink = []]
%						GradAmplitude difference for edge linking
%   (scalar) [anglink = []] radian
%						GradAngle difference for edge linking which should take k*pi/2
%
% Outputs ([]s are optional)
%		(matrix) O	N x M x C matrix representing the output.
%
% Examples
%		I = cvuImread('lena.bmp');
%		O = cvRobinsonLinking(I, [], [], []);
%		figure; imshow(O);
%		O = cvRobinsonLinking(I, 40, 30, pi);
%		figure; imshow(O);
%
% Requirements
%		cvRobinson (requires conv2)
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
    amplink = 5;
end
if ~exist('anglink', 'var') || isempty(anglink)
    anglink = pi;
end
if ~isa(I, 'double')
    I = double(I);
end

cN = cvRobinson(I, [], 'N');
cW = cvRobinson(I, [], 'W');
cS = cvRobinson(I, [], 'S');
cE = cvRobinson(I, [], 'E');
cNW = cvRobinson(I, [], 'NW');
cSW = cvRobinson(I, [], 'SW');
cSE = cvRobinson(I, [], 'SE');
cNE = cvRobinson(I, [], 'NE');

[N, M, C] = size(I);
S = zeros(N, M, C);
theta = zeros(N, M, C);
for c = 1:C
	for j = 1:M
		for i = 1:N
			temp = [cN(i, j, c) cW(i, j, c) cS(i, j, c) cE(i, j, c) cNW(i, j, c) cSW(i, j, c) cSE(i, j, c) cNE(i, j, c)];
			S(i, j, c) = max(temp);
			
			if (temp(1) == S(i, j, c))
				theta(i, j, c) = pi/2;
			elseif (temp(2) == S(i, j, c))
				theta(i, j, c) = pi;
			elseif (temp(3) == S(i, j, c))
				theta(i, j, c) = 3*pi/2;
			elseif (temp(4) == S(i, j, c))
				theta(i, j, c) = 0;
			elseif (temp(5) == S(i, j, c))
				theta(i, j, c) = 3*pi/4;
			elseif (temp(6) == S(i, j, c))
				theta(i, j, c) = 5*pi/4;
			elseif (temp(7) == S(i, j, c))
				theta(i, j, c) = 7*pi/4;
			elseif (temp(8) == S(i, j, c))
				theta(i, j, c) = pi/4;
			end
		end
	end
end
S = uint8(cvuNormalize(S, [0, 255]));

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
				if ((abs(theta(i,j,k)-theta(i,j+1,k)) <= anglink) & (fEd(i,j+1,k) > gthresh))
					Og(i,j+1,k) = 1;
				end
				if ((abs(theta(i,j,k)-theta(i,j-1,k)) <= anglink) & (fEd(i,j-1,k) > gthresh))
					Og(i,j-1,k) = 1;
				end
				if ((abs(theta(i,j,k)-theta(i+1,j,k)) <= anglink) & (fEd(i+1,j,k) > gthresh))
					Og(i+1,j,k) = 1;
				end
				if ((abs(theta(i,j,k)-theta(i-1,j,k)) <= anglink) & (fEd(i-1,j,k) > gthresh))
					Og(i-1,j,k) = 1;
				end
				if ((abs(theta(i,j,k)-theta(i-1,j-1,k)) <= anglink) & (fEd(i-1,j-1,k) > gthresh))
					Og(i-1,j-1,k) = 1;
				end
				if ((abs(theta(i,j,k)-theta(i+1,j+1,k)) <= anglink) & (fEd(i+1,j+1,k) > gthresh))
					Og(i+1,j+1,k) = 1;
				end
				if ((abs(theta(i,j,k)-theta(i-1,j+1,k)) <= anglink) & (fEd(i-1,j+1,k) > gthresh))
					Og(i-1,j+1,k) = 1;
				end
				if ((abs(theta(i,j,k)-theta(i+1,j-1,k)) <= anglink) & (fEd(i+1,j-1,k) > gthresh))
					Og(i+1,j-1,k) = 1;
				end
			end
		end
	end
end
O = 255*Oa.*Og;