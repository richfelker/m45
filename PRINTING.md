# M45 Printed Parts Guide


## Printed Parts BOM

- Lower vertex from `vertex.scad` (3)
- Upper vertex from `vertex.scad` (3)
- Lower motor mount from `motor_mount_lower.scad` (3)
- Upper motor mount from `motor_mount_upper.scad` (3)
- Carriage from `carriage.scad` (3)
- Carriage belt cover from `belt_cover.scad` (3)
- Ball cup end from out-of-tree `ballcupend.scad` (12)

Effector parts pending release are missing from the above list.
Likewise are a number of cosmetic and quality-of-life parts for
mounting wiring and electronics, CPAP blower, etc.

Ball cup ends are available from
<https://github.com/richfelker/delta-ballcup>.

Semitruck extruder (optional) is available from
<https://github.com/richfelker/semitruck>.


## General Concepts

All structural and motion system parts should be printed with
sufficiently many perimeters to ensure all screw-clamped faces consist
entirely of perimeters (no infill zone). With 0.5 mm extrusion line
width, 4 or more perimeters are recommended. Infill density is not
critical, but 25-30% is recommended.

All parts are oriented as intended for printing when rendered and
exported from OpenSCAD. Printing orientation is important so that Z
reproducibility and bed flatness do not affect dimensions relevant to
frame or motion system squareness or mechanical function. In
particular, the vertices are intended to print on a corner tilted at a
45° angle. Attempting to print them flat will result in sockets that
do not fit the 2040 extrusions correctly and will break the
self-squaring property of the frame if this is merely "fixed in
postprocessing". If bed adhesion is a problem due to the small contact
surface, a brim or support structure can be used.

Design dimensions reflect actual intended dimensions of the printed
part; they do not include fudge factors for shrinkage, etc. If
printing with a material that will undergo any significant shrinking,
or that will be annealed after printing, compensation for this should
be calibrated in the slicer and tested before printing large parts.

Print material should be rigid, non-creeping, and capable of handling
the temperatures it will be exposed to. With the motors in the BOM
running at 48V, motor mounts should be expected to handle at least
60°C in open air, higher if enclosed. The rest of the frame and motion
components should only see ambient/enclosure temperature.


## OpenSCAD Usage

Until there are packaged releases with prebuilt STL files, parts need
to be exported using OpenSCAD for printing. `vertex.scad` can be used
to obtain both the upper and lower versions by selecting the
positional variant in the customizer tab of the OpenSCAD user
interface. The other files are all individual parts.
