Parallel-Tempering-Harlem-Shake
===============================

Code for Metropolis Hastings vs Parallel Tempering comparison

Run the script from :harlemshakePT.m 
This code was used to make the video: https://www.youtube.com/watch?v=J6FrNf5__G0

All of this is dased on code from https://www.youtube.com/watch?v=Vv3f0QNWvWQ
In that video they compare Metropolis Hastings with Hamiltonian Monte Carlo.
This demo build on code from: from http://github.com/duvenaud/harlemcmc-shake

Combining both examples this provides the ability to compare all of Metropolis Hastings vs Hamiltonian Monte Carlo  vs  Parallel Tempering.


The quick version is that Hamiltonian Monte Carlo is a vital tool for sampling from distributions defined on manifolds, skewed or long tail distributions.  Parallel Tempering is the best tool for multimodal densities but also is super useful on skewed and long tail distributions.  Parallel tempering works ok on densities defined on manifolds but Hamiltonian Monte Carlo is not a good tool for multi-modal densities.  
