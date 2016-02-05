function [idx, np, nq] = cvGrSearchRight(Z, temp, p, q)
%
% Identifying a right-traversing horizontal edge
%
% Description: keep traveling along a horizontal edge until its direction changes
%
% Input:
%		Z [MxN]
%				token matrix used to obtain the dimension
%		temp [(2M-1)x(3N-3)]
%				temporary pseudo-image matrix
%		p & q [scalar]
%				position on matrix 'temp' from which we want to traverse right
% Output:
%		idx [MxN]
%				output image composed of {0, 1} representing the position of
%				the horizontal edge
%		np & nq [scalar]
%				pseudo-image matrix position at which the horizontal edge ends
%				or changes its direction (to vertical, sort of)

[M, N] = size(Z);
[tM, tN] = size(temp);
idx = zeros(M, N);

% right traversal position - the horizontal edge keeps extending
m0 = p+1; n0 = q+4;

% supposed-to-be ending position
ms = p+2; ns = q+3;

% Acknowledge lower points in the output image to be on the edge
% when the edge travels horizontally between two points (lower and upper)
while (temp(m0, n0) < temp(ms, ns) && n0 <= tN-4)
	idx((p+1)/2+1, (ns+1)/3+1) = 1;
	n0 = n0+3;
	ns = ns+3;
end

% ending point
idx((p+1)/2+1, (ns+1)/3+1) = 1;
np = p+2; nq = ns;
end