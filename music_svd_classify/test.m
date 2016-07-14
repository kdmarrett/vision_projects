clear all; close all; clc

load dogData.mat
load catData.mat

for j=1:9
  subplot(3,3,j)
  dog1=reshape(cat(:,j),64,64);
  imshow(dog1)
end

for j=1:80

X=double(reshape(dog(:,j),64,64));
[cA,cH,cV,cD]=dwt2(X,'haar');

nbcol=size(colormap(gray),1);
cod_cH1=wcodemat(cH,nbcol);
cod_cV1=wcodemat(cV,nbcol);
cod_edge=cod_cH1+cod_cV1;

dogdata(:,j)=reshape(cod_edge,32^2,1);

end

for j=1:80

X=double(reshape(cat(:,j),64,64));
[cA,cH,cV,cD]=dwt2(X,'haar');

nbcol=size(colormap(gray),1);
cod_cH1=wcodemat(cH,nbcol);
cod_cV1=wcodemat(cV,nbcol);
cod_edge=cod_cH1+cod_cV1;

catdata(:,j)=reshape(cod_edge,32^2,1);

end

% features
X=[dogdata catdata];
save X

figure(2)
[u,s,v]=svd(X);
plot(diag(s),'ko','Linewidth',[2]);

break
figure(3)
plot3(v(1:80,1),v(1:80,2),v(1:80,3),'ro','Linewidth',[2])
hold on
plot3(v(81:end,1),v(81:end,2),v(81:end,3),'go','Linewidth',[2])
