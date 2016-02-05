function O = cvGrSearchFall(I, delta)
% cvGrSearchFall - Image Boundary Detection
%
% Synopsis
%		O = cvGrSearchFall(I, [delta])
%
% Description
%		Image Boundary Detection via Graph-Theoretic Techniques
%		One-sided solution: cost c(p, q) = H - (f(p) - f(q)) for finding
%		FALLING edge only
% Inputs ([]s are optional)
%   (matrix) I		MxN matrix representing the input image
%   (scalar) [delta = []]
%						Sensitivity threshold. Ignores all edges whose
%						difference of upper and lower bound is less than delta. 
%						If empty([]) is given, take the default value 50.
%
% Outputs ([]s are optional)
%		(matrix) O	MxN matrix representing the output.
%
% Examples
%		I = cvuImread('world.gif');
%		O = cvGrSearchFall(I)
%		figure; imshow(I);
%		figure; imshow(O);
%		O = cvGrSearchFall(I, 80);
%		figure; imshow(I);
%
% See also
%		Digital Image Processing by Gonzalez, page 591
%		edge (edge.m does thining lines too)
%
% Authors
%		Thai Ho
%
% Changes
%		28/11/2011 First Edition

if ~exist('delta', 'var') || isempty(delta)
    delta = 50;
end

[M, N] = size(I);
H = max(max(I));

% ACKNOWLEDGEMENT:
% A vertical edge lies between two contiguous points I(i, j) and I(i, j+1),
% so that we consider it goes through the later point.
% A horizontal edge lies between two contiguous points I(i, j) and I(i+1, j),
% we consider it goes through the lower point.

% Temporary matrix for finding FALLING edge (thresh < H-delta)
temp = zeros(2*M-1, 3*N-3);
% Green points
for i = 1:2:(2*M-1)
	for j = 2:3:(3*N-4)
		temp(i, j) = H - I((i+1)/2, (j+1)/3) + I((i+1)/2, (j+1)/3+1);
	end
end
% Blue-circled points (edge is navigating left (observer's LHS))
for i = 2:2:(2*M-2)
	for j = 1:3:(3*N-5)
		temp(i, j) = H - I(i/2, (j+2)/3) + I(i/2+1, (j+2)/3);
	end
end
% Red-circled points (edge is navigating right)
for i = 2:2:(2*M-2)
	for j = 3:3:(3*N-3)
		temp(i, j) = H - I(i/2+1, j/3+1) + I(i/2, j/3+1);
	end
end
O = zeros(M, N);
% pseudo-image matrix 'temp'
%			j = 1		2		3		4		5		6		7		8		9		10		11		12
% i = 1				8				  (p, q) = 2					7
% i = 2		8				6		8				6		5				3
% i = 3				7						0						1
% i = 4		8		0		13		1				5		9				4
% i = 5				1						8						5
% Find plunge in data
for i = 1:2:(2*M-1)
	for j = 5:3:(3*N-7)
		m = i; p = i;
		n = j; q = j;
		
		% from (p, q) compare the value (2) to the next ones (eg. 8 & 7)
		array = [temp(m, n) temp(m, n-3) temp(m, n+3)];
		
		% if it is not the smallest, pass to the next 'for' iteration
		if (O((m+1)/2 ,(n+1)/3+1) == 0 && temp(m, n) ~= min(array))
			continue;
		end
		
		% this is to ensure that a single isolated horizontal thin line can be detected
		if (temp(m, n) <= H - delta && p <= 2*M-1 && q < 3*N-3)
			O((m+1)/2 ,(n+1)/3+1) = 1;
		end
		
		% forming the edge trees
		while temp(p, q) <= H - delta && p <= 2*M-1 && q < 3*N-3
			% mark the point in the output image as an edgepoint
			% fprintf('p = %d, q = %d\n', p, q);
			O((p+1)/2 ,(q+1)/3+1) = 1;
			if (p == 2*M-1)
				break;
			end

			% compare three possible directions
			arr = [temp(p+1, q-1) temp(p+2, q) temp(p+1, q+1)];
			mArr = min(arr);

			% go down straight
			if (arr(2) == mArr)
				p = p + 2;
			% go left until the edge goes down
			elseif (arr(1) == mArr)
				[idx, np, nq] = cvGrSearchLeft(O, temp, p, q);
				O = O|idx;
				p = np; q = nq;
			% go right until the edge goes down
			elseif (arr(3) == mArr)
				[idx, np, nq] = cvGrSearchRight(O, temp, p, q);
				O = O|idx;
				p = np; q = nq;
			end
		end	
	end
end