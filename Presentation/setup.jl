using Images, Colors, FixedPointNumbers, ImageView
function setup(A)
    
	x,y = size(A)
	list=Array{Float64}[]
	img=convert(Image{Gray{Ufixed8}}, A)
    xx,yy=imgradients(img)
    c=(sqrt(xx.^2+yy.^2))
    cost=1./(c.+1)
    
	for i in x:length(A)-x
    edge=[i,i+1,cost[i+1]]
    push!(list,edge)
    edge=[i,i-1,cost[i-1]]
    push!(list,edge)
    edge=[i,i-y,cost[i-y]]
    push!(list,edge)
    edge=[i,i+y,cost[i+y]]
    push!(list,edge)
    edge=[i,i-y-1,cost[i-y-1]]
    push!(list,edge)
    edge=[i,i-y+1,cost[i-y+1]]
    push!(list,edge)
    edge=[i,i+y-1,cost[i+y-1]]
    push!(list,edge)
    edge=[i,i+y+1,cost[i+y+1]]
    push!(list,edge)
	end

return list





end
