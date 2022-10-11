PROGRAM lin_adv_1D
!*******************************************************************************************
!1d linearna advektivna jednadžba
!
!
!*******************************************************************************************
IMPLICIT NONE

INTEGER, PARAMETER   :: IM=1001, NMAX=5000 
REAL, PARAMETER      :: c=10., dx=10000., dt=500.,cdtdx=c*dt/dx
INTEGER              :: I,N
REAL,DIMENSION(1001) :: U,UF

WRITE(*,*) cdtdx
!INICIJALIZACIJA
	DO I=1,IM
		U (I) = 0.
		UF(I) = 0.
	ENDDO
	
!POCETNI UVJETI

	!DO I=IM/2,IM/2+10
		!U (I) = 1
		!UF(I) = 1
	!ENDDO

	DO I = 1,IM
		U(I) = 0.8*EXP(-(I*dx-IM/2*dx)**2)
		UF(I) = 0.8*EXP(-(I*dx-IM/2*dx)**2)
		
	ENDDO

!Koracanje u vremenu
	DO N=1,NMAX
		DO I=2,IM 
			UF(I) = U(I)-cdtdx*(U(I)-U(I-1))
		ENDDO
		
		
		
		UF(1) = UF(IM-1)
		UF(2) = UF(IM)
		
		DO I=2,IM
		U(I) = UF(I)
		ENDDO
		
		
		!IF (mod(N,5)==0)
		CALL wrt

	ENDDO


CONTAINS

	SUBROUTINE  wrt

	open(13, file='u.out')
	 
	 DO i=1,im
	  	!WRITE(12,*) (h(i,j),i=1,im) ! implicitna petlja
	  	WRITE(13,*) u(i)
	  	!WRITE(14,*) (v(i,j),i=1,im)
	 ENDDO
	 
	WRITE(13,*) ''
	
	END SUBROUTINE wrt 

END PROGRAM lin_adv_1D