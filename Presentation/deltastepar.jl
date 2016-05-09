function Deltastep(list,s,delta)

    @everywhere rdc(d::Vector,i::Vector) = rdc(rdc(Dict(),d),i)
    @everywhere rdc(d::Dict,i::Vector) = begin d[i[1]] = []; d[i[2]] = [];d end
    @everywhere rdc(d::Dict,i::Dict) = merge!(d,i)
    
    
    @everywhere rdt(d::Vector,i::Vector) = rdt(rdt(Dict(),d),i)
    @everywhere rdt(d::Dict,i::Vector) = begin d[i[1]] = 1000000000000000;d[i[2]] = 1000000000000000; d end
    @everywhere rdt(d::Dict,i::Dict) = merge!(d,i)
    
    @everywhere rdcc(d::Vector,i::Vector) = rdcc(rdcc(Dict(),d),i)
    @everywhere rdcc(d::Dict,i::Vector) = begin d[i[1],i[2]] = i[3]; d end
    @everywhere rdcc(d::Dict,i::Dict) = merge!(d,i)
    
    @everywhere rds(d::Vector,i::Vector) = rds(rds(Set(),d),i)
    @everywhere rds(d::Set,i::Vector) = begin push!(d,i[1]);push!(d,i[2]); d end
    @everywhere rds(d::Set,i::Set) = union!(d,i)
    
    @everywhere rde(d::Vector,i::Vector) = rde(rde(Set(),d),i)
    @everywhere rde(d::Set,i::Vector) = begin push!(d,[i[1],i[2]]); d end
    @everywhere rde(d::Set,i::Set) = union!(d,i)
   
    
    heavy = @parallel (rdc) for item in list
      item;
    end

    light=@parallel (rdc) for item in list
        item;
    end
    
    tent= @parallel (rdt) for item in list 
        item;
    end
    
    pred= @parallel (rdt) for item in list 
        item;
    end
    
    C = @parallel (rdcc) for item in list 
        item
    end
    
    V = @parallel (rds) for item in list
    item
    end
    E= @parallel (rde) for item in list 
        item 
    end
    
    B=Dict{Any,Set}()
   
    Req=[]
    
    # println("Heavy: $heavy ")
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
    
    println("This is the answer: $tent")
  
    return tent,pred
    
   
end