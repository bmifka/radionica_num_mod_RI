close all; clear all; clc
%****************************************************************************************************************
% "Source-Sink" model, vizualizacija za linearni i nelinearni slučaj paralelno 
% baziran na 2d nelinearnim jednadžbama plitke vode na Arakawa C mreži
% shema je Euler unaprijed-unazad (unaprijed za visine, a unatrag za brzine)
%
%Program is made in the socpe of the Numerical Modeling Workshop held by prof. dr. sc. Vladimir Đurđević
%Program je napravljen u sklopu Radionice numeričkog modeliranja pod vodstvom prof. dr. sc. Vladimira Đurđevića
%----------------------------------------------------
%Boris Mifka,Fakultet za fiziku, Sveučilište u Rijeci
%11.10.2022.
%
%****************************************************************************************************************

%--odredi broj sati (tm) rucno
 tm=  330;
 HN = 1000;
 
%--ucitavanje polja za linearni model 
 load u.out
 load v.out
 load h.out

%--ucitavanje polja za nelinearni model 
 load u_nl.out
 load v_nl.out
 load h_nl.out
 
%--dimenzije  
 sizu=84;
 %tm=size(u,1)/(24*84); %-ako zelim cij
 
%--definiranje mreze 
 [x,y] = meshgrid(1:1:93,1:1:84);
  
%--crtanje u petlji --> animacija  
 f1=figure(1);
  for i=1:tm
    
    st(i)=1+sizu*(i-1); en(i)=sizu+sizu*(i-1);  
    u2=u(st(i):en(i),:);
    v2=v(st(i):en(i),:);
    h2=h(st(i):en(i),:)-HN;
    
    u2_nl=u_nl(st(i):en(i),:);
    v2_nl=v_nl(st(i):en(i),:);
    h2_nl=h_nl(st(i):en(i),:)-HN;
 
%--ako zelite vidjeti razliku lin. i non-lin slucaja
% h2_nl = h2_nl -h2;
 
%--slika za linearni slucaj 
  subplot(1,2,1)
  
    [C,hh]=contourf(h2);
    set(hh,'LineColor','none');
    colormap(redblue)
    title(i)
    hold on
 
 %--dodavanje brzine vjetra (to bi trebalo interpolirati da se dobiju vrijednosti u tockama
 %  h, radi razmaknutosti mreze
  quiver(x(1:2:end,1:2:end),y(1:2:end,1:2:end),u2(1:2:end,1:2:end),v2(1:2:end,1:2:end),'k')
  
 %---zoom  
 % xlim([25 65])
 % ylim([20 60])
 %--skala za boje, mozete se s tim igrati...
 % caxis([])
  colorbar
  axis equal

%--crtanje za nelinearni slucaj  
  subplot(1,2,2)
  
    [C,hh]=contourf(h2_nl);
    set(hh,'LineColor','none');
    colormap(redblue)
    hold on
  
 %--dodavanje brzine vjetra (to bi trebalo interpolirati da se dobiju vrijednosti u tockama
 %  h, radi razmaknutosti mreze
  quiver(x(1:2:end,1:2:end),y(1:2:end,1:2:end),u2_nl(1:2:end,1:2:end),v2_nl(1:2:end,1:2:end),'k')   
    
 %---zoom  
 % xlim([25 65])
 % ylim([20 60])
 %--skala za boje, mozete se s tim igrati...
 % caxis([])
  colorbar  
  axis equal

  %xlabel('W-E')
  %ylabel('S-N')
  
  %--opcija za automatsko povecanje slike preko ekrana
  set(gcf, 'Position', get(0, 'Screensize'));

  pause(0.02)
  hold off

  %saveas(figure(1),strcat('SLIKE/SSC_',num2str(i),'.jpg'))
   
   
  end
