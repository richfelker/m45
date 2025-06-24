eho=24; // 0.5
pt=3.2; // 0.1
lower=3;
foot_length=5;
out_angle=30;
heat_shield=true;
open_front=true;

//foot_length=3;
//lower=3;

bottom_z = -13-lower-8*cos(out_angle)-1-foot_length*sin(out_angle);

*translate([0,0,bottom_z])
color("red")
cylinder(d=20,h=1);

module end_profile() {
	hull() {
		basic_profile();
		translate([-1,10])
		square([1,1]);
	}
	foot_profile();
}

module sweep_profile() {
	basic_profile();
	foot_profile();
}

module foot_profile() {
	hull()
	rotate(90-out_angle) {
		translate([-9,-foot_length]) {
			square([1,foot_length]);
			translate([1,0])
			rotate(out_angle) translate([-1,0]) square([1,foot_length+1]);
		}
	}
}

module basic_profile() {
	translate([-9,0]) square([1,10+lower]);
	difference() {
		circle(r=9);
		circle(r=8);
		translate([0,10]) square(20,center=true);
		rotate(-out_angle)
		translate([10,0]) square(20,center=true);
	}
}

module shroud_profile() {
	offset(delta=0.5)
	hull() for (i=[0,1]) mirror([i,0,0])
	polygon([
		[0,21],[7.5,21],[14.5,9],[14.5,-3.5],[8,-14.5],[0,-14.5]
	]);
}

module shroud_printability_mask(eho=eho)
union() for (a=[0,140,-140]) rotate(a)
translate([0,-22.5-(eho-22.5)/2,-25])
rotate([45,0,0])
translate([0,0,100])
cube(200,center=true);


module attachment_body_without_holes(eho=eho) {


translate([0,0,-3])
difference() {
	linear_extrude(height=7.1+pt,convexity=3)
	difference() {
		shroud_profile();
		offset(delta=-1)
		shroud_profile();
	}
	translate([0,21,0])
	rotate([-30,0,0])
	translate([0,0,100])
	cube(200,center=true);
	translate([0,-14,3+7.1])
	scale([1,1,0.6])
	rotate([90,0,0])
	cylinder(d=15,h=10,center=true);
}


// block shroud
difference() {
intersection() {
	mirror([0,0,1])
	linear_extrude(height=40,convexity=3)
	difference() {
		union() {
			translate([0,eho/2])
			translate([0,5])
			square([2*eho,20],center=true);
			hull() {
				translate([0,25])
				square([15,10],center=true);
				square([16,29],center=true);
				translate([0,-eho])
				square([3,2],center=true);
			}
			shroud_profile();
		}
		offset(delta=-1)
		shroud_profile();
	}

	translate([0,0,-13-lower])
	hull()
	rotate_extrude(angle=360,convexity=3)
	translate([-15-(eho-22.5),0])
	basic_profile();

	shroud_printability_mask(eho=eho);

	translate([0,0,-13])
	translate([0,8,-9])
	rotate([45,0,0])
	translate([0,0,100])
	cube(200,center=true);

}
translate([0,eho,-10])
scale([1,1,0.6])
rotate([0,45,0])
cube((15-1)/sqrt(2),center=true);
}


	%*translate([0,0,-29]) {
		rotate([60,0,0])
		cylinder(d=1,h=20);
		translate([0,0,2])
		cylinder(d=18,h=7);
	}

	// magnet posts
	for (a=[0:120:240]) rotate(a)
	translate([0,-eho,-3])
	difference() {
		translate([0,0,-12])
		cylinder(d=10,h=12);
		for (i=[-1,1])
		translate([0,-1,-10])
		rotate([-30*i,0,0])
		translate([0,0,-10]) cube(20,center=true);
	}

	translate([0,0,-13-lower]) {
		// main skirt body
		difference() {
			rotate(-90)
			rotate_extrude(angle=360,convexity=3)
			translate([-15-(eho-22.5),0])
			sweep_profile();

			if (open_front)
			translate([0,10,-9])
			rotate([90,0,0])
			translate([0,0,-50])
			cube(100,center=true);
		}
	}

	// heat shield
	if (heat_shield)
	difference() {
		hull() {
			translate([0,0,-27])
			cylinder(d=21,h=1);
			translate([0,0,-20])
			linear_extrude(height=20-3,convexity=3)
			shroud_profile();
		}
		hull() {
			translate([0,0,-23])
			cylinder(d=19,h=1);
			translate([0,0,-19.5])
			linear_extrude(height=20,convexity=3)
			offset(delta=-1)
			shroud_profile();
		}
		translate([0,0,-28])
		cylinder(d=19,h=20);

		translate([0,0,bottom_z])
		mirror([0,0,1])
		cylinder(d=30,h=100);
	}
}

module skirt(eho=eho,pt=pt)
difference() {
	attachment_body_without_holes(eho=eho);
	for (a=[0:120:240]) rotate(a)
	translate([0,-eho,-3-(pt-3.2)]) {
		translate([0,0,-3.2*2])
		cylinder(d=6.75,h=7);
		translate([0,0,-3.2-1])
		cylinder(d1=6.75,d2=7.75,h=1.2);
		translate([0,0,-3.2])
		cylinder(d=7.75,h=7);
		translate([0,0,-3.2*2-5])
		cylinder(d=2.4,h=100);
		translate([0,-3,-3.2*2-10])
		cylinder(d=1.6,h=100);
	}

	// area cooling vents
	for (a=[-95:38:95]) rotate(a)
	translate([0,-15,bottom_z+1.4])
	//translate([0,-15,-3-10-9-lower])
	rotate([90,0,0])
	linear_extrude(height=2*eho,convexity=3)
	polygon([[-3,0],[3,0],[3,2],[0,3.6],[-3,2]]);

	// paperclip mount
	*translate([0,10,-16])
	rotate([0,90,0])
	cylinder(d=1,h=100,center=true);
}

*foot_profile();
*%basic_profile();

skirt();

*sweep_profile();

use <plate.scad>;
use <lower_plate.scad>;
*effector_plate_profile();

*union() {

%translate([0,0,7.1])
effector_plate(pt=2);

%
for (a=[0:120:240]) rotate(a)
translate([0,-eho,7.1/2])
translate([32003.430644,-745.6175535,-9.48/2])
import("barbell.stl",convexity=3);

%translate([0,0,-7.1+7.1]) {
lower_plate();
for (a=[0:120:240]) rotate(a)
translate([0,-eho,-3.2-3.175]) cylinder(d=6.35,h=3.175);
}

%translate([0,0,pt+7.1]) {
	translate([0,-6,-16])
	rotate([90,0,0])
	import("VolcoMosq v1.stl");

	translate([0,0,-16-(14.5-6+8.3+5.5)]) {
		translate([0,0,5.5])
		cylinder(d=11,h=8.3);

		cylinder(d1=0,d2=6,h=3);
		translate([0,0,2])
		cylinder(d=6,h=3.5);
	}
	*translate([0,0,-16-(14.5-6+8.3+5.5)+0.4])
	heatshield();
}

}

*circle(r=28);



$fs=.2;
$fa=5;
