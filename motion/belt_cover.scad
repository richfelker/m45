
pld = 0.254;
belt_x = 10-20/PI + pld;

//pts=[[3.15+2.626,11-6.35],[3.15+2.626,-11+6.35],[0.4,0]];
pts=[
	[belt_x+2.626,11-6.35],[belt_x+2.626,-11+6.35],
	[0.4,0],[0.4,-10-7],[0.4,24-7],
	[7.6,-10-7],[7.6,24-7],
];

difference() {
linear_extrude(height=1.6,convexity=3) // 2.0
hull()
for (p=pts)
translate(p)
circle(d=8);

translate([0,0,0.4]) // 1.6
linear_extrude(height=2.2,convexity=3)
for (p=pts) translate(p)
circle(d=5);

linear_extrude(height=100,convexity=3,center=true)
for (p=pts) translate(p)
circle(d=2.9);

}



$fs=.2;
$fa=5;
