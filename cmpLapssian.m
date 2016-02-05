clc;
clear all;

typv = input('Choose the window\n 1 for Laplacian\n 2 for LoG\n 3 LoGs\n 4 for Comparison of Zero Crossing\n ');

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

scheme = input('Choose thresh [1..5]:\n 1 for 10\n 2 for 20\n 3 for 30\n 4 for 40\n 5 for 50\n 6 for 70\n 7 for 90\n 8 for 110\n 9 for 130\n 0 for manual input\n ');
if (scheme == 1)
	thresh = 10;
elseif (scheme == 2)
	thresh = 20;
elseif (scheme == 3)
	thresh = 30;
elseif (scheme == 4)
	thresh = 40;
elseif (scheme == 5)
	thresh = 50;
elseif (scheme == 6)
	thresh = 70;
elseif (scheme == 7)
	thresh = 90;
elseif (scheme == 8)
	thresh = 110;
elseif (scheme == 9)
	thresh = 130;
elseif (scheme == 0)
	thresh = input('thresh = ');
end
	
if (typv == 1)
	fprintf('Laplacian with two thresholds.\n');
	scheme2 = input('Another thresh [1.. 5]\n ');
	if (scheme2 == 1)
		thresh2 = 10;
	elseif (scheme2 == 2)
		thresh2 = 20;
	elseif (scheme2 == 3)
		thresh2 = 30;
	elseif (scheme2 == 4)
		thresh2 = 40;
	elseif (scheme2 == 5)
		thresh2 = 50;
	elseif (scheme2 == 6)
		thresh2 = 70;
	elseif (scheme2 == 7)
		thresh2 = 90;
	elseif (scheme2 == 8)
		thresh2 = 110;
	elseif (scheme2 == 9)
		thresh2 = 130;
	elseif (scheme2 == 0)
		thresh2 = input('thresh2 = ');
	end
	% Laplacian
	figure;
	FR0 = subplot(1,2,1);
	R0 = cvLaplacian(I, thresh);
	imshow(R0);
	title(['Laplacian with zero-cross thresh = ' num2str(thresh)]);

	FR1 = subplot(1,2,2);
	R1 = cvLaplacian(I, thresh2);
	imshow(R1);
	title(['Laplacian with zero-cross thresh = ' num2str(thresh2)]);
elseif (typv == 2)
	fprintf('Predefined LoG with two thresholds.\n');
	scheme2 = input('Another thresh [1.. 5]\n ');
	if (scheme2 == 1)
		thresh2 = 10;
	elseif (scheme2 == 2)
		thresh2 = 20;
	elseif (scheme2 == 3)
		thresh2 = 30;
	elseif (scheme2 == 4)
		thresh2 = 40;
	elseif (scheme2 == 5)
		thresh2 = 50;
	elseif (scheme2 == 6)
		thresh2 = 70;
	elseif (scheme2 == 7)
		thresh2 = 90;
	elseif (scheme2 == 8)
		thresh2 = 110;
	elseif (scheme2 == 9)
		thresh2 = 130;
	elseif (scheme2 == 0)
		thresh2 = input('thresh2 = ');
	end
	% LoG
	figure;
	FR0 = subplot(1,2,1);
	R0 = cvLoG(I, thresh);
	imshow(R0);
	title(['LoG with zero-cross thresh = ' num2str(thresh)]);

	FR1 = subplot(1,2,2);
	R1 = cvLoG(I, thresh2);
	imshow(R1);
	title(['LoG with zero-cross thresh = ' num2str(thresh2)]);
elseif (typv == 3)
	fprintf('LoGs with two standard deviations of Gaussian smoothing.\n');
	% LoGs with sigma
	sigma = input('sigma = ');
	sigma2 = input('sigma2 = ');
	figure;
	FR0 = subplot(1,2,1);
	R0 = cvLoGs(I, thresh, 9, sigma);
	imshow(R0);
	title(['LoGs with zero-cross thresh = ' num2str(thresh) ' and sigma = ' num2str(sigma)]);

	FR1 = subplot(1,2,2);
	R1 = cvLoGs(I, thresh, 9, sigma2);
	imshow(R1);
	title(['LoGs with zero-cross thresh = ' num2str(thresh) ' and sigma = ' num2str(sigma2)]);
elseif (typv == 4)
	fprintf('Laplacian, predefined LoG and LoGs with a standard deviation (all same threshold).\n');
	sigma = input('sigma = ');
	% Laplacian
	figure;
	FR0 = subplot(1,3,1);
	R0 = cvLaplacian(I, thresh);
	imshow(R0);
	title(['Laplacian with zero-cross thresh = ' num2str(thresh)]);

	% LoG with sigma
	FR0 = subplot(1,3,2);
	R0 = cvLoG(I, thresh);
	imshow(R0);
	title(['Predefined LoG with zero-cross thresh = ' num2str(thresh)]);

	FR1 = subplot(1,3,3);
	R1 = cvLoGs(I, thresh, 9, sigma);
	imshow(R1);
	title(['LoGs with zero-cross thresh = ' num2str(thresh) ' and sigma = ' num2str(sigma)]);
end

figure; imshow(I);
title('Original image');