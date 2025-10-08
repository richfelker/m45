module barbell() union() {
	for (i=[0,1]) mirror([i,0,0]) {
		translate([34/2,0,0])
		rotate([0,90,0])
		cylinder(d=4.75,h=10);
		translate([50/2,0,0])
		sphere(d=3/8*25.4);
	}

	difference() {
		intersection() {
			cube([34.3,16,7.1],center=true);
			rotate([0,90,0]) cylinder(d=11,h=100,center=true);
		}
		translate([0,-3.95,-2.15])
		translate([-50,0,0])
		mirror([0,1,0])
		mirror([0,0,1])
		cube(100);

		for (i=[0,1]) mirror([i,0,0])
		translate([12,0,-1.445]) {
			cylinder(d=6.31,h=100);
			cylinder(d=3.5,h=100,center=true);
		}
	}
}

barbell();


$fs=.2;
$fa=5;
