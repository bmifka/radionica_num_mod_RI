close all; clear all; clc
%*******************************************************************************************************************
% Eksperiment s kanalom i topografijom u sredini 
% baziran na 2d nelinearnim jednadžbama plitke vode na Arakawa C mreži
% shema je Euler unaprijed-unazad (unaprijed za visine, a unatrag za brzine)
%
%Program is made in the socpe of the Numerical Modeling Workshop held by prof. dr. sc. Vladimir Đurđević
%Program je napravljen u sklopu Radionice numeričkog modeliranja pod vodstvom prof. dr. sc. Vladimira Đurđevića
%----------------------------------------------------
%Boris Mifka, Fakultet za fiziku, Sveučilište u Rijeci
%*******************************************************************************************************************

%--odredi broj sati (tm) rucno
 tm=  120;
 
%--ucitavanje polja
 load u.out
 load v.out
 load h.out
 
%--dimenzije
 sizu=size(u);
 sizu=84;
 
%--definiranje mreze
 [x,y] = meshgrid(1:1:160,1:1:84);

 %--crtanje u petlji --> animacija  
 f1=figure(1);
  for i=1:96
%--uzimanje polja za 1 vremenski korak    
    st(i)=1+sizu*(i-1); en(i)=sizu+sizu*(i-1);  
    u2=u(st(i):en(i),:);
    v2=v(st(i):en(i),:);
    h2=h(st(i):en(i),:);
%--crtanje kontura i brzina
    [C,hh]=contourf(h2(:,:));
    set(hh,'LineColor','none');
    colormap(redblue)
    hold on
    %quiver(x(1:2:end,1:2:end),y(1:2:end,1:2:end),u2(1:2:end,1:2:end),v2(1:2:end,1:2:end),'k')
%--zoom   
   xlim([45 120])
   ylim([33 45])
%--skala za boje, mozete se s tim igrati...
   %caxis([-0.2 0.2])   
   colorbar 
   axis equal
   title(num2str(i))
  %xlabel('W-E')
  %ylabel('S-N')
  
  pause(0.02)
  hold off
  %saveas(figure(1),strcat('SLIKA_,num2str(i),'.jpg'))
   
  end
