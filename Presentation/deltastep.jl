function Deltastep(list,s,delta)
    C=Dict()
    V=Set()
    tent=Dict()
    B=Dict{Any,Set}()
    E=Set()
    heavy=Dict()
    light=Dict()
    Req=[]
    pred=Dict()
    for item in list 
        C[item[1],item[2]]=item[3]
        push!(V,item[1])
        push!(V,item[2])
        push!(E,[item[1],item[2]])
        heavy[item[1]]=[]
        heavy[item[2]]=[]
        light[item[1]]=[]
        light[item[2]]=[]
        tent[item[1]]=10000000000000
        tent[item[2]]=10000000000000
        pred[item[2]]=10000000000000
    end
 
    # println("C=$C")

    for e in E
        v=e[1]
        w=e[2]
        if C[v,w]>delta
            push!(heavy[v],e)
        else
            push!(light[v],e)
        end
    end
    # println("Heavy: $heavy ")
    # println("Light: $light  ")
    # println("E=$E")
    relax(s,0,delta,B,tent,pred,1000000000)
    i=0
    while isempty(B)==false
        # println("B=$B")
        # println("tent=$tent")
        # Processing vertices from B[i]
        if haskey(B,i)==true
            S=Set()
            # Relax recursively all light edges while they stay in B[i]
            while isempty(B[i])==false
                # Push to Req all light edges from vertices in B[i]
                Req=[]
                for v in B[i]
                    # println("v=$v")
                    for e in light[v]
                        # println("e=$e")
                        push!(Req,[e[2],tent[v]+C[e[1],e[2]],v])
                    end
                end
                # Update S
                union!(S,B[i])
                B[i]=Set()
                
                # Relax all Req edges
                for r in Req
                    # println("r=$r")
                    relax(r[1],r[2],delta,B,tent,pred,r[3])
                end
            end
            # Relax all heavy edges of vertices in S
            Req=[]
            delete!(B,i)
            for v in S
                for e in heavy[v]
                    push!(Req,[e[2],tent[v]+C[e[1],e[2]],v])
                end
            end
            for r in Req
                relax(r[1],r[2],delta,B,tent,pred,r[3])
            end
        end
        
        i=i+1
    end
    
    # println("This is the answer: $tent")
  
    return tent,pred
    
   
end