.. _Introduction:

============
Introduction
============

Julia language is a high-level, high-performance dynamic programming language for technical computing. Between several other features  it provides a sophisticated compiler and distributed parallel execution, that allows the user to code sophisticated applications. Given the novelty of the language, is hard to find documentation that help the beginners and new learners to understand the core concepts and advantages of using Julia. For this reason, and mostly as a new learner, I provide this work that show by example some usages and advantages of using `Julia <julialang.com/docs>`_ . 

The example I will be refering to is the Delta-stepping algorithm. Which is a clever proposition developed by  Madduri et. all. In their paper Parallel Shortest Path Algorihtm for Solving Large Scale Instances; along with the one by M. Kranjcevic $\Delta$-Stepping Algorithm for Shared Memories Architectures. 

This algorithm will be specially used  to find the contour of an image. Using the package `Images <https://github.com/timholy/Images.jl>`_ I converted the image to gray scale and calculate the gradient to compute a function cost. Later I  set a directed graph where the pixels where the nodes and the cost to go to a neighbor pixel with different color was high, then using the delta-stepping algorithm I can find the shortest path, which was also the contour. 

A parallel implementation in Julia of this algorithm is propposed. For this implementation I ran several test to evaluate it's performance. In particular three images were selected. 

There are many changes that still have to be done. In the next version, I will be updating the implementation changing the buckets from a dictionary of sets(not very efficient) to a shared list (to provide better parallelism). As well I will be working on the tutorials so that clear and nicer examples can be shown. 

Note: All the information  provided here is based on the Official Documentation of Julia, any other source will be cited explicitely.  

A Little Bit of Julia. 
***********************

Instalation might be very tricky. However for learning I suggest you to download the binary extension that can be found `Here <http://julialang.org/downloads/>`_ 

When you have it go to the folder `julia/bin` and simply execute `Julia`. Like:

.. code:: bash
    
    julia 

|first|

This initialization would start julia by default with one process. If you want to start with more processes you need to specify it with the following command (It makes sense when -p # correlates with the number of processors on your machine). For example on mine two cores.  

.. code:: bash
    
    julia -p 2 

|startp| 

In case you forget to start with this command, you can add more procs from the julia command line:

.. code :: bash 

  addprocs()

|addprocs|

Which will add all the available processors by default, but you can specify too just puting inside the parenthesis as many process as cores has your machine. 

You can get at any momment the number of available workers by running the following code: 

.. code:: bash
  
    nprocs()

|nprocs|

=================
Julia Parallelism
=================
``Julia provides a multiprocessing environment based on message passing to allow programs to run on multiple processes in separate memory domains at once.

Julia’s implementation of message passing is different from other environments such as MPI [1]. Communication in Julia is generally “one-sided”, meaning that the programmer needs to explicitly manage only one process in a two-process operation. Furthermore, these operations typically do not look like “message send” and “message receive” but rather resemble higher-level operations like calls to user functions.``


Low-level Parallelism
*********************



``Parallel programming in Julia is built on two primitives: remote references and remote calls. A remote reference is an object that can be used from any process to refer to an object stored on a particular process. A remote call is a request by one process to call a certain function on certain arguments on another (possibly the same) process.``

These references, however,  are low-level. Therefore is not recomendable to use them unless is very necessary for specific things. Usually higher level functions would provide very efficient performance. 

Some basic functions are: 

*  `remotecall()`: Call a function asynchronously on the given arguments on the specified process. Returns a Future. Keyword arguments, if any, are passed through to func.
* `fetch()`: Waits and fetches a value from x depending on the type of x. Does not remove the item fetched:
* `@spawn`: Creates a closure around an expression and runs it on an automatically-chosen process, returning a RemoteRef to the result.
* `@spawnat`: Accepts two arguments, p(process) and an expression. A closure is created around the expression and run asynchronously on process p. Returns a Future to the result.

Examples:
*********

In the following example the remotecall function would be used to automatically run the function fill `fill` which basically fills an array of 2 by 2 with numbers 3. Then we can fetch the result of that remote reference and store in a variable `ref`. Then using `@spawnat` we can specify where we want to implement certain function, in this case we want to multiply the array declared by 2, giving as a result a 2 by 2 array with numbers 6. 



|remotecall|

High Level Parallelism 
**********************

* @parallel (reducer) : Like the openmp `#pragma parallel for`  
  This one is often used in for loops.  HOWEVER IS IMPORTANT TO DEFINE THE REDUCER PROPERLY!
  
* pmaps() : This is a parallel execution for more complicated parallel initializations. 

* SharedArray : This structure is used for shared memory computations
            

* @time : This profile tool measure the time. Shown After the execution. 

* @elapsed : This profile tool measure the time, but does show the output  time rather than the function. 

* @Allocated: This profiling tool measure the allocations in memory. 

Examples:
*********

The following example would show why is important to be carefull when using `@parallel` using it without declaring a shared array might cause the following problem: 

|parallelfor|


   
.. |first| image:: https://github.com/piperod/learning_julia/blob/master/Presentation/Imagenes/start.gif?raw=true

.. |startp| image:: https://github.com/piperod/learning_julia/blob/master/Presentation/Imagenes/startp2.gif?raw=true

.. |addprocs| image:: https://github.com/piperod/learning_julia/blob/master/Presentation/Imagenes/addprocs().gif?raw=true

.. |nprocs| image:: https://github.com/piperod/learning_julia/blob/master/Presentation/Imagenes/nprocs.gif?raw=true

.. |remotecall| image:: https://github.com/piperod/learning_julia/blob/master/Presentation/Imagenes/remotecall.gif?raw=true

.. |parallelfor| image:: https://github.com/piperod/learning_julia/blob/master/Presentation/Imagenes/parallel.gif?raw=true
