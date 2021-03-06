function [u, Md] = roulette1(func, funcd, M, u0, s)
%
% roulette1.m, (c) Matthew Roughan, 2013
%
% created: 	Mon Nov 25 2013 
% author:  	Matthew Roughan 
% email:   	matthew.roughan@adelaide.edu.au
% 
% ROULETTE1 
%         Calculates the roulette of one curve with respect to the x-axis
%         See 
%            "The General Theory of Roulettes", Gordon Walker, National Mathematics Magazine,
%            Vol. 12, No.1, pp.21-26, 1937
%              http://www.jstor.org/stable/3028504
%
% INPUTS:
%         func = a function providing a parametric description of a curve 
%                i.e., points on the curve are defined by
%                         [x,y] = func(u)
%                it is presumed that the point u0 corresponds to the origin
%                and that the curve touches the origin at a tangent at this point
%
%         funcd = derivatives of the function with respect to u
%                    this is used to numerically calculate arclengths
%
%         M = the points we want to follow as the curve rolls
%                M = Nx2 array
%
%         u0 = parametric origin, i.e., we expect that
%                  x(u0) = 0
%                  y(u0) = 0
%                  dy/du(0) = 0   (the curve should be tangent to the x-axis at the origin)
%                  dx/du(0) ~= 0 
%
%         s = argument giving the points at which to calculate the roulette
%             in terms of distance along the curve
%         
% OUTPUTS:        
%         u  = parameters that give curve at the arclenths s
%         Md = [x_roulette, y_roulette] = a vector of points on the roulette
%         
%
%

% either
%     M is Nx2, N>1 and s is a scalar; or
%     M = 1x2, and s is a vector
if (size(M,2) ~= 2)
  error('M should be Nx2 for N points to be rolled');
end
if (size(M,1) > 1 & length(s) > 1)
  error(' either calculate for multiple points M, or multiple s, but not both');
end
p = M(:,1); 
q = M(:,2);
N = size(M,1);

s = s(:);
u = zeros(size(s));

% find points along the curve at distances s, where
%    s = arclength(funcd, u)
%    u = parameters that give arclengths from origin of s
options = optimset('MaxFunEvals', 1000);
for i=1:length(s)
  f = @(t) ( s(i) - arclength(funcd, u0, t) );
  u(i) = fzero(f, s(i), options);
end

% calculate points along the curve
points = func(u);
g = points(:,1);
G = points(:,2);

% calculate derivatives WRT u
derivatives = funcd(u);
dgdu = derivatives(:,1);
dGdu = derivatives(:,2);

% calculate derivatives WRT s, using the chain rule, and approximating
du = 1.0e-6;
duds = du ./ arclength(funcd, u, u+du);
dgds = dgdu .* duds';
dGds = dGdu .* duds';

% calculate the rolled points, when the rolling curve is a line
x =  (p-g).*dgds + (q-G).*dGds + s;
y = -(p-g).*dGds + (q-G).*dgds;
Md = [x, y];


