clc;
clear all;

typv = input('Choose the window\n 1 for Roberts\n 2 for Prewitt\n 3 for Sobel\n 4 for Comparison of Gradients\n 5 for Comparison of Linking\n ');

filename = input('Enter an image name\n 1 for clown.bmp\n 2 for coins.png\n 3 for cube.bmp\n 4 for house.jpg\n 5 for lena.bmp\n 6 for utensil.jpg\n 7 for vessel.jpg\n 8 for wheel.bmp\n 9 for helloworld.gif\n 0 for blurred helloworld.gif\n ', 's');

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
elseif (filename == '0')
	filename = 'hello.gif';
end

I = cvuImread(filename);

scheme = input('Choose (thresh, deltaA, deltaP) [1..5 or 10..50]:\n 1 for (20, 10, pi/4)\n 10 for (20, 20, pi/2)\n 2 for (50, 10, pi/4)\n 20 for (50, 10, pi/2)\n 3 for (80, 10, pi/4)\n 30 for (80, 20, pi/2)\n 4 for (120, 10, pi/4)\n 40 for (120, 20, pi/2)\n 5 for (150, 10, pi/4)\n 50 for (150, 20, pi/2)\n 0 for manual input\n ');

if (scheme == 1)
	gthresh1 = 20;
	amplink1 = 10;
	anglink1 = pi/4;
elseif (scheme == 10)
	gthresh1 = 20;
	amplink1 = 20;
	anglink1 = pi/2;
elseif (scheme == 2)
	gthresh1 = 50;
	amplink1 = 10;
	anglink1 = pi/4;
elseif (scheme == 20)
	gthresh1 = 50;
	amplink1 = 20;
	anglink1 = pi/2;
elseif (scheme == 3)
	gthresh1 = 80;
	amplink1 = 10;
	anglink1 = pi/4;
elseif (scheme == 30)
	gthresh1 = 80;
	amplink1 = 20;
	anglink1 = pi/2;
elseif (scheme == 4)
	gthresh1 = 120;
	amplink1 = 10;
	anglink1 = pi/4;
elseif (scheme == 40)
	gthresh1 = 120;
	amplink1 = 20;
	anglink1 = pi/4;
elseif (scheme == 5)
	gthresh1 = 150;
	amplink1 = 10;
	anglink1 = pi/4;
elseif (scheme == 50)
	gthresh1 = 150;
	amplink1 = 20;
	anglink1 = pi/2;
else
	gthresh1 = input('Thresh = ');
	amplink1 = input('Amplitude difference = ');
	anglink1 = input('Angle difference = ');
end
	
if (typv == 1)
	% Roberts
	FR0 = subplot(1,2,1);
	R0 = cvRobertsGrad(I, []);
	imshow(R0);
	title('Roberts no thresh');

	FR1 = subplot(1,2,2);
	R1 = cvRobertsLinking(I, gthresh1, amplink1, anglink1);
	imshow(R1);
	title(['Roberts thresh = ' num2str(gthresh1) ', \DeltaA = ' num2str(amplink1) ', \Delta\theta = ' num2str(anglink1*180/pi) '\circ']);
elseif (typv == 2)
	% Prewitt
	FP0 = subplot(1,2,1);
	P0 = cvPrewittGrad(I, []);
	imshow(P0);
	title('Prewitt no thresh');

	FP1 = subplot(1,2,2);
	P1 = cvPrewittLinking(I, gthresh1, amplink1, anglink1);
	imshow(P1);
	title(['Prewitt thresh = ' num2str(gthresh1) ', \DeltaA = ' num2str(amplink1) ', \Delta\theta = ' num2str(anglink1*180/pi) '\circ']);
elseif (typv == 3)
	% Sobel
	FS0 = subplot(1,2,1);
	S0 = cvSobelGrad(I, []);
	imshow(S0);
	title('Sobel no thresh');

	FS1 = subplot(1,2,2);
	S1 = cvSobelLinking(I, gthresh1, amplink1, anglink1);
	imshow(S1);
	title(['Sobel thresh = ' num2str(gthresh1) ', \DeltaA = ' num2str(amplink1) ', \Delta\theta = ' num2str(anglink1*180/pi) '\circ']);
elseif (typv == 4)
	% Roberts
	FR0 = subplot(1,3,1);
	R0 = cvRobertsGrad(I, []);
	imshow(R0);
	title('Roberts no thresh');

	% Prewitt
	FP0 = subplot(1,3,2);
	P0 = cvPrewittGrad(I, []);
	imshow(P0);
	title('Prewitt no thresh');

	% Sobel
	FS0 = subplot(1,3,3);
	S0 = cvSobelGrad(I, []);
	imshow(S0);
	title('Sobel no thresh');
elseif (typv == 5)
	% Roberts
	FR1 = subplot(1,3,1);
	R1 = cvRobertsLinking(I, gthresh1, amplink1, anglink1);
	imshow(R1);
	title(['Roberts thresh = ' num2str(gthresh1) ', \DeltaA = ' num2str(amplink1) ', \Delta\theta = ' num2str(anglink1*180/pi) '\circ']);
	
	% Prewitt
	FP1 = subplot(1,3,2);
	P1 = cvPrewittLinking(I, gthresh1, amplink1, anglink1);
	imshow(P1);
	title(['Prewitt thresh = ' num2str(gthresh1) ', \DeltaA = ' num2str(amplink1) ', \Delta\theta = ' num2str(anglink1*180/pi) '\circ']);

	% Sobel
	FS1 = subplot(1,3,3);
	S1 = cvSobelLinking(I, gthresh1, amplink1, anglink1);
	imshow(S1);
	title(['Sobel thresh = ' num2str(gthresh1) ', \DeltaA = ' num2str(amplink1) ', \Delta\theta = ' num2str(anglink1*180/pi) '\circ']);
end

figure; imshow(I);
title('Original image');