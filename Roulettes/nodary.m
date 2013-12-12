function [x,y, x_lim, y_lim] = nodary(a, b, theta)
%
% nodary.m, (c) Matthew Roughan, 2013
%
% created: 	Wed Nov 27 2013 
% author:  	Matthew Roughan 
% email:   	matthew.roughan@adelaide.edu.au
% 
% NODARY: roulette of a hyperbola's focus along a straight line
%         see http://en.wikipedia.org/wiki/Nodary
%               though there is currently a mistake see
%                  http://books.google.com.au/books?id=xb48zk0wJfIC&pg=PA148&lpg=PA148&dq=nodary+parametric+equation&source=bl&ots=RVXw0BYeRW&sig=47ZnhnNY3YtsnxWzw3lUoNdwPjY&hl=en&sa=X&ei=uX-VUqrLFKahige1pYGYCQ&ved=0CEMQ6AEwAw#v=onepage&q=nodary%20parametric%20equation&f=false
%
% INPUTS:
%         a, b = parameters of hyperbola   -x^2/a^2 + y^2/b^2 = 1
%         theta = vector of points along which to calculate it
%
% OUTPUTS:        
%         (x,y) = points along the nodary
%                     note these are 2xN vectors with one curve corresponding to each focus
%         x_lim = x values of 4 limiting points
%         y_lim = y_values of 4 limiting points
%

if (nargin < 1)
  a = 0.9; % default
end
if (nargin < 2)
  b = 1.7; % default
end
if (nargin < 3)
  theta = -30:0.1:30; % default
end
if (a<=0 | b<=0)
  error('a and b must be positive');
end
theta = theta(:); % convert to column vectors

% find out if elliptic integrals are available
common;

% swap a and b, because conventional derivations are all based on 
%   hyperbola being on its side, not upright
temp = b; 
b = a; 
a = temp;

k = cos(atan(b/a));
M = k^2;
e = sqrt(a^2 + b^2)/a;
f = a*e;
c = f;  % f and c just alternative names for focal length

% % solution from 
% %    Oprea, p.148
% %    or with correction: http://en.wikipedia.org/wiki/Nodary
% %    similar Forsyth, p.417 
% [F,E,Z] = elliptic12(pi/2,M)
% u = -F:0.01:F;
% [sn,cn,dn] = ellipj(u,M); 
% phi = asin(sn);
% % [F,E,Z] = elliptic12(u,M);
% [F,E,Z] = elliptic12(phi,M);
% x =  a*sn + (a/k)*( (1-M)*u - E );
% y = -a*cn + (a/k)*dn;

% figure(101)
% hold off
% plot(0,0)
% hold on
% plot(x, y)

% x =  a*sn - (a/k)*( (1-M)*u - E );
% y = -a*cn - (a/k)*dn;
% plot(x, y, 'x')

% % http://www.mathcurve.com/courbes2d/delaunay/delaunay.shtml
% %   NB: definition of elliptical integrals they are implicitly using implies
% %       we take [F,E,Z] = elliptic12(pi/2-theta, M);
% %   also have to swap the meanings of a and b at the moment
% c = sqrt(a^2 + b^2);
% e = c/a;
% k = 1/e
% M = k^2;
% [F,E,Z] = elliptic12(pi/2-theta, M);
% [Fc,Ec,Zc] = elliptic12(pi/2, M);
% ell = c*(Ec - E) - (b^2/a)*(Fc - F);
% tmp =  sqrt( (e-cos(theta)) ./ ( e+cos(theta)) ); 
% x = ell - a*sin(theta).* tmp;
% y = b*tmp;

% figure(101)
% plot(x,y,'r--'); 

% solution from Enrique Bendito, Mark J. Bowick and Agustin Medina, 
%   "Delaunay Surfaces", http://arxiv.org/abs/1305.5681
%   assuming a and b have been swapped around
t = theta / 3; 
g = @(z) sqrt(c^2*cosh(z).^2 - a^2);
ell = zeros(size(t));
if (elliptic_available)
  phi = atan(c*sinh(t)/b); % convert to coordinates used in calculating arclength
  [F,E,Z] = elliptic12(phi,M);
  ell = c*(sqrt(1-M*sin(phi).^2).*tan(phi) + (1-M)*F - E);
else
  for i=1:length(theta)
    ell(i) = quad(g, 0, t(i) );
  end
end

tmp = g(t);
x1 = ell - c*sinh(t).*(c*cosh(t) - a)./tmp;
x2 = ell - c*sinh(t).*(c*cosh(t) + a)./tmp; 
y1 =  b*(c*cosh(t) - a) ./ tmp;
y2 = -b*(c*cosh(t) + a) ./ tmp;
x = x2;
y = y2;
% figure(101)
% plot(x1,y1,'g--'); 
% plot(x2,y2,'g-'); 
x = [x1; x2]';
y = [y1; y2]';


% also compute limiting points for nodary
[Fc, Ec] = ellipke(M);
x_lim1 =  a + c*((1-M)*Fc - Ec);
x_lim2 = -a + c*((1-M)*Fc - Ec);
x_lim = [x_lim1 -x_lim1 x_lim2 -x_lim2];
y_lim = [b b -b -b];

