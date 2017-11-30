# branches (in construction)
A configurable Processing class for creating organic branching structures procedurally.

# Files:
- Branch.pde: the actual class
- branches.pde: a sample sketch using the Branch class

# How to use:

   Attributes:
   
   PVector start: Start position
   PVector speed: growth speed towards an initial direction
   wid: Thickness of the initial branch (trunk).
   drift: How much the branches drift from their initial direction. If drift=0 branches will be straight lines.
   diverge: (angle) How much new child branches diverge from each other (this one is affected by drift).
   divRate min, divRateMax: (frames) Boundaries for how fast branches start to divide into children.
   Use the same value for both equal to keep branching time constant.
   
   Methods:
   
   - grow(): grows according to creation parameters
   - grow(PVector attractor, float gravity): grows towards an attracting point
   - divide(): splits the branch into two children branches
   
   TODO:
   - Color configuration
   - Pause growth
   - 3D
   - Dividing into more than 2 children


Comments? email me at juanpcarrascal@gmail.com
