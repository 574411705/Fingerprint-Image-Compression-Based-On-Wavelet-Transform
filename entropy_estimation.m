dwtmode('per');
filter = 'bior3.5';
[lowD,highD] = wfilters(filter);
[lowR,highR] = wfilters(filter);
fingerprint = double(imread('2.png'));
im = fingerprint;
output = [];
f=[]
U=[];
H=[]
Filesize=[]
BPP=[]
Codelength=[]
AL=[]
Ie=[]
%three-level decomposition
 for iter = 1:3

     [c,s] = wavedec2(fingerprint,iter,lowD,highD);
     clear A1 H1 V1 D1
     [H1,V1,D1] = detcoef2('all',c,s,iter);
     A1 = appcoef2(c,s,'bior3.5',iter);
     im = A1;
     output = [H1(:)' V1(:)' D1(:)' output];
 end
for iter = iter:-1:1
    right = size(fingerprint,2)/2^iter;
    bot = size(fingerprint,1)/2^iter;
    im(bot+1:bot*2,1:right) = reshape(output(1:(bot*right)),bot,right);
    output(1:(bot*right)) = [];
    im(1:bot,right+1:right*2) = reshape(output(1:(bot*right)),bot,right);
    output(1:(bot*right)) = [];
    im(bot+1:bot*2,right+1:right*2) = reshape(output(1:(bot*right)),bot,right);
    output(1:(bot*right)) = [];
end
%Quantization
Q = 1:10:100;
k=1
for k = 1:10
    imq(:,:,k) = round(im/Q(k))*Q(k);
%Dequantization
    imd = round(imq/Q(k))*Q(k);
    fig=imd(:,:,k)




% sum all the frequencies
% imhist(fig)
    imd = imq(:,:,k); imd = imd(:);
    pixelValue = unique(imd);
% calculate the frequency of each pixel
    probability = hist(imd,unique(imd)) / length(imd);

% create a dictionary
    dict = huffmandict(pixelValue,probability);

%calculate length
    U=[];
    huft=0
    for i=1:size(dict)
        u=length(cell2mat(dict(i,2)))
        huft=huft+u
        U=[U,u]
    end

% get the image pixels in 1D array
    imageOneD = fig(:) ;

% encoding
    testVal = imageOneD ;
    encodedVal = huffmanenco(testVal,dict);

% decoding
    decodedVal = huffmandeco(encodedVal,dict);

%bit per pixel
    filesize=numel(encodedVal)
    Filesize=[Filesize,filesize]
    Bpp= filesize/numel(fig);
    BPP=[BPP,Bpp]
%Entropy estimation
    [symbol,c]=size(pixelValue)
    probability1= (hist(imd,unique(imd))+1)/ (length(imd)+ 1*symbol)%(MAP of the probability)
    ie=-mean(log2(probability1))%self-entropy
    Ie=[Ie,ie]
    h = -sum(probability1.*log2(probability1)); %entropy
    H=[H,h]
    codelength=(sum(sort(U,'descend').*sort(probability1)))*symbol+huft %(average codelength(bit/symbol)*symbol)
    Codelength=[Codelength,codelength]
    L=-sum(log2(probability1))%adaptive codelength
    EL=(-sum(log2(probability1)))/length(probability)
    AL=[AL,EL]
%PSNR
    MSE=immse(imd(:,:,k),fingerprint)
    F=10*log10((2^8-1)^2/MSE)
    f=[f,F] 

end