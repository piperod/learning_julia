using Images, Colors, FixedPointNumbers, ImageView
addprocs()
img=load("Imagenes/rose.png")
include("setup.jl")
include("relax.jl")
include("path.jl")
include("deltastepar.jl")
graph=setup(img)
f=open("outputpar.txt","w")
for i in [10,50,100,500,1000]
Time=@elapsed Deltastep(graph,5000,i)
Alloc=@allocated Deltastep(graph,5000,i)
write(f,"Image :$size  Deltastep : $i Time Elapsed $Time Memory Allocations : $Alloc \n ")
end
close(f)
img=load("Imagenes/escudo.jpeg")
f=open("outputescudo.txt","w")
for i in [10,50,100,500,1000]
Time=@elapsed Deltastep(graph,400,i)
Alloc=@allocated Deltastep(graph,400,i)
write(f,"  Deltastep : $i Time Elapsed $Time Memory Allocations : $Alloc \n")
end
close(f)
img=load("Imagenes/Julia.png")
f=open("outputjulia.txt","w")
for i in [10,50,100,500,1000]
Time=@elapsed Deltastep(graph,400,i)
Alloc=@allocated Deltastep(graph,400,i)
write(f,"  Deltastep : $i Time Elapsed $Time Memory Allocations : $Alloc \n")
end
close(f)
