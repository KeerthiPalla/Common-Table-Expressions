The Fairfield University Mars Automated Rover (FUMAR) is a 
motorized robot that sits on a flat plane on the surface of Mars and takes 4 soil samples 
every day.  The four locations are determined at random, but are all within 100 meters on
the X and Y axis of the point where the probe came to rest.  The software you are writing
will determine the shortest path that the probe can possibly take to reach all four points.

The FUMAR always travels in a straight line between sites.  There are no obstructions on
the polar plane for it to avoid.

Consider the following diagram:
                                                  
                                                  |+100  
                                                  |
                                                  |  X <-- Site 4 (4, 90)
                                                  |
                                                  |+80
                                                  |
     X <-- Site 3 (-92, 70)                       |
                                                  |
                                                  |+60
                                                  |
                                                  |
                                                  |
                                                  |+40
                                                  |                 X <-- Site 2 (36, 34)
                                                  |
                                                  |
                                                  |+20
                                                  | 
-100     -80       -60       -40       -20        |        +20       +40       +60       +80	  +100 
|---------|---------|---------|---------|---------O---------|---------|---------|---------|---------|
                                                 /|
                                                / |
                                               /  |
                  Original FUMAR Location (0,0)   |-20      X <-- Site 1 (20, -20)
                                                  |
                                                  |
                                                  |
                                                  |-40
                                                  |
                                                  |
                                                  |
                                                  |-60
                                                  |
                                                  |
                                                  |
                                                  |-80
                                                  |
                                                  |
                                                  |
                                                  |-100

The FUMAR must move from the origin to all 4 sites in the order that makes for the overall shortest path.
The FUMAR *will not* neccessarily move from Site 1, to Site 2, etc.
The FUMAR comes to rest at the last point reached, it does not return to the origin.

This is a variation of a travelling salesman problem.  The expected solution will use brute force, which
is appropriate in this case (the number of points are very small, and the cost of making the FUMAR travel
an imperfect path is very expensive).  A brute force solution calculates all possible paths, and picks
the shortest one.  Numerous other potential solutions exist.