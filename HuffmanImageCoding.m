
% read the image
Image = imread('C:\Users\goonerlx\Desktop\study(2020 spring)\Data compression and image communication\Project\f0001_01.png');
% calculate the frequency of each pixel

imhist(Image)
[frequency,pixelValue] = imhist(Image);

% sum all the frequencies
tf = sum(frequency) ;

% calculate the frequency of each pixel
probability = frequency ./ tf ;

% create a dictionary
dict = huffmandict(pixelValue,probability);

% get the image pixels in 1D array
imageOneD = Image(:) ;

% encoding
testVal = imageOneD ;
encodedVal = huffmanenco(testVal,dict);

% decoding
decodedVal = huffmandeco(encodedVal,dict);

% display the length
kb = 8 * 1024 ;
disp(numel(de2bi(testVal))/kb) ;
disp(numel(encodedVal)/kb) ;
disp(numel(de2bi(decodedVal))/kb) ;
ci = reshape(decodedVal,[rows, columns])


% % get the original image from 1D Array
% [rows, columns, numberOfColorChannels] = size(Image);
% oi = reshape(testVal,[rows, columns, numberOfColorChannels]) ;
% imwrite(oi,'E:\original.png');
% 
% % get the decoded image from 1D Array
% decodedVal = uint8(decodedVal);
% ci = reshape(decodedVal,[rows, columns]) ;
% imwrite(ci,'E:\decoded.png');


