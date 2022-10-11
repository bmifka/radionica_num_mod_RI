close all; clear all; clc
%****************************************************************************************************************
%1d linearna advektivna jednadžba - vizualizacija
%--------------------------------
%Program is made in the socpe of the Numerical Modeling Workshop held by prof. dr. sc. Vladimir Đurđević
%Program je napravljen u sklopu Radionice numeričkog modeliranja pod vodstvom prof. dr. sc. Vladimira Đurđevića
%----------------------------------------------------
%Boris Mifka,Fakultet za fiziku, Sveučilište u Rijeci
%11.10.2022.
%
%****************************************************************************************************************

%--ucitavanje brzine
load u.out

%--dimenzije i preslagivanje (retci-točke modela, stupci - 1 vrem. korak) 
  sizu=size(u);
  sizu=sizu(1);
  tm=sizu/1001;
  tm=tm(1);
  u=reshape(u,sizu/tm,tm);
 
%--crtanje u petlji --> animacija  
   f1=figure(1);
   for i=1:10:tm
       
   plot(u(:,i))
     title(i)
     xlim([0 1200])
     ylim([-0.2 0.3])
     pause(0.1)

%--saveas(figure(1),strcat(num2str(i),'.jpg'))
     hold off
      
   end
