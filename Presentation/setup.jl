using Colors
function setup(A)
	node=Array{Int64}[]
	x,y = size(A)
	list=Array{Float64}[]
	A=convert(Image{Gray{Ufixed8}}, A)
	for i in x:length(A)-x
		
		color1=colordiff(color(A[i]),color(A[i+1]))+1
		edge=[i,i+1,color1]
		push!(list,edge)
		color1=colordiff(color(A[i]),color(A[i-1]))+1
		edge=[i,i-1,color1]
		push!(list,edge)
		color1=colordiff(color(A[i]),color(A[i-y]))+1
		edge=[i,i-y,color1]
		push!(list,edge)
		color1=colordiff(color(A[i]),color(A[i+y]))+1
		edge=[i,i+y,color1]
		push!(list,edge)
	end

return list





end
