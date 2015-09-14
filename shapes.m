%%
N = 33;
[r,i] = meshgrid(linspace(-1.5,0.5,N),linspace(-1,1,N));
C = complex(r,i)';

%%
tic;
I = arrayfun(@(c)julia([32 32],[-1.2 1.2 -1.2 1.2], c, 0, 8, 100), C, 'uniformoutput', false);
t=toc;
I = cat(3,I{:});
fprintf('Rendered in %.2fs\n', t);

%%
prm.showLines = 0;
prm.mm = N;
prm.padEl = max(I(:));
prm.padAmt = 3;
h = montage2(I,prm); colormap(1-gray);
imwrite(h.CData/max(I(:))*256, 1-gray(256),'julia_shapes.png','png');