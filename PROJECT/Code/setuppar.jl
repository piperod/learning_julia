using Images, Colors, FixedPointNumbers, ImageView
function setup(A)
	x,y = size(A)
	list=SharedArray{Any,8*x*y-2x}
	img=convert(Image{Gray{Ufixed8}}, A)
    xx,yy=imgradients(img)
    c=(sqrt(xx.^2+yy.^2))
    cost=1./(c.+1)
	@parallel for i in x:length(A)-x
    list[i]=[i,i+1,cost[i+1]]
    list[i+1]=[i,i-1,cost[i-1]]
    list[i+2]=[i,i-y,cost[i-y]]
    list[i+3]=[i,i+y,cost[i+y]]
    list[i+4]=[i,i-y-1,cost[i-y-1]]
    list[i+5]=[i,i-y+1,cost[i-y+1]]
    list[i+6]=[i,i+y-1,cost[i+y-1]]
    list[i+7]=[i,i+y+1,cost[i+y+1]]
	end

return list
end