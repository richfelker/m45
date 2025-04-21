

idler_y = 25;
idler_x = 10;

upper_h=31;
lower_h=16;

belt_width = 6;
belt_distance = (belt_width==6) ? 5 : 3;
bearing_od = (belt_width==6) ? 10 : 12;
bearing_id = (belt_width==6) ? 5 : 8;
flange_width = (belt_width==6) ? 1.5 : 0;
belt_clearance = belt_distance - flange_width - 0.5;

difference() {
	union() {
		//column plate
		difference() {
			translate([0,6/2,upper_h/2-lower_h/2])
			cube([40,6,42+upper_h+lower_h],center=true);

			translate([0,belt_clearance,0])
			hull() {
				// motor pulley hole
				//for (p=[[0,0,0],[0,0,400]]) translate(p)
				rotate([-90,0,0])
				cylinder(d=16,h=50);

				// idler hole
				//for (z=[0,50]) translate([0,0,z])
				translate([idler_x,0,idler_y])
				rotate([-90,0,0])
				cylinder(d=14,h=50);
			}

			// bearing hole
			translate([0,0.8,0])
			rotate([-90,0,0]) {
				tdcyl(d=bearing_od,h=50,a=180,f=1.5);
				tdcyl(d=bearing_od-1,h=50,a=180,f=1.5,center=true);
			}
			*translate([0,0.5,0])
			rotate([-90,0,0]) {
				tdcyl(d=bearing_od,h=50,a=180,f=1.5);
				//tdcyl(d=bearing_od-1,h=50,a=180,f=1.25,center=true);
				translate([0,0,-0.5-0.01])
				cylinder(d1=bearing_od-0.75,d2=bearing_od,h=0.52);
				intersection() {
					cube([bearing_id,50,50],center=true);
					tdcyl(d=bearing_od,h=50,a=180,f=1.5,center=true);
				}
			}

			// idler hole
			translate([idler_x,0.8,idler_y])
			rotate([-90,0,0])
			tdcyl(d=16,h=150,f=1.25,a=180);

			// region needing belt clearance
			translate([0,belt_clearance,-8])
			cube(100);

			translate([idler_x+3,7,-8])
			cylinder(r=6,h=100);
			
			difference() {
				translate([idler_x+3,-25,-8])
				cube(100);
				*translate([idler_x,0,idler_y])
				rotate([-90,0,0])
				tdcyl(d=15,h=150,f=1.25,a=180,center=true);
			}
		}

		// motor plate
		difference() {
		translate([0,20.5,0])
		rotate([90,0,0])
		linear_extrude(height=6,convexity=3)
		for (i=[0,1],j=[0,1]) mirror([i,0]) mirror([0,j])
		polygon([
			[0,0],[0,21],[21-5.5/2,21],[21,21-5.5/2],[21,0]
		]);
		// cutout for idler
		hull() for (p=[[0,0,0],[20,0,-7]])
		translate(p+[idler_x,20.5-4.5,idler_y])
		rotate([90,0,0])
		cylinder(d=20,h=3);
		}

		// idler shaft holder
		translate([idler_x,20.5,idler_y])
		hull() for (z=[0,-10])
		translate([0,0,z])
		rotate([90,0,0])
		cylinder(d=16,h=4.5);

		// idler pulley inner race spacer
		translate([idler_x,22-5,idler_y])
		rotate([90,0,0])
		hull() {
			cylinder(d=8,h=1.5);
			translate([0,0,-1.5])
			tdcyl(d=8,h=1,a=180);
		}

		// inside extrusion channel
		translate([10,-6/2,upper_h/2-lower_h/2])
		cube([5.95,6,42+upper_h+lower_h],center=true);

		// idler shaft mount
		translate([idler_x,0,idler_y])
		intersection() {
			rotate([-90,0,0])
			cylinder(d1=11,d2=8,h=1.5);
			// only 0.5 mm out, not 1.0
			//cylinder(d1=9,d2=8,h=1,center=true);
			cube([5.9,10,20],center=true);
		}

		// back wraparound plate
		translate([-20-6/2,6-26/2,upper_h/2-lower_h/2])
		cube([6,26,42+upper_h+lower_h],center=true);

		// idler cover
		difference() {
			translate([-18.25,0,21])
			rotate([90,0,90])
			linear_extrude(height=18.25+14.5,convexity=3)
			polygon([
				[20.5,0],[20.5,16.5],[16,21],[6,21],[6,31],[0,31],
				[0,8],[16,-8]
			]);
			// idler arm opening for idler pulley
			rotate([90,0,0])
			linear_extrude(height=2*16,center=true,convexity=3)
			polygon([
				[2,0],[2,29],[17,39],[17,0]
			]);
		}
		// extra side support/screw conduit
		multmatrix([
			[1,0,0],
			[0,1,0],
			[0,-2/3,1]
		])
		translate([-18.25,0,21-4])
		cube([5.5,20,5.5*2]);

		// bottom feet
		for (i=[-1,1])
		translate([i*31/2,6,-42/2])
		union() {
		translate([0,0,5.5])
		rotate([-90,0,0]) cylinder(d=6,h=10);
		rotate([90,0,90])
		linear_extrude(height=6,center=true,convexity=2)
		polygon([
			[0,5.5],[0,-16],[8.5,-16],[14.5,0],[14.5,5.5]
		]);
		}

	}

	// top mounting holes
	for (i=[-1,1])
	translate([-10*i,4,21+upper_h-6])
	rotate([-90,0,0]) {
		tdcyl(d=3.2,h=100,a=180,center=true);
		tdcyl(d=5.7,h=100,a=180);
	}

	// bottom mounting holes
	for (i=[-1,1])
	translate([-10*i,4,-21-lower_h+7])
	rotate([-90,0,0]) {
		tdcyl(d=5.2,h=100,a=180,center=true);
		tdcyl(d=8.3,h=100,a=180,f=1.3);
	}

	// back wraparound mounting hole
	for (z=[-25,35,5])
	translate([-20-2,-10,z])
	rotate([0,-90,0]) {
		tdcyl(d=5.5,h=20,a=-90,center=true);
		tdcyl(d=10.5,h=20,a=-90,center=false);
	}

	// motor center opening
	translate([0,20,0])
	hull() {
		rotate([90,0,0])
		tdcyl(d=25,h=20,center=true,f=1.5);
		translate([0,0,-42/2-1])
		cube([25,20,1],center=true);
	}

	// motor screw holes
	translate([0,5.6-1.5,0])
	for (i=[-1,1], j=[-1,1])
	translate([31/2*i,0,31/2*j])
	rotate([90,0,0]) {
		tdcyl(d=3.2,h=100,center=true);
		if (i!=1 || j!=1)
		tdcyl(d=5.5,h=5.61,center=false);
	}
	translate([0,16+4-1.5,0])
	translate([31/2,0,31/2])
	rotate([90,0,0])
	tdcyl(d=5.5,h=4.1,center=false);

	// idler shaft hole
	translate([idler_x,-7,idler_y])
	rotate([-90,0,0]) {
		tdcyl(d=5.1,h=26,a=180,f=1.5);
		hull() {
			tdcyl(d=5.1,h=2,a=180,f=1.5);
			translate([0,0,-1])
			scale([1,1.2,1])
			tdcyl(d=5.1,h=1,a=180,f=1.5);
		}
		tdcyl(d=3.2,h=100,a=180,f=1.5,center=true);
	}

	for (x=[-2.6,18.5])
	translate([x,0,21+upper_h])
	rotate([0,45,0])
	cube([10,100,10],center=true);

	// middle belt hole
	hull() {
		translate([-2.5,belt_clearance,0])
		translate([-7/2,0,0])
		cube([7,7,60]);
		translate([-2.5,11,0])
		cylinder(r=3.5,h=60);
		translate([-7.5,belt_clearance,0])
		cube([7.5,12,1]);
	}

	// cutout for lower t nut in channel
	translate([10,-1.3,-21-lower_h+7+5/2+2.2])
	translate([0,-10/2,-50/2])
	hull() {
		cube([10,10,50],center=true);
		translate([0,-1,50/2])
		cube([10,1,6],center=true);
	}

	// cutout for upper t nut in channel
	translate([10,-0.7,21+upper_h-7-3+0.2])
	translate([0,-10/2,50/2])
	cube([10,10,50],center=true);
}



// motor plate
*translate([0,22-6/2,0])
difference() {
	cube([42,6,42],center=true);
	rotate([90,0,0])
	cylinder(d=23,h=10,center=true);
	for (i=[-1,1], j=[-1,1])
	translate([31/2*i,6/2-3,31/2*j])
	rotate([90,0,0]) {
		tdcyl(d=3.2,h=20,center=true);
		tdcyl(d=5.5,h=20,center=false);
	}

}




module outline(r=2)
difference() {
	union() children();
	offset(r=-r) union() children();
}



// belt path
%translate([0,belt_distance,0])
mirror([0,1,0])
rotate([90,0,0])
linear_extrude(height=belt_width,convexity=3)
outline(r=1.5)
offset(r=0.85)
belt_path();

module belt_path()
hull() {
circle(d=11.7);
*circle(d=13.7);
translate([idler_x,idler_y])
circle(d=13.7);
*translate([idler_x+1,400])
circle(d=11.7);
translate([idler_x,400])
circle(d=13.7);
}



// column
*
translate([0,-20/2,0])
cube([40,20,100],center=true);

module pulley(pd,od,h,center=false)
translate([0,0,center?0:h/2]) {
	cylinder(d=pd-1,h=h-2,center=true);
	for (i=[0,1]) mirror([0,0,i])
	translate([0,0,h/2-1])
	cylinder(d=od,h=1);
}


// motor pulley
%
translate([0,belt_clearance+0.5,0])
rotate([-90,0,0])
pulley(pd=10.16,od=13.9,h=belt_width+3.5);
//cylinder(d=12,h=9,center=false);

// idler
%
translate([idler_x,1.5,idler_y])
rotate([-90,0,0])
//cylinder(d=15,h=9,center=false);
//cylinder(d=13.7,h=9,center=false);
pulley(pd=12.73,od=15,h=14);



// motor
*translate([0,22+34/2,0])
cube([42,34,42],center=true);


*translate([20+332/2,-10,-100])
cylinder(d=332-16-2,h=100);


a=-10;
*translate([20+8+1,0,0])
translate([+126+25,0,0])
rotate(a)
translate([-126-25,0,0])
rotate(-a)
hull() for (i=[0,1]) mirror([0,i,0])
translate([0,63/2-9.5/2,0])
sphere(d=9.5);




*translate([13-3,24,0])
rotate([90,0,0])
cylinder(d=5,h=21);







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

module extrude_curve(r,a) {
	rotate([90,0,-90])
	translate([-r,0,0])
	rotate_extrude(angle=a,convexity=2)
	translate([r,0]) children(0);

	if ($children > 1)
	translate([0,r,0])
	rotate([-a,0,0])
	translate([0,-r,0])
	children([1:$children-1]);
}

module extrude_straight(l) {
	linear_extrude(height=l,convexity=2)
	children(0);
	if ($children > 1)
	translate([0,0,l])
	children([1:$children-1]);
}


*translate([50,0,0])
extrude_straight(10) {
square([16,6],center=true);
extrude_curve(11,60) {
square([6,16],center=true);
}}

*extrude_curve(20,45) {
	circle(d=10);
	rotate(180)
	extrude_curve(20,45)
	circle(d=10);
}

module ngon(n,w) polygon([
	for (i=[1:n]) w/sqrt(3) * [cos(360*i/n), sin(360*i/n)]
	]);


$fs=.2;
$fa=5;
