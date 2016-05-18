function relax(w,d,delta,B,tent,pred,v)
    # println("w : $w")
    
    if d<tent[w]
        old_i=floor(tent[w]/delta)
        tent[w]=d
        
        if (haskey(B,old_i)==true)
            delete!(B[old_i],w)
            
        else
            # println("Warning: In relax (w=$w,d=$d,delta=$delta), B[old_i=$old_i] not found")
        end
        #Add w to new bin and update its tent
        new_i=floor(d/delta)
        if (haskey(B,new_i)==false)
            B[new_i]=Set()
            # println("Warning: In relax (w=$w,d=$d,delta=$delta), allocated B[fld=$new_i].")
        end
        push!(B[new_i],w)
        tent[w]=d
        if (haskey(pred,w)==false)
            pred[w]=()
            pred[w]=v
            # println("Warning: In relax (w=$w,d=$d,delta=$delta), allocated B[fld=$new_i].")
        else 
            pred[w]=v
        end
        
        # println("The previous node visited was: $pred")
    end
end
        