.. _Algorithm:

========================
Delta Stepping Algorithm
========================

During this work I implemented on Julia  The delta stepping algorithm proppossed by [Meyer and Sanders] in 1998. This implementation split the Dijikstra algorithm  in phases so that each phase can be implemented on parallel as well I followed [Pintarelli et.all] In order to get the idea of each part of the algorithm and the propper way to implemented.  

The purpouse of this algorithm is to solve the so called SSSP problem (Single Source Shortest Path Problem). That can be stated as follows:

Given a weighted graph G=(V,E,c) where:

* V is a Set of vertices or nodes

* E is a set of edges, i.e., ordered pairs of nodes 

* c cost or weight function $c: E \rightarrow \mathbb{N}$, 

Find a minimal weight path from one chose node $s \in V$ called the **source node**, to all other nodes in V. We say that the nodes $v,w \in V$ are neighbours if $(v,w) \in E$, i.e., if there exists and edge between them.

The pseudocode: 
***************

|Pseudo1|

|Pseudo2|


The implementation:
*******************


Here is the code propposed for the first algorithm:


.. code:: bash 

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
    	#println("C=$C")
    	for e in E
    	    v=e[1]
    	    w=e[2]
    	    if C[v,w]>delta
    	        push!(heavy[v],e)
    	    else
    	        push!(light[v],e)
    	    end
    	end
    	#println("Heavy: $heavy")
    	#println("Light: $light")
    	#println("E=$E")
    	relax(s,0,delta,B,tent,pred,1000000000)
    	i=0
    	while isempty(B)==false
    	    println("B=$B")
    	    println("tent=$tent")
    	    #Processing vertices from B[i]
    	    if haskey(B,i)==true
    	        S=Set()
    	        #Relax 	recursively all light edges while they stay in B[i]
    	        while isempty(B[i])==false
    	            #Push to Req all light 	edges from 	vertices in B[i]
    	            Req=[]
    	            for v in B[i]
    	                println("v=$v")
    	                for e in light[v]
    	                    println("e	=$e")
    	                    push!(Req,[e[2],tent[v]+C[e[1]	,e[2]],v])
    	                end
    	            end
    	            #Update S
    	            union!(S,B[i])
    	            B[i]=Set()
    	            #Relax all 	Req edges
    	            for r in Req
    	                println("r=$r")
    	                relax(r[1],r[2],delta,B,ten	t,pred,r[	3])
    	            end
    	        end
    	        #Relax all heavy edges of vertices in S
    	        Req=[]
    	        delete!(B,i)
    	        for v in S
    	            for e in heavy[v]
    	                push!(Req,[e[2],tent[v]+C[e[1],e[2]],v	])
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


The second algorithm was implemented in the following way: 

.. code:: bash

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

Path Function 
**************

Some other functions were implemented. The following one, was implemented to retrieve the Path

.. code:: bash 

		function path(pred,w)
		  v=w
		  path = []
		  while v<1000000000
		        push!(path,v)
		        #println("$path")
		        v = pred[v]
		  end
		  return reverse(path)
		end
Example: 
********

The following is an example of how to use the algorithm. 

Let us start by setting up the graph. To do so let us define the following array: 

.. code:: bash

	graph=Array{Int64}[]
	push!(graph,[1,2,1])
	push!(graph,[2,3,1])
	push!(graph,[3,1,4])
	push!(graph,[3,4,2])
	push!(graph,[4,2,5])

|graph|

Now we have a directed graph. Let us say we want to know the shortest path to each node from the vertice 2, we will do something like: 

.. code:: bash 

	include("deltastep.jl")
	include("relax.jl")
	(tent,pred)=Deltastep(graph,2,1)

This is a simple code that runs over the graph, starting from the node 2 and with a delta of 1. 

|deltastep|

As is shown. It is obvious that going from node 2 to 2 has to have cost 0. The other nodes can be extracted very easy too. 

Parallel Delta-Stepping
=======================

The implementation provided for the Delta stepping algorithm is the following: 

.. code:: bash 

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


Some considerations
*******************

One of the problems I found when trying to implement the algorithm in parallel, was the possibility to implement Shared memory data types for different structures like dictionaries, sets and others. 

One of the solutions the community provided me when I asked on Stackoverflow was to create a set everywhere, populate it and in the end merge it. Doing this was helpful, however inefficient for memory allocations. 

Let us see an example that clarifies this concept: We want to create a dictionary of sets. We want to set every vertex of the graph as a key and initialize it in parallel. 

The first idea was simply to initialize a dictionary and then using `@parallel`
populate it. Something like this: 

.. code:: bash

	julia> C=Dict()
	julia> @parallel for item in a
    			C[item[1],item[2]]=item[3]
		   end
	julia> println("$C") 

This was the result: 

|dict|

Again we face the problem of overwriting, from the race conditions. For this reason was necessary to implement the following way:

.. code:: bash
	
	julia> @everywhere rdc(d::Dict,i::Vector)= begin d[i[1]] = length(a); d end
	julia> @everywhere rdc(d::Vector,i::Vector) = rdc(rdc(Dict(),d),i)
	julia> @everywhere rdc(d::Dict,i::Dict) = merge!(d,i)
	julia> C = @parallel (rdc) for item in a
  			item
		    end
	julia> println("$C")

Implementing this way lead me to this desired result: 

|paradict|

Several solutions like this one were useful to parallel implementation.  


.. |paradict| image:: ../../Imagenes/paradict.gif

.. |dict| image:: ../../Imagenes/dict.gif

.. |Pseudo1| image::  ../../Imagenes/algo_1.png

.. |Pseudo2| image::  ../../Imagenes/algo_2.png

.. |graph| image:: ../../Imagenes/graph.gif 

.. |deltastep| image:: ../../Imagenes/deltastep.gif 
