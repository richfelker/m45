
use <plate.scad>;

eho=24; // 0.1
lpt=1.6;
ipt=1.6;

//eho=22.5; // 0.1

module lower_plate_base_profile(eho=eho,holes=true) difference() {
	effector_plate_profile(eho=eho,cuts=false,holes=holes);

	hull()
	for (a=[0:120:240]) rotate(a)
	cooling_hole_profile(eho=eho,w=9,l=12+2*cos(30)*(eho-22.5));
}

module lower_plate_insert_profile_old(eho=eho) {
	for (a=[0:120:240]) rotate(a) {
		*for (i=[-1,1])
		translate([i*12,-eho])
		circle(d=6.31);
		for (i=[-1,1])
		offset(r=1) offset(r=-1)
		translate([i*12,-eho+0.25])
		square([7,7.5],center=true);

		offset(r=1) offset(r=-1)
		translate([0,-eho+0.25])
		square([12,7.5],center=true);
	}
}

module lower_plate_insert_profile(eho=eho) {
	for (a=[0:120:240]) rotate(a) {
		*for (i=[-1,1])
		translate([i*12,-eho])
		circle(d=6.31);
		for (i=[-1,1])
		offset(r=1) offset(r=-1)
		translate([i*12,-eho])
		hull() {
			for (j=[0,1])
			translate([i*j*-2,0])
			ngon(6,6.5);
			*translate([i*-1.5,0])
			square(6.5,center=true);
		}

		offset(r=1) offset(r=-1)
		translate([0,-eho])
		hull() {
			for (j=[-1,1])
			translate([j*1,0])
			ngon(6,6.5);
		}
		//translate([0,-eho+0.25])
		//square([12,7.5],center=true);
	}
}

module lower_plate_profile(eho=eho) difference() {
	lower_plate_base_profile(eho=eho);
	lower_plate_insert_profile(eho=eho);
}

module lower_plate(eho=eho,pt=lpt) {
	translate([0,0,-pt])
	linear_extrude(height=pt,convexity=3)
	lower_plate_profile(eho=eho);
}



module lower_plate_insert(eho=eho,support=false,pt=ipt,lpt=lpt) {
	translate([0,0,-pt])
	difference() {
		union() {
			linear_extrude(height=pt,convexity=3)
			lower_plate_base_profile(eho=eho);
			translate([0,0,pt])
			linear_extrude(height=lpt,convexity=3)
			offset(r=-0.075)
			lower_plate_insert_profile(eho=eho);
		}

		for (a=[0:120:240]) rotate(a)
		translate([0,-eho,0]) {

			// countersunk magnet mounting/nut holes
			translate([0,0,0.6]) //difference()
			{
				linear_extrude(height=10,convexity=3)
				ngon(6,5);
				*cylinder(d=6.35,h=3);
				cylinder(d=2.7,h=100,center=true);
			}

			// wire holes
			translate([0,eho/2+2,0.6+1.4/2]) rotate([90,45,0]) cylinder(d=1.4,h=eho,center=true);

			// nut slots
			for (j=[0,1])
			translate([0,0,-1])
			for (i=[-1,1])
			translate([12*i,0,0]) {
				linear_extrude(height=2.4+1+(j>0?0.2:0),convexity=3)
				intersection() {
					ngon(6,5.5);
					if (j>0) square([10,3.2],center=true);
				}
				linear_extrude(height=2.8+1,convexity=3)
				square(3.2,center=true);
				cylinder(d=3.2,h=100,center=true);
			}
		}
	}

	// barbell interface posts
	for (a=[0:120:240]) rotate(a)
	for (i=[-1,1])
	translate([12*i,-eho,pt])
	difference() {
		cylinder(d1=6.28,d2=6,h=5.0);
		cylinder(d=3.2,h=20+pt,center=true);
	}
}


%lower_plate();
translate([0,0,-ipt]) lower_plate_insert();
*lower_plate_profile();


module ngon(n,w) polygon([
	for (i=[1:n]) w/sqrt(3) * [cos(360*i/n), sin(360*i/n)]
]);


$fs=.2;
$fa=5;
