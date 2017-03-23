!--------------------------------------------------------------------------
!   Copyright 2011-2016 Lasse Lambrecht (Ruhr-Universitaet Bochum, Germany)
!   Copyright 2014-2017 Thomas Möller (Ruhr-Universitaet Bochum, Germany)
!   Copyright 2015-2017 Andre Lamert (Ruhr-Universitaet Bochum, Germany)
!
!   This file is part of NEXD 2D.
!
!   NEXD 2D is free software: you can redistribute it and/or modify it 
!   under the terms of the GNU General Public License as published by the 
!   Free Software Foundation, either version 3 of the License, or (at your 
!   option) any later version.
!
!   NEXD 2D is distributed in the hope that it will be useful, but WITHOUT
!   ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
!   FITNESS FOR A PARTICULAR PURPOSE. 
!   See the GNU General Public License for more details.
!
!   You should have received a copy of the GNU General Public License v3.0
!   along with NEXD 2D. If not, see <http://www.gnu.org/licenses/>.
!--------------------------------------------------------------------------
program mesher
    !program to mesh the given cubit files to build a MPI version of the code
    use parameterMod
    use meshMod
    use plotMod
    use errorMessage

    implicit none

    type(error_message) :: errmsg
    type (parameterVar) :: par
    type (meshVar) :: mesh
    type(movie_parameter) :: movie
    character(len=80) :: filename
    logical :: log
    integer :: myrank = 0
    character(len=6) :: myname = "mesher"

    !Create new errormessagetrace
    call new(errmsg,myname)

    ! read Parfile
    call readParfile(par, movie, myrank, errmsg)
    if (.level.errmsg == 2) then; call print(errmsg); stop; endif

    ! log?
    if (par%log) then
        write(*,*) "--------------------------------------------------------------------------------------"
        write(*,*) "start mesher for mpi version of dg2d"
        write(*,*) "--------------------------------------------------------------------------------------"
    end if

    ! create the mesh and write it to database files
    call createRegularMesh(mesh,par, errmsg)

    ! need meshVar to plot the mesh ( not good code but to debug)
    ! plot mesh
    if (par%log)  write(*,*) "plot mesh"
    call triangulation_order3_plot ( "out/mesh.ps", mesh%ncoord, dble(mesh%coord), mesh%nelem, mesh%elem, 2, 2 )
    filename = "out/pointsmesh.txt"
    call plotPoints2d(mesh%vx,mesh%vz,filename)

    call deallocMeshvar(mesh)
end program mesher
