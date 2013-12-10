%
% arclength_test.m, (c) Matthew Roughan, 2013
%
% created: 	Mon Nov 25 2013 
% author:  	Matthew Roughan 
% email:   	matthew.roughan@adelaide.edu.au
% 
% ARCLENGTH_TEST 
%
% tests of ellipse and hyperbola lengths need incomplete elliptical integrals
%    http://code.google.com/p/elliptic/
path(path,'/home/mroughan/src/matlab/elliptic')


% 
% start with a circle
% 
fprintf('\n\ncircle\n');
a = 2;
b = 2;
parameters = [0, b, a, b]; 
theta = 0:pi/100:2*pi;
points = ellipse(parameters, theta);
x = points(:,1);
y = points(:,2);
figure(1) 
hold off
plot(x, y);
axis equal


theta = -pi:pi/10:pi;
points = ellipse(parameters, theta);
x = points(:,1);
y = points(:,2);
hold on
plot(x,y, 'ro')

D = ellipsed(parameters, theta);
dx = D(:,1);
dy = D(:,2);
plot([x, x+dx]', [y, y+dy]', 'r');


for i=1:length(theta)
  points = ellipse(parameters, theta(i));
  x = points(:,1);
  y = points(:,2);
  g = @(t) ellipsed(parameters, t);
  s = arclength(g, -pi/2, theta(i));
  fprintf('theta/2pi = %.2f,  s/2pi = %.2f\n', theta(i)/(2*pi), s/(2*pi))
  text(x,y, sprintf('s/2pi = %.2f', s/(2*pi)))
end

% 
% now an ellipse
%
fprintf('\n\nellipse\n');
a = 2;
b = 1;
e = sqrt(a^2 - b^2)/a; % eccentricity
parameters = [0, b, a, b]; 
theta = 0:pi/100:2*pi;
points = ellipse(parameters, theta);
x = points(:,1);
y = points(:,2);
figure(2) 
hold off
plot(x, y);
axis equal


theta = -pi:pi/10:pi;
points = ellipse(parameters, theta);
x = points(:,1);
y = points(:,2);
hold on
plot(x,y, 'ro')

D = ellipsed(parameters, theta);
dx = D(:,1);
dy = D(:,2);
plot([x, x+dx]', [y, y+dy]', 'r');

% calculate the arclengths of an ellipse directly using elliptical integrals of the second type
k = e;
M = k^2;
[k, e] = ellipke(M); % = elliptic12(pi/2,M)

% this is if theta is angle to z-axis
% [F,E,Z] = elliptic12(pi/2 - theta,M);
% ell = a*(e - E); % the arclength along the ellipse, from the semi-major axis

% this is angle to negative y-axis
[F,E,Z] = elliptic12(theta + pi/2,M);
ell = a*E; % the arclength along the ellipse, from the semi-minor axis

for i=1:length(theta)
  points = ellipse(parameters, theta(i));
  x = points(:,1);
  y = points(:,2);
  g = @(t) ellipsed(parameters, t);
  s = arclength(g, -pi/2, theta(i));
  fprintf('theta/pi = %.1f, s_m = %.2f, s_t = %.2f\n', theta(i)/pi, s, ell(i));
  text(x,y, sprintf('s/2pi = %.2f', s));
end

% 
% now try a parabola
% 
fprintf('\n\nparabola\n');
x0 = 1;    % axis of symmetry is y-axis
f  = 1.25; % focal length
y0 = 0;    % vertex at the origin
parameters = [x0, y0, f];
x = -4:0.001:4;
[points, s] = parabola(parameters, x);
y = points(:,2);
focus_x = x0;
focus_y = y0 + f;

figure(3);
hold off
plot(x,y);
hold on
plot(focus_x, focus_y, 'o');
plot([x0 focus_x], [y0 focus_y], '--', 'linewidth', 2);
axis equal

for i=-5:5
  [mn,k] = min(abs(s - i));
  plot(x(k), y(k), 'ro');
  s2 = arclength(@(x) parabolad(parameters, x), x0, x(k));
  fprintf('s1 = %.2f,  s2 = %.2f\n', i, s2);
  text(x(k),y(k), sprintf('s = %.2f', s2));
end


% 
% now try a hyperbola
% 
fprintf('\n\nhyperbola\n');
a = 1;
b = 2.5;
parameters = [0, -b, a, b];
e = sqrt(a^2 + b^2)/b; % eccentricity
c = b*e; % distance from centre to focus
focal = c - b; % focal length, which gives y coordinate of focal point
parameters = [0, -b, a, b]; 
mu = -10:0.1:10;
points = hyperbola(parameters, mu);
x = points(:,1);
y = points(:,2);
figure(4) 
hold off
plot(x, y);
axis equal

% under current parameterisation, mu>=1
mu = -10:1:10;
points = hyperbola(parameters, mu);
x = points(:,1);
y = points(:,2);
hold on
plot(x,y, 'ro')

D = hyperbolad(parameters, mu);
dx = D(:,1);
dy = D(:,2);
plot([x, x+dx]', [y, y+dy]', 'r');

% theoretical arclengths for a hyperbola, Eagle, pp.271-2
phi = atan(x*c/a^2);
M = b^2/c^2;
[F,E,Z] = elliptic12(phi,M);
s_theory = c*(sqrt(1-M*sin(phi).^2).*tan(phi) + (1-M)*F - E);

for i=1:length(mu)
  points = hyperbola(parameters, mu(i));
  x = points(:,1);
  y = points(:,2);
  g = @(t) hyperbolad(parameters, t);
  s = arclength(g, 0, abs(mu(i)))*sign(mu(i));
  fprintf('scaled s = %.2f and s_theory=%.2f\n', 2*s/c, 2*s_theory(i)/c)
  text(x,y, sprintf('s = %.2f', 2*s/c));
end
% lengths are scaled so that dmu=1, asymptotically corresponds to 2 ds/c=1


