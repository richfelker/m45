
motor_offset = 1.5;
nteeth = 16;

module tdcircle(d,a=0,f=1) {
	hull() {
		circle(d=d);
		rotate(a)
		translate([0,d/2/sqrt(2)/f])
		rotate(45)
		square(d/2,center=true);
	}
}

module tdcyl(d,h,a=0,f=1,center=false) {
linear_extrude(height=h,center=center,convexity=3)
tdcircle(d=d,a=a,f=f);
}

module motormount() {

	translate([0,0,-(10+(nteeth-20)/PI)])
	difference() {

		union(){
			intersection() {
				union() {
					// motor
					%translate([motor_offset+2,42/2,0])
					rotate([0,90,0])
					cylinder(d=5,h=18);
					%translate([motor_offset,42/2,0])
					rotate([0,90,0])
					cylinder(d=22,h=2);

					// pseudo pulley
					%translate([3,42/2,0])
					rotate([0,90,0])
					pulley();

					// double shear bearing
					%translate([19,42/2,0])
					rotate([0,90,0])
					cylinder(d=13,h=4);

					// bottom
					translate([-20,-8,-42/2])
					cube([20+2+22+2,8-0.2,42]);

					// main block
					difference() {
						translate([motor_offset,-8,-42/2])
						cube([2+22+2-motor_offset,42+8,42]);
						translate([18,42/2+2,-22.2/2])
						cube([6,10,22.2]);
					}
				}

				linear_extrude(height=100,center=true,convexity=3)
				polygon([
					[-36,-8],[2+22+2,-8],[2+22+2,42/2],
					[6+1.5,42-6],[6+1.5,42],[motor_offset,42],[motor_offset,0],[-36,0]
				]);
			}
			// bearing holder
			translate([19,42/2,0])
			rotate([0,90,0])
			cylinder(d=18,h=6);

			// second top column mount point
			translate([-10,0-0.2,-42/2])
			rotate([90,0,0])
			linear_extrude(height=8-0.2,convexity=3)
			hull() {
			translate([-10,0]) square([20,1]);
			translate([0,(nteeth-20)/PI])
			circle(d=14);
			}
		}


		// belt hole
		translate([0,-10,-22.2/2])
		cube([14,10+21,22.2]);

		// pulley access hole
		hull() for (y=[0,100])
		translate([7.5,42/2+y,0])
		rotate([0,90,0])
		cylinder(d=22.2,h=19-7.5);

		// bearing hole
		translate([19-1,42/2,0])
		rotate([0,90,0]) {
			tdcyl(d=13,h=4+1,f=1.5);
			translate([0,0,-5])
			cylinder(d=9,h=15);
		}

		// chamfers
		for (x=[-20,2+22+2],z=[-42/2,42/2])
		if (x>0 || z>0)
		translate([x,0,z])
		rotate([0,45,0])
		cube(sqrt(2)*[4,100,4],center=true);
		for (z=[-42/2,42/2])
		translate([0,42,z])
		rotate([45,0,0])
		cube(sqrt(2)*[100,4,4],center=true);

		// panel
		translate([2+22,-8,0])
		hull() {
			translate([0,0,-20/2])
			cube([2,20,20]);
			translate([2,-2,-24/2])
			cube([2,24,24]);
		}

		// motor cooling grooves
		for (z=[-13,-3,6,14])
		translate([0,0,z])
		rotate([45,0,0])
		translate([-100-((abs(z)<10) ? -2 : 4),-2,-2])
		cube([100,4,4]);

		// motor shaft & pulley hole
		translate([-1,42/2,0])
		rotate([0,90,0])
		tdcyl(d=22,h=1+14,f=1.25);
		translate([-1,0,-22/2])
		cube([2,42/2,22]);

		// screw holes
		translate([motor_offset,42/2,0])
		for (i=[-1,1],j=[-1,1])
		translate([0,31/2*i,31/2*j])
		rotate([0,90,0]) {
			tdcyl(d=3.2,h=100,center=true,a=0);
			translate([0,0,2])
			tdcyl(d=5.8,h=100,a=0);
		}

		// column end mount screw holes
		translate([-10,0,(nteeth-20)/PI]) {
			for (z=[0,-20]) translate([0,-6.2,z])
			rotate([-90,0,0])
			{
				cylinder(d=10.5,h=50);
				cylinder(d=5.3,h=100,center=true);
			}
		}
	}
}

//rotate(180)
//rotate(-135)
rotate([90,0,0])
{
motormount();

// 2040
%
translate([0,-8,0])
translate([-20,-100,-40])
cube([20,100,40]);

}



// belt path mockup

use <belt_path.scad>;
belt_distance=5;
belt_width=6;

%rotate(90)
translate([0,-belt_distance,-375+21])
belt_mockup(w=belt_width) belt_pitch_path(l=375);




// 13.7-11.3 = 2.4

module pulley() {
	cylinder(d=13.9,h=1.5);
	translate([0,0,1.5])
	cylinder(d=11.3,h=7);
	translate([0,0,8.5])
	cylinder(d=13.9,h=7);
}



$fs=.2;
$fa=5;
