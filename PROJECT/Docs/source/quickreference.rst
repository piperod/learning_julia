.. _quickreference:


Quick Reference 
===============


To launch the program right now you must follow the next steps. 

1. Start julia. 

.. code:: bash

		$ Julia -p n 

2. Load the packages needed: 

.. code:: bash

	julia> using Images, Colors, FixedPointNumbers, ImageView

3. Include the functions needed. 

.. code:: bash

	julia> Include("setup.jl")
	julia> Include("deltastep.jl")
	julia> Include("relax.jl")
	julia> Include ("path.jl")
	julia> Include("color.jl")

4. Load the image and set it up. 

.. code:: bash

	julia> img=load("Imagenes/rose.png")
	julia> Graph=setup(img)
	julia> tent,pred= deltastep(Graph,node,delta)
	julia> path (pred, node)
	julia> color(path,img)


