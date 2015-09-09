function [I1,rs,is] = julia(sz, rect, c, cdir, nSamples, maxIter, fun)
% Render julia fractal
%
%   [I,r,i] = julia(sz, rect, c, cdir, nSamples, maxIter, [fun])
%
% Inputs:
% sz       [1x2] size of image to render
% rect     [1x4] viewport coordinates [r1 r2 i1 i2]
% c        Complex scalar Julia parameter
% cdir     Complex scalar - direction in which change c. Makes nice
%          smoothing/motion blur effect with high number of samples
% nSamples # samples for each pixel
% maxIter  Max. number of iterations to render each pixel
% fun      Julia function. Default is @(z,c)z.^2+c
%
% Outputs:
% I        Image with the fractal
% r        Real coordinates of pixels
% i        Imaginary coordinates of pixels
%

% Julia function
if nargin<7, fun = @(z,c) z.^2+c; end;

% Viewport into Julia space
rs = single(linspace(rect(1),rect(2),sz(1)));
is = single(linspace(rect(3),rect(4),sz(2))); 
[r,i] = meshgrid(rs,is); Z = complex(r,i); % Coordinates of individual pixels
d = (rs(2)-rs(1))/4; % Smoothing extent depends on pixel size

% Generate z and c for every pixel and sample
Z = repmat(Z,1,1,nSamples);
Z = Z + d*complex(randn(size(Z),'single'),randn(size(Z),'single'));
C = repmat(c, size(Z)); C = C + cdir * randn(size(C));

% Split to workers
Z1 = num2cell(Z,1); C1 = num2cell(C,1);

% Do it!
parfor i = 1:numel(Z1),I{i}=arrayfun(@(z,c)renderElement(z,c,maxIter,fun),Z1{i},C1{i});end;

% Get the resulting image
I = reshape(I,size(Z1)); I1 = cell(1,size(I,3));
for i = 1:size(I,3),I1{i} = [I{:,:,i}]; end;
I1 = cat(3,I1{:}); I1 = mean(I1,3);

end

function n = renderElement(z, c, maxIter, fun)
n = maxIter;
for j = 1:maxIter % Main loop
    z = fun(z, c);
    if abs(z)>4,n=j;break;end;
end;
end