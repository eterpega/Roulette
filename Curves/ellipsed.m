function derivatives = ellipsed(parameters, theta)
%
% ellipsed.m, (c) Matthew Roughan, 2013
%
% created: 	Mon Nov 25 2013 
% author:  	Matthew Roughan 
% email:   	matthew.roughan@adelaide.edu.au
% 
% ELLIPSED calculates the slopes of tangents to the ellipse.m
%
% INPUTS:
%         parameters = [x0, y0, a, b]
%             (x0, y0) = centre
%             (a, b)   = semi-major, and semi-minor axes
%                          a > b         
%         theta        = angles (Nx1 column vector)
%
% OUTPUTS:      
%         derivatives = Nx2 vector of derivatives at points 
%                        [dx,dy] = are derivatives WRT theta at the points on the ellipse
%         
%
%

% check inputs
theta = theta(:);  % make it a column vector
if (length(parameters) < 4)
  error('error parameters = [x0, y0, a, b]');
end
x0 = parameters(1);
y0 = parameters(2);
a = parameters(3);
b = parameters(4);
if (b <= 0 | a < b)
  error('error: should have a >= b > 0');
end

%  calculate the derivatives
dx = -a*sin(theta);
dy =  b*cos(theta);
derivatives = [dx, dy];



