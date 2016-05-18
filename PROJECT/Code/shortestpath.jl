using Images, Colors, FixedPointNumbers, ImageView
img=load("Imagenes/rose.png")
include("setup.jl")
include("deltastep.jl")
include("relax.jl")
include("path.jl")
include("shortest.jl")

A=setup(img);
tent,pred=Deltastep(A,11637,500);
P=path(pred,154455);
for p in P 
A[p]=100
end
view(A)
