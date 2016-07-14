%%%%%%%%%%%%% start of code %%%%%%%%%%%%%%%%	
clc;
close all;
twiceSigmaSquared = 2.5;
amplitude = 100;
tic;
for x = 1:7
for y=1:7
for z=1:7
radiusSquared = (x-4)^2 + (y-4)^2 + (z-4)^2;
gaussKernel(x, y, z) = amplitude * exp(-radiusSquared/twiceSigmaSquared);
end
end
end
toc;
surf(gaussKernel) % Display it to command window.
%%%%%%%%%%%%%% end of code %%%%%%%%%%%%%%%%
