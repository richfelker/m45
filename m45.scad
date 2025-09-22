
// frame height
h=550;

// inner diameter of extrusions
d=332;

// bed/working diameter
bd=250;

// side length of base extrusions
sl=250;

vertex_color = "#780090";
bed_color = "#2080c0";
extrusion_color = "#303030";
rail_color= "#f0f0f0";
motor_mount_color= "#606060";
carriage_color=motor_mount_color;
barbell_color="#f0f0f0";

use <frame/vertex.scad>;
use <motion/motor_mount_lower.scad>;
use <motion/motor_mount_upper.scad>;
use <motion/carriage.scad>;
use <effector/barbell.scad>;


module profile_2020() difference() {
	square(20,center=true);
	for (a=[0:90:270]) rotate(a)
	for (i=[0,1]) mirror([i,0])
	polygon([
		[-1,4],[3,4],[6,7],[6,8],[3,8],[3,11],[-1,11]
	]);
}

module profile_2040() union() for (y=[-10,10]) translate([0,y]) profile_2020();


module rail_mockup(l=h-100) union() {
	translate([0,-8/2,-l/2-10])
	cube([12,8,l],center=true);
	translate([0,-10/2-3,-10-35/2])
	cube([27,10,35],center=true);
}

module motor_mockup(l=34,sl=22) {
	module nema17_profile(inset=0) hull() {
		square([42,32-inset],center=true);
		square([32-inset,42],center=true);
	}
	color("#f0f0f0")
	translate([0,0,-sl])
	cylinder(d=5,h=sl+1);
	color("#f0f0f0")
	translate([0,0,-1])
	cylinder(d=22,h=1);
	color("#f0f0f0")
	linear_extrude(height=10,convexity=3)
	nema17_profile();
	translate([0,0,10])
	color("#303030")
	linear_extrude(height=l-22,convexity=3)
	nema17_profile(inset=3);
	translate([0,0,l-12])
	color("#f0f0f0")
	linear_extrude(height=12,convexity=3)
	nema17_profile();
}


for (a=[0:120:240]) rotate(a) {
	color(vertex_color)
	translate([0,d/2+20,0]) vertex();

	color(vertex_color)
	translate([0,d/2+20,h-40])
	top_vertex();

	color(rail_color)
	translate([0,d/2,h])
	rail_mockup();

	color(carriage_color)
	translate([10,d/2,h-30])
	rotate(90)
	render()
	carriage();

	color(barbell_color)
	translate([0,d/2-12.5-10,h-30])
	rotate([-90,0,180])
	barbell();

	translate([0,d/2+20,0])
	color(extrusion_color)
	linear_extrude(height=h,convexity=3)
	profile_2040();

	translate([10,d/2+20,100]) {
		rotate(-90)
		color(motor_mount_color)
		render()
		motor_mount_lower();
		translate([21,0,0])
		rotate([0,90,0])
		motor_mockup();
	}

	translate([10,d/2,h+8+5]) {
		color(motor_mount_color)
		rotate([90,0,0])
		render()
		motormount();
		translate([0.8,0,42/2])
		rotate([0,-90,0])
		motor_mockup();
	}

	k=d/4+10*(2+sqrt(3));
	for (z=[20,h-20])
	translate([0,-k,z])
	color(extrusion_color)
	rotate([90,0,90])
	linear_extrude(height=sl,convexity=3,center=true)
	profile_2040();
}

//use <reachable.scad>;

translate([0,0,40])
color(bed_color)
linear_extrude(height=8)
circle(d=bd);
//reachable_bed(d=d);

$fs=.2;
$fa=5;
