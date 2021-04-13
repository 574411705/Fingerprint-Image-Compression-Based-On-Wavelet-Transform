dwtmode('per');
filter = 'bior3.5';
load 'db4.mat'
[lowD,highD] = wfilters(filter);
[lowR,highR] = wfilters(filter);
lenna = double(imread('1.png'));
im = lenna;
output = [];
f=[]
 for iter = 1:3

 [c,s] = wavedec2(lenna,iter,lowD,highD);
 clear A1 H1 V1 D1
[H1,V1,D1] = detcoef2('all',c,s,iter);
A1 = appcoef2(c,s,'bior3.5',iter);
im = A1;
output = [H1(:)' V1(:)' D1(:)' output];
 end
 for iter = iter:-1:1
right = size(lenna,2)/2^iter;
bot = size(lenna,1)/2^iter;
im(bot+1:bot*2,1:right) = reshape(output(1:(bot*right)),bot,right);
output(1:(bot*right)) = [];
im(1:bot,right+1:right*2) = reshape(output(1:(bot*right)),bot,right);
output(1:(bot*right)) = [];
im(bot+1:bot*2,right+1:right*2) = reshape(output(1:(bot*right)),bot,right);
output(1:(bot*right)) = [];
end
% figure
% imshow(im,[min(min(im)) max(max(im))])
% 
% figure
Q = [10 80 150];
for k = 1:3
imq(:,:,k) = round(im/Q(k))*Q(k);
imd = imq;
for iter = 3:-1:1
clear lowC highC ll hl lh hh
right = size(lenna,2)/2^iter;
bot = size(lenna,1)/2^iter;

ll = imd(1:bot,1:right,k);
lh = imd(1:bot,right+1:right*2,k);
hl = imd(bot+1:bot*2,1:right,k);
hh = imd(bot+1:bot*2,right+1:right*2,k);
for i = 1:size(ll,2)
lowC(:,i) = idwt(ll(:,i),hl(:,i),filter);
highC(:,i) = idwt(lh(:,i),hh(:,i),filter);
end
for i = 1:size(lowC,1)
imd(i,1:right*2,k) = idwt(lowC(i,:),highC(i,:),filter);
end
end
MSE=immse(imd(:,:,k),lenna)
F=10*log10((2^8-1)^2/MSE)
f=[f,F]
end

% for i = j: 10
% Bpp= bitrate1(i,:)
% 
% color=[1 0 0;0 1 0;0 0 1;0.5 1 1;1 1 0.5;1 0.5 1; 0 0 0.5; 0.5 0 0;0 0.5 0;1 0.5 0.5; 0.5 1 0.5;0.5 0.5 1;1 1 0;0 1 1;1 0 1];
%  
% figure;
% for i=2:col
%     plot(data(2:end,1),data(2:end,i),'color',color(i-1,:));
%     leg_str{i-1}=[num2str(SS(i-1)),'mg/L'];
%     hold on
% end
% legend(leg_str)
% 
% 
% 
% % F=psnr(imd(:,:,k),lenna)
% disp(F)
% % f=[f,F]
% figure(1)
% plot(sort(Bpp),sort(f),'m')
% plot(sort(Bpp),sort(f),'o')
% xlabel("Bit per pixel")
% ylabel("PSNR")
% title("Rate distortion")
% legend('bior3.5','db4')
% hold on
% end
% fig=imd(:,:,k)
% distortion= (fileSize*8*size(fig,3))/numel(fig);








% subplot(2,2,k)
% imshow(imd(:,:,k),[0 255])
% tmp = imq(:,:,k); tmp = tmp(:);
% p = hist(tmp,unique(tmp)) / length(tmp);
% H = -sum(p.*log2(p));
% title(['Q: ' num2str(Q(k)) ', MSE: ' num2str(immse(imd(:,:,k),lenna))])

% subplot(2,2,4)
% imshow(lenna,[0 255])
% title('Original')


