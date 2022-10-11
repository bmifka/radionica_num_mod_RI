PROGRAM ssc
!*******************************************************************************************************************
! "Source-Sink" model, 
! baziran na 2d linearnim jednadžbama plitke vode na Arakawa C mreži
! shema je Euler unaprijed-unazad (unaprijed za visine, a unatrag za brzine)
!
!Program is made in the socpe of the Numerical Modeling Workshop held by prof. dr. sc. Vladimir Đurđević
!Program je napravljen u sklopu Radionice numeričkog modeliranja pod vodstvom prof. dr. sc. Vladimira Đurđevića
!----------------------------------------------------
!Boris Mifka,Fakultet za fiziku, Sveučilište u Rijeci
!
!*******************************************************************************************************************
IMPLICIT NONE

!Varijable

INTEGER, PARAMETER     :: IM=93, JM=84
REAL, PARAMETER        :: d = 250000., dt=600., dh=2.*dt/600., HN = 1000., g=9.81, f=0.0001, dtHNd=dt*HN/d, dtgd = dt*g/d
INTEGER, PARAMETER     :: NMAX = 20*24*3600/dt
INTEGER                :: I,J,N
REAL, DIMENSION(IM,JM) :: U,V,H,UF,VF,HF, FU, FV

!INICIJALIZACIJA POČETNIH POLJA KOMPONENTI U I V BRZINA I VISINE FLUIDA H
	DO I = 1,IM
		DO J = 1,JM
			U = 0.; V = 0. ; H = HN
			UF= 0.; VF= 0. ; HF= HN	
		ENDDO
	ENDDO

!POČETNI UVIJETI ZA "SOURCE" U LIJEVOM DIJELU DOMENE
	DO I = 29,31
		DO J = 39,41
			H (I,J)  = HN+dh;
			!HF(I,J) = HN+dh;
		ENDDO
	ENDDO
	
!POČETNI UVIJETI ZA "SINK" U DESNOM DIJELU DOMENE
	DO I = 59,61
		DO J = 39,41
			H (I,J) = HN-dh;
			!HF(I,J) = HN-dh; 
		ENDDO
	ENDDO


!KORAČANJE U VREMENU - integracija modela
	DO N=1,NMAX

!--prostorna petlja za H
	DO I = 2,IM-1
		DO J = 2,JM-1
			HF(I,J) = H(I,J) - dtHNd* ( U(I,J) - U(I-1,J) + V(I,J) - V(I,J-1) )
		ENDDO
	ENDDO
	
!--prostorna petlja za brzine	
	DO I = 2,IM-1
		DO J = 2,JM-1
			FU(i,j) = dt*f* ( U(I-1,J+1)+ U(I,J+1) + U(I-1,J) + U(I,J) )/4
			FV(i,j) = dt*f* ( V(I,J)    + V(I+1,J) + V(I,J-1) + v(I+1,J-1) )/4
			UF(I,J) = U(I,J) - dtgd* (HF(I+1,J) - HF(I,J)) + FV(I,J)
			VF(I,J) = V(I,J) - dtgd* (HF(I,J+1) - HF(I,J)) - FU(I,J)
		ENDDO
	ENDDO
!--"update varijabli za sljedeći korak"
    U = UF; V = VF; H = HF
	
!--ispis u file-ove svakih sat vremena	
		IF (mod(N,6)==0) CALL wrt
	
!--"update" visine fluida na lijevoj strani domene
	DO I = 29,31
		DO J = 39,41
			H (I,J)  = H(I,J)+dh;
		ENDDO
	ENDDO
	
!--"update" visine fluida na desnoj strani domene
	DO I = 59,61
		DO J = 39,41
			H (I,J) = H(I,J)-dh; 
		ENDDO
	ENDDO	
	ENDDO	
	
CONTAINS

SUBROUTINE  wrt
!--sub za ispis u .txt fileove
	open(12, file='h.out')
	open(13, file='u.out')
	open(14, file='v.out')
	 
	 
	DO j=1,jm
	  	WRITE(12,*) (h(i,j),i=1,im) 
	  	WRITE(13,*) (u(i,j),i=1,im)
	  	WRITE(14,*) (v(i,j),i=1,im)
	ENDDO
	 
	WRITE(12,*) ''
	WRITE(13,*) ''
	WRITE(14,*) ''
	
END SUBROUTINE wrt 

END PROGRAM ssc
