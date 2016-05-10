function shortestpath(img,v,w)
	A=setup(img);
	
	tent,pred=Deltastep(A,v,50000);
	P=path(pred,w);
	for p in P 
		A[p]=100
	end
	return A 
end


