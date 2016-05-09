using Images, Colors, FixedPointNumbers, ImageView
function setup(A)
	@everywhere x,y = size(A)
	@everywhere list=SharedArray{Any,8*x*y-2x}
	@everywhere img=convert(Image{Gray{Ufixed8}}, A)
    @everywhere xx,yy=imgradients(img)
    @everywhere c=(sqrt(xx.^2+yy.^2))
    @everywhere cost=1./(c.+1)
	@parallel for i in x:length(A)-x
    list[i]=[i,i+1,cost[i+1]]
    list[i+1]=[i,i-1,cost[i-1]]
    list[i+2]=[i,i-y,cost[i-y]]
    list[i+3]=[i,i+y,cost[i+y]]
    list[i+4]=[i,i-y-1,cost[i-y-1]]
    list[i+5]=[i,i-y+1,cost[i-y+1]]
    list[i+6]=[i,i+y-1,cost[i+y-1]]
    list[i+7]=[i,i+y+1,cost[i+y+1]]
    println("$list[i+7]")
	end

return list
end