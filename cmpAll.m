clc;
clear all;
close all;

filename = input('Enter an image name\n 1 for clown.bmp\n 2 for coins.png\n 3 for cube.bmp\n 4 for house.jpg\n 5 for lena.bmp\n 6 for utensil.jpg\n 7 for vessel.jpg\n 8 for wheel.bmp\n 9 for helloworld.gif\n 10 for noise.gif\n 0 for blurred helloworld.gif\n ', 's');

if (filename == '1')
	filename = 'clown.bmp';
elseif (filename == '2')
	filename = 'coins.png';
elseif (filename == '3')
	filename = 'cube.bmp';
elseif (filename == '4')
	filename = 'house.jpg';
elseif (filename == '5')
	filename = 'lena.bmp';
elseif (filename == '6')
	filename = 'utensil.jpg';
elseif (filename == '7')
	filename = 'vessel.jpg';
elseif (filename == '8')
	filename = 'wheel.bmp';
elseif (filename == '9')
	filename = 'world.gif';
elseif (filename == '10')
	filename = 'noise.gif';
elseif (filename == '0')
	filename = 'hello.gif';
end

scheme = input('Choose (thresh, deltaA, deltaP) for gradient operators [0..9]:\n 1 for (20, 10, pi/4)\n 2 for (25, 10, pi/4)\n 3 for (30, 10, pi/4)\n 4 for (35, 10, pi/4)\n 5 for (40, 10, pi/4)\n 6 for (60, 10, pi/4)\n 7 for (80, 10, pi/4)\n 8 for (100, 10, pi/4)\n 9 for (120, 10, pi/4)\n 0 for manual input\n ');

if (scheme == 1)
	thresh = 20;
	amplink = 10;
	anglink = pi/4;
elseif (scheme == 2)
	thresh = 25;
	amplink = 10;
	anglink = pi/4;
elseif (scheme == 3)
	thresh = 30;
	amplink = 10;
	anglink = pi/4;
elseif (scheme == 4)
	thresh = 35;
	amplink = 10;
	anglink = pi/4;
elseif (scheme == 5)
	thresh = 40;
	amplink = 10;
	anglink = pi/4;
elseif (scheme == 6)
	thresh = 60;
	amplink = 10;
	anglink = pi/4;
elseif (scheme == 7)
	thresh = 80;
	amplink = 10;
	anglink = pi/4;
elseif (scheme == 8)
	thresh = 100;
	amplink = 10;
	anglink = pi/4;
elseif (scheme == 9)
	thresh = 120;
	amplink = 10;
	anglink = pi/4;
elseif (scheme == 0)
	thresh = input('thresh = ');
	amplink = input('Amplitude Difference = ');
	anglink = input('Angular Difference = ');
end

sigma = input('Gaussian smoothing for LoG, standard deviation sigma = ');
I = cvuImread(filename);
figure; imshow(I);
title('Original image');

% Roberts
R0 = cvRobertsGrad(I, []);
figure; imshow(R0);
title('Roberts no thresholding');

% Roberts
R1 = cvRobertsLinking(I, thresh, amplink, anglink);
figure; imshow(R1);
title(['Roberts thresh = ' num2str(thresh) ', \DeltaA = ' num2str(amplink) ', \Delta\theta = ' num2str(anglink*180/pi) '\circ']);

% Prewitt
P0 = cvPrewittGrad(I, []);
figure; imshow(P0);
title('Prewitt no thresholding');

% Prewitt
P1 = cvPrewittLinking(I, thresh, amplink, anglink);
figure; imshow(P1);
title(['Prewitt thresh = ' num2str(thresh) ', \DeltaA = ' num2str(amplink) ', \Delta\theta = ' num2str(anglink*180/pi) '\circ']);

% Sobel
S0 = cvSobelGrad(I, []);
figure; imshow(S0);
title('Sobel no thresholding');

% Sobel
S1 = cvSobelLinking(I, thresh, amplink, anglink);
figure; imshow(S1);
title(['Sobel thresh = ' num2str(thresh) ', \DeltaA = ' num2str(amplink) ', \Delta\theta = ' num2str(anglink*180/pi) '\circ']);

% Kirsch
K0 = cvKirschCompass(I, []);
figure; imshow(K0);
title('Kirsch no thresholding');

% Kirsch
K1 = cvKirschLinking(I, thresh, amplink, anglink);
figure; imshow(K1);
title(['Linked Kirsch thresh = ' num2str(thresh) ', \DeltaA = ' num2str(amplink) ', \Delta\theta = ' num2str(anglink*180/pi) '\circ']);

% Robinson
B0 = cvRobinsonCompass(I, []);
figure; imshow(B0);
title('Robinson no thresholding');

% Robinson
B1 = cvRobinsonLinking(I, thresh, amplink, anglink);
figure; imshow(B1);
title(['Linked Robinson thresh = ' num2str(thresh) ', \DeltaA = ' num2str(amplink) ', \Delta\theta = ' num2str(anglink*180/pi) '\circ']);

% Laplacian
L0 = cvLaplacian(I, thresh);
figure; imshow(L0);
title(['Laplacian with zero-cross thresh = ' num2str(thresh)]);

% LoGs
L1 = cvLoGs(I, thresh, 9, sigma);
figure; imshow(L1);
title(['LoGs with zero-cross thresh = ' num2str(thresh) ' and sigma = ' num2str(sigma)]);

% Graph-theoretic search
fprintf('Choose delta = 0 to cancel graph-theoretic search.\n');
delta = input('delta = ');
if (delta > 0)
	O = cvGrSearch(I, delta);
	figure; imshow(O);
	title('Graph-theoretic searched image');
end