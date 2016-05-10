function path(pred,w)
  v=w
  path = []
  while v<1000000000
        push!(path,v)
        #println("$path")
        v = pred[v]
   end
    
  return path
end