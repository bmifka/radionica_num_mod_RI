PROGRAM kanal
!*******************************************************************************************************************
! Eksperiment s kanalom i topografijom u sredini 
! baziran na 2d nelinearnim jednadžbama plitke vode na Arakawa C mreži
! shema je Euler unaprijed-unazad (unaprijed za visine, a unatrag za brzine)
!
!Program is made in the socpe of the Numerical Modeling Workshop held by prof. dr. sc. Vladimir Đurđević
!Program je napravljen u sklopu Radionice numeričkog modeliranja pod vodstvom prof. dr. sc. Vladimira Đurđevića
!----------------------------------------------------
!Boris Mifka, Fakultet za fiziku, Sveučilište u Rijeci
!
!*******************************************************************************************************************
IMPLICIT NONE


INTEGER, PARAMETER     :: IM=160, JM=84
REAL, PARAMETER        :: d = 250000., dt=600., dh=2.*dt/600., HN=1000. ,g=9.81, f=0.0001, dtgd = dt*g/d
INTEGER, PARAMETER     :: NMAX = 3*24*3600/dt
INTEGER                :: I,J,N
REAL, DIMENSION(IM,JM) :: U,V,H,UF,VF,HF,FU,FV,adv1,adv2,adv3,HB

!INICIJALIZACIJA
		U  = 0.; V = 0.;  
		UF = 0.; VF= 0.; 	 

!ZADAVANJE TOPGRAFIJE - BRDO U SREDINI
	DO I = 1,IM
		DO J = 1,JM
        HB(I,J) = 1000 - 50* EXP(-( (I*d-IM/2*d)**2/(8*d)**2 + (J*d-JM/2*d)**2/(8*d)**2) )
		HB(I,J) = 1000 - 50* EXP(-( (I*d-IM/2*d)**2/(8*d)**2 + (J*d-JM/2*d)**2/(8*d)**2) )	
		ENDDO
	ENDDO

H  = 0.; HF = 0. 
!POČETNI UVJETI (uniformi meridionalni vjetar)
	U = 0.05; UF = 0.05;
	
!POČETNI UVIJETI ZA "SOURCE" U LIJEVOM DIJELU DOMENE
	!DO I = 52,55
		!DO J = 39,41
		!	H (I,J)  = HN+dh;
			!HF(I,J) = HN+dh;
		!ENDDO
	!ENDDO
	
!POČETNI UVIJETI ZA "SINK" U DESNOM DIJELU DOMENE
	!DO I = 106,109
		!DO J = 39,41
			!H (I,J) = HN-dh;
			!HF(I,J) = HN-dh; 
		!ENDDO
	!ENDDO	
	
!KORAČANJE U VREMENU - integracija modela
	DO N = 1,NMAX
!--prostorna petlja za H - jednadzbe u flux formi
	DO I = 2,IM-1
		DO J = 2,JM-1
			HF(I,J) = H(I,J) - dt* ( ( H(I+1,J) + H(I,J) +  HB(I+1,J) + HB(I,J) ) *U(I,J) -  &
			( H(I,J) + H(I-1,J) + HB(I,J) + HB(I-1,J) ) *U(I-1,J) )/(2*d)
			HF(I,J) = HF(I,J) - dt* ( ( H(I,J+1) + H(I,J) +  HB(I,J+1) + HB(I,J) ) *V(I,J) - &
			( H(I,J) + H(I,J-1) + HB(I,J) + HB(I,J-1)) *V(I,J-1) )/(2*d)
		ENDDO
	ENDDO
!--bezgradijentni rubni uvjet za visinu
	DO I=2,IM
		HF(I,1)  = HF(I,2)
		HF(I,JM) = HF(I,JM-1)
	ENDDO
!--prostorna petlja za brzine
	DO I = 2,IM-1
		DO J = 2,JM-1
			FU(i,j) = dt*f* ( U(I-1,J+1)+ U(I,J+1) + U(I-1,J) + U(I,J) )/4
			FV(i,j) = dt*f* ( V(I,J)    + V(I+1,J) + V(I,J-1) + v(I+1,J-1) )/4
			
			adv1(I,J)  = U(I,J)* ( U(I+1,J) - (U(I-1,J)) )/(2*d) 
			adv1(I,J)  = adv1(I,J) + ( V(I,J) + V(I+1,J) + V(I,J-1) + V(I+1,J-1) )* ( U(I,J+1)-U(I,J-1) )/(8*d)
			adv2(I,J)  = ( U(I,J) + U(I,J+1) + U(I-1,J+1) + U(I-1,J) )* (V(I+1,J)-V(I-1,J))/(8*d) 
			adv2(I,J)  = adv2(I,J) + V(I,J)* (V(I,J+1)-V(I,J-1))/(2*d)
			
			
			UF(I,J) = U(I,J) - dtgd* (HF(I+1,J) - HF(I,J))  -dt*adv1(i,j) + FV(I,J)
			VF(I,J) = V(I,J) - dtgd* (HF(I,J+1) - HF(I,J))  -dt*adv2(i,j) - FU(I,J)
		ENDDO
	ENDDO
!--bezgradijentni rubni uvjet za brzine
	DO I=2,IM
		UF(I,1) = UF(I,2)
		VF(I,1) = VF(I,2)
		
		UF(I,JM) = UF(I,JM-1)
		UF(I,JM) = UF(I,JM-1)
	ENDDO
!ciklicki r.u.
	DO J = 1,JM
		UF(2,J) = UF(IM-1,J)
		UF(1,J) = UF(IM-2,J)
		VF(1,J) = VF(IM-1,J)
		VF(2,J) = VF(IM,J)
		HF(1,J) = HF(IM-1,J) !da li ovo ide nakon h petlje?
		HF(2,J) = HF(IM,J)
	ENDDO
!--"update varijabli za sljedeći korak"
    U = UF; V = VF; H = HF
	
	!IF (mod(N,6)==0) 
	CALL wrt
	
!--"dodavanje" brzine u svakom koraku
	IF (N<41) THEN
!	write(*,*) N
!	write(*,*) MAXVAL(U)
		DO I = 1,IM
			DO J = 1,JM
				U (I,J)  = U(I,J) + 0.02;
			ENDDO
		ENDDO	
	ELSE
	END IF	
	ENDDO	
	
CONTAINS

SUBROUTINE  wrt
!--sub za ispis u .txt fileove
	open(12, file='h.out')
	open(13, file='u.out')
	open(14, file='v.out')
!ako zelite u Matlabu vizulaizirati topografiju, umjesto h stavite hb...
	 DO j=1,jm
	  	WRITE(12,*) (h(i,j),i=1,im) 
	  	WRITE(13,*) (u(i,j),i=1,im)
	  	WRITE(14,*) (v(i,j),i=1,im)
	 ENDDO
	 
	WRITE(12,*) ''
	WRITE(13,*) ''
	WRITE(14,*) ''
	
END SUBROUTINE wrt 


END PROGRAM kanal
