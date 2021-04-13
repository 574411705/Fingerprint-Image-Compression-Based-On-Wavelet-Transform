load 'bior.mat'

CR=(mean(bitrate)/8).^(-1)
x=[1,10,20,30,40,50,60,70,80,90]
plot(x,CR,'b')