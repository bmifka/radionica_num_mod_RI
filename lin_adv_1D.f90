PROGRAM lin_adv_1D
!****************************************************************************************************************
!1d linearna advektivna jednadžba
!--------------------------------
!
!
!Program is made in the socpe of the Numerical Modeling Workshop held by prof. dr. sc. Vladimir Đurđević
!Program je napravljen u sklopu Radionice numeričkog modeliranja pod vodstvom prof. dr. sc. Vladimira Đurđevića
!----------------------------------------------------
!Boris Mifka,Fakultet za fiziku, Sveučilište u Rijeci
!
!****************************************************************************************************************
IMPLICIT NONE

INTEGER, PARAMETER   :: IM=1001, NMAX=5000 
REAL, PARAMETER      :: c=10., dx=10000., dt=500.,cdtdx=c*dt/dx
INTEGER              :: I,N
REAL,DIMENSION(1001) :: U,UF

!CFL
WRITE(*,*) cdtdx
!---INICIJALIZACIJA
	DO I=1,IM
		U (I) = 0.
		UF(I) = 0.
	ENDDO
	
!---POCETNI UVJETI 

!---box
	!DO I=IM/2,IM/2+10
		!U (I) = 1
		!UF(I) = 1
	!ENDDO

!--gaussian
	DO I = 1,IM
		U(I)  = 0.8*EXP(-(I*dx-IM/2*dx)**2)
		UF(I) = 0.8*EXP(-(I*dx-IM/2*dx)**2)
	ENDDO

!---KORAČANJE U VREMENU
	DO N=1,NMAX
		DO I=2,IM 
			UF(I) = U(I)-cdtdx*(U(I)-U(I-1))
		ENDDO
		
!---ciklički r.u.		
		UF(1) = UF(IM-1)
		UF(2) = UF(IM)
		
		DO I=2,IM
		U(I) = UF(I)
		ENDDO
		
!---ISPIS u file svakog vrem. koraka
		CALL wrt

	ENDDO


CONTAINS

SUBROUTINE  wrt
		
	open(13, file='u.out')
	 
	DO i=1,im
	  WRITE(13,*) u(i)
	ENDDO
	 
	WRITE(13,*) ''
	
END SUBROUTINE wrt 

END PROGRAM lin_adv_1D
