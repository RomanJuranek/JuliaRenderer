function [I,rs,is] = julia(sz, rect, c, cdir, nSamples, maxIter, fun)
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
[r,i] = meshgrid(rs,is); % Coordinates of individual pixels
d = (rs(2)-rs(1))/4; % Smoothing extent depends on pixel size

% Generate z and c for every pixel and sample
Z = complex(r,i); C = repmat(c,size(Z)); I = zeros(sz(2), sz(1), nSamples);

batch = 4;
for s = 1:batch:nSamples
    smps = s:min(s+batch-1,nSamples); ns = length(smps);
    Z1 = repmat(Z,1,1,ns); Z1 = Z1 + d*complex(randn(size(Z1),'single'),randn(size(Z1),'single'));
    C1 = repmat(C,1,1,ns); C1 = C1 + cdir * randn(size(C1));    
    Z2 = num2cell(Z1,1); C2 = num2cell(C1,1); % Split to workers
    ims = cell(1,numel(Z2));
    parfor i = 1:numel(Z2),ims{i}=renderElement(Z2{i},C2{i},maxIter,fun);end; % Do the job
    I(:,:,smps) = reshape(cell2mat(ims), sz(2), sz(1), []); % Get the resulting image
end

I = sum(I,3);

end

function n = renderElement(z, c, maxIter, fun)
n = repmat(maxIter,size(z));
for i = 1:numel(z)
    for j = 1:maxIter % Main loop
        z(i) = fun(z(i), c(i));
        if abs(z(i))>4,n(i)=j;break;end;
    end;
end
end