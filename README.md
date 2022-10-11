# radionica_num_mod_RI

Kod za Radionicu numeričkog modeliranja. 
Radionica je održana od 03-07.10.2022. na Fakultu za Fiziku, Sveučilište u Rijeci, 
pod vodstvom prof. dr. sc. Vladimira Đurđevića (Univerzitet u Beogradu, Fizički Fakultet)
Kod izradio: Boris Mifka, Fakultet za Fiziku, Sveučilište u Rijeci

Izvedena su 4 numerička eksperimenta, za koji je priložen kod:
1. 1D linearna advekcija, Euler shema unazad u vremenu i prostoru, s p.u. box ili gaussian
2. Linearni "Source-sink" eksperiment baziran na 2D linerarnim jedn. plitke vode 
3. Nelinearni "Source-sink" eksperiment baziran na 2D nelinerarnim jedn. plitke vode
4. Kanal s topografijom - jedn. za visinu u flux formi, dodana je gaussijan u 2D, zadan je uniformno
   polje brzine u zonalnom smjeru i postepeno se pojacava u prvih 41 koraka

Glavni programi u Fortranu:
1. lin_adv_1D.f90
2. ssc.f90
3. ssc_nl.f90
4. kanal.f90

Skripta za kompajliranje koda:
1. compile_script


Kod za vizualizaciju u Matlabu:
1. VIS_lon_adv_1D.m
2. VIS_ssc_l_nl.m
3. VIS_kanal.m
4. redblue.m za hladno-toplu skalu je preuzet s https://www.mathworks.com/matlabcentral/fileexchange/25536-red-blue-colormap
