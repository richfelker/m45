nteeth=16;
w=6;
l=400;
th=0.75;
bt=1.38;
pld=0.254;

module belt_pitch_path(nteeth=nteeth,l=l) hull() {
	translate([10,0])
	circle(d=40/PI);

	translate([20,-25])
	circle(d=2*nteeth/PI);

	translate([10+(nteeth-20)/PI,l])
	circle(d=2*nteeth/PI);
}

module belt_mockup(w=w,bt=bt,th=th,pld=pld) {
	rotate([90,0,0])
	linear_extrude(height=w,convexity=3)
	difference() {
		offset(r=bt-pld-th) children();
		offset(r=-pld-th) children();
	}
}

belt_mockup() belt_pitch_path();

$fs=.2;
$fa=5;
