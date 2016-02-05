clc;
clear all;

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

scheme = input('Choose minimal edgebound difference [1..5]:\n 1 for 15\n 2 for 20\n 3 for 25\n 4 for 30\n 5 for 35\n 6 for 40\n 7 for 60\n 8 for 80\n 9 for 100\n 0 for manual input\n ');

if (scheme == 1)
	delta = 15;
elseif (scheme == 2)
	delta = 20;
elseif (scheme == 3)
	delta = 25;
elseif (scheme == 4)
	delta = 30;
elseif (scheme == 5)
	delta = 35;
elseif (scheme == 6)
	delta = 40;
elseif (scheme == 7)
	delta = 60;
elseif (scheme == 8)
	delta = 80;
elseif (scheme == 9)
	delta = 100;
elseif (scheme == 0)
	delta = input('delta = ');
end

figure; imshow(I);
title('Original image');

O = cvGrSearch(I, delta);
figure; imshow(O);
title('Graph-searched');