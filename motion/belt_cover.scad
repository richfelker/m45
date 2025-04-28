
pld = 0.254;
belt_x = 10-20/PI + pld;

//pts=[[3.15+2.626,11-6.35],[3.15+2.626,-11+6.35],[0.4,0]];
pts=[
	[belt_x+2.626,11-6.35],[belt_x+2.626,-11+6.35],
	[0.4,0],[0.4,-10-7],[0.4,24-7],
	[7.6,-10-7],[7.6,24-7],
];

difference() {
linear_extrude(height=4.4,convexity=3) // 2.0
translate([-2.9,-17-14/2])
offset(r=1) offset(r=-1)
square([14,2*17+14]);

translate([0,0,4.4-2.2]) // 1.6
linear_extrude(height=2.5,convexity=3)
for (p=pts) translate(p)
rotate(30) hexagon(5);
//circle(d=5);

linear_extrude(height=100,convexity=3,center=true)
for (p=pts) translate(p)
circle(d=2.9);

}

module hexagon(w) polygon([for (i=[1:6]) w/sqrt(3) * [cos(60*i), sin(60*i)]]);


$fs=.2;
$fa=5;
