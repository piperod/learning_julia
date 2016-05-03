using Images, Colors, FixedPointNumbers, ImageView
img=load("rose.png")
include("setup.jl")
include("deltastep.jl")
include("relax.jl")
include("path.jl")
graph=Array{Int64}[]
push!(graph,[1,2,1])
push!(graph,[2,3,1])
push!(graph,[3,1,4])
push!(graph,[3,4,2])
push!(graph,[4,2,5])
Delta=@time Deltastep(graph,2,1)
graph=setup(img)
size=size(graph)
f=open("output.txt","w")
for i in [10,50,100,500,1000]
Time=@elapsed Deltastep(graph,5000,i)
Alloc=@allocated Deltastep(graph,5000,i)
write(f,"Image size: $size Deltastep : $i Time Elapsed $Time Memory Allocations : $Alloc \n")
end
close(f)