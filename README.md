# JuliaRenderer

![Shapes of Julia set](julia_shapes.png)
This image shows how the shape of julia set changes with different `c` parameter. Each cell corresponds to the image rendered with uniquie setting of `c` - see [`shapes.m`](shapes.m) for details.

The `julia` function renders a selected view of Julia fractal. It supports supersampling and motion blur-like effect (small changes of the fractal parmeter `c`). The implementation is brute force without any optimizations (except for parallelization using `parpool`).

![Demo image](julia.jpg)
This image was generated with the following command and post processed in Gimp. It took around one hour to render.

```matlab
I = julia([1920,1080], [0.3,0.55,-0.1906,-0.05], complex(-0.7411,0.15), complex(-0.0005,0.0002), 128, 500);
```

Run `help julia` to get more info.

Enjoy
