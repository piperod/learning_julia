.. _Images:

============
Images
============


The images in this project are very important. Specially because from them will be extracted the graphs that would allow us to run relevant  examples of  the algorihtm.  

The Images package developed by Tim Holy, was extensively used. Let us provide some insights about how this work. 

The first step is to load the image. The file should be on the same path you are executing Julia. You use the following command that would load the image as an array of pixels: 

.. code:: bash
	
	julia> using Images, Colors, FixedPointNumbers, ImageView 
	julia> img=load("rose.png")


Now we can play with  and "see" the data: 

|load|

If you want to see the image you can use the following command: 

.. code:: bash
	
	julia>  view(img)

That would open an extra window showing 

|rose|

GrayScale
**********

Now we can convert this image to gray scale, so it is easy to handle for calculations. 

.. code:: bash

	julia> A=convert(Image{Gray{Ufixed8}}, Img)
	julia> view(A)

|rosegray|

Gradient
*********
Now we can calculate gradient using the function from Images

.. code:: bash
	
	julia> xx,yy=imgradients(A)
	julia> c=(sqrt(xx.^2+yy.^2))
	julia> view(c)

|gradient|

Now we need to find a way to reduce the cost of the middle of the images but make larger the cost of the border. To so I ran the following code: 


Cost
**************
.. code:: bash 

	julia> cost=1./(c.+1)
	julia> view(cost)

|cost|

Now if you go and see the cost of the borders they will be smaller thant those outside (they will be around 1). Therefore we will have the way to form the shortest path as the border of the image. 

|costdemo|

Now we are ready to set up the graph. 


.. |costdemo| image:: ../../Imagenes/costvi.gif

.. |cost| image:: ../../Imagenes/cost.png 

.. |gradient| image:: ../../Imagenes/gradient.png

.. |load| image:: ../../Imagenes/load.gif

.. |rose| image:: ../../Imagenes/rose.png

.. |rosegray| image:: ../../Imagenes/rosegray.png