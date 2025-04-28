th=0.75;
bt=1.62;
pld=0.254;

// origin is corner of 2040 column
module profile() {
	t=6.5;
	difference() {
		// base
		translate([-t-13,-13.5])
		square([t+13+3.15+8,13.5+20+8+2]);
//		translate([-t-13,-13.3])
//		square([t+13+3.15+8,13.3+20+8+2]);
		// barbell clearance & aesthetic
		translate([-t-13-5,-13])
		circle(r=8.5);
		translate([-t-13-5,20+13])
		circle(r=8.5);
		// block
		translate([-13,-3.5])
		translate([-0.05,0])
		square([10.1,27.0]);
		// belt coupler
		*translate([-3.1,-5-6.1])
		square(100);
		*translate([-3.1,-7.1])
		square(100);
		*translate([2.2,-11.3])
		square(100);
		// back reinforcement plate
		translate([-3,-4.7])
		square(100);
		// 2040 with 1mm clerance
		translate([-13,-1])
		square(100);
		// back corner cutout
		*translate([13,-13])
		circle(r=4-1);
	}
}

module hexagon(w) polygon([for (i=[1:6]) w/sqrt(3) * [cos(60*i), sin(60*i)]]);

module screwhole_old(d1,d2=d1,l1,l2) {
	for (i=[0,1])
	translate([0,0,i*l1])
	mirror([0,0,i])
	cylinder(d1=d1+1.5,d2=d1-0.5,h=1,center=true);
	cylinder(d=d1,h=l1);
	translate([0,0,l1])
	cylinder(d=d2,h=l2);
	translate([0,0,l1+l2])
	cylinder(d1=d2-0.5,d2=d2+1.5,h=1,center=true);
}

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

module screwhole(d1,d2=d1,l1,l2,a) {
	f2=sqrt(2)*(1+1/1.5)/2;
	for (i=[0,1])
	translate([0,0,i*l1])
	mirror([0,0,i])
	cylinder(d1=d1*(2*f2-1),d2=d1-0.0,h=1,center=true);
	cylinder(d=d1,h=l1);
	if (!is_undef(a))
	translate([0,0,-0.5])
	tdcyl(d=d1,h=l1+1,f=1.5,a=a);
	translate([0,0,l1]){
		cylinder(d=d2,h=l2);
		if (!is_undef(a))
		tdcyl(d=d2,h=l2+0.5,f=1.5,a=a);
	}
	translate([0,0,l1+l2])
	cylinder(d1=d2-0.0,d2=d2*(2*f2-1),h=1,center=true);
}


*translate([0,0,-33])
color("red")
cylinder(d=5,h=15);

module carriage() union() {
difference() {
	ex=14;
	sa=0;
	translate([0,0,+ex/2])
	linear_extrude(height=34+ex,center=true,convexity=3)
	offset(r=0.5) offset(r=-0.5)
	profile();

	// barbell alignment
	translate([-5.5-2-13+0.05,-50,-50+4])
	cube([2.0,100,50]);
	*translate([-5.5-13+0.05-8/2,10+5/2,-40/2+4])
	cube([8,34.3+5,40],center=true);

	// block mount screw holes
	translate([0,10,0])
	for (i=[-1,1], j=[-1,1])
	translate([-13,20/2*i,15/2*j])
	rotate([0,-90,0])
	screwhole(d1=3.4,d2=6.0,l1=2.7,l2=4.5-0.7-(j>0?0:1),a=sa);
	//cylinder(d=3.2,h=100,);

	// printability cut for top screw holes
	translate([-5.5-13+0.05,10,0])
	for (i=[-1,1])
	hull() for (z=[0,-10])
	translate([0,20/2*i,15/2+z])
	rotate([0,-90,0])
	cylinder(d1=4,d2=7,h=1.2);

	// barbell mount holes
	translate([0,10,0])
	for (i=[-1,1])
	translate([-13,24/2*i,0])
	rotate([0,-90,0]) {
		translate([0,0,5.5-1.6])
		screwhole(d1=3.1,d2=3.1,l1=1.6,l2=0,a=sa);
		translate([0,0,-2.5])
		linear_extrude(height=5.5-1.6+2.5,convexity=2)
		rotate(30)
		hexagon(5.5);
	}

	// belt attachment
	translate([0,0,+ex/2])
	for (i=[0,1])
	mirror([0,0,i])
	translate([10-20/PI+pld,0,-11])
	mirror([0,0,1])
	//mirror([1,0,0])
	rotate([90,0,0]) {
	translate([0,0,11.1])
	mirror([0,0,1])
	linear_extrude(height=11.1,convexity=3)
	belt_teardrop_profile(r=2.626); // 2.626 or 3.08
	translate([2.626,-6.35,0]) {
		cylinder(d=2.8,h=100);
		translate([0,0,14-1.7])
		cylinder(d=4.9,h=2);
		*linear_extrude(height=3.3,convexity=3)
		rotate(30)
		hexagon(5.1);
	}
	}
	rotate([90,0,0])
	for (y=[7,-10,24])
	for (x=(y==7)?[0.4]:[0.4,7.6])
	translate([x,y,0]) {
		cylinder(d=2.8,h=100);
		translate([0,0,14-1.7])
		cylinder(d=4.9,h=2);
		*linear_extrude(height=3.3,convexity=3)
		rotate(30) hexagon(5.1);
	}

	// front cutout above rail block
	translate([-3+0.01,0,+17])
	rotate([90,0,0])
	linear_extrude(height=100,center=true)
	translate([-40,0])
	//offset(r=3) offset(r=-3)
	square([40,40]);
}
	// flag
	translate([-13-6.5,10-2.2/2,17])
	hull() {
		translate([-11,0,0])
		cube([6.5,2.2,6.5]);
		translate([0,0,-6.5])
		cube([6.5,2.2,6.5]);
	}
}

module belt_fastner_profile(r=3.08) {
	translate([0,-13]) circle(d=7);
	translate([3.1+3.08,-13]) circle(d=7);
		cylinder(d=3,h=100);
		translate([0,0,13.3-1.4])
		cylinder(d=5.7,h=2);
	}
	translate([3.08,-7.3,0]) {

}

module belt_teardrop_pitch_profile(r=3.08) {
	hull() {
		polygon([[0,0],[0,-(1+sqrt(2))*r],[r,-(1+sqrt(2))*r]]);
		translate([r,-(1+sqrt(2))*r])
		circle(r=r);
	}
}

//module belt_teardrop_profile(bt=1.52,tt=0.67,r=3.08,l=100)
module belt_teardrop_profile(bt=bt,tt=th,r=3.08,l=100)
offset(r=-0.3) offset(r=0.3)
{
	difference() {
		offset(r=bt-tt)
		belt_teardrop_pitch_profile(r=r);
		offset(r=-tt)
		belt_teardrop_pitch_profile(r=r);
	}
	*translate([-(bt-tt),-tt])
	square([2*bt-tt,100]);

	if (l>0)
	hull() for (y=[-(bt-tt/2),l])
	translate([(2*bt-tt)/2-(bt-tt),y])
	circle(d=2*bt-tt);
}

module flag_profile_1() difference() {
	translate([-16,-10])
	square([32,16.5]);
	for (i=[0,1]) mirror([i,0])
	translate([7,-11])
	hull() {
		circle(r=6);
		translate([10,2])
		circle(r=6);
	}

	for (i=[0,1]) mirror([i,0])
	translate([11,9])
	hull() {
		circle(r=9);
		translate([10,0])
		circle(r=9);
	}
}

module flag_profile_2() {
	polygon([
		[0.2,1.25],[0.2,0.8],[4.3,-1.4],
		[11,-6],[11,-16],[11+6.5,-16],
		[11+6.5,16],[11,16],[11,6],[4.3,1.25]
	]);
}


// belt clip test
*difference() {
	cube([13,17,11]);
	translate([3,13])
	translate([0,0,2])
	linear_extrude(height=11,convexity=2)
	belt_teardrop_profile();
}

rotate($preview ? [0,0,0] : [90,0,180]) {
carriage();


if (false) {
//tabs
translate([3.15-3,-11.1,34/2+14-0.8])
cube([6,0.6,0.8]);
translate([3.15-3,-11.1,-34/2])
cube([6,0.6,0.8]);
for (i=[-1,1])
translate([3.15+0.6,-11.1+0.3,i*6+7])
rotate([0,-30*i,0])
cube([10,0.6,0.8],center=true);
}

// 2040
*%translate([40/2,20/2,0])
cube([40,20,200],center=true);

// block
*%translate([-13,-3.5])
cube([10,27,20]);

// belt path
if ($preview) {
	%translate([0,-belt_distance,-50])
	belt_mockup(w=belt_width) belt_pitch_path(l=150);
}


}



use <belt_path.scad>;

// 13.7-11.3 = 2.4

belt_distance=5;
belt_width=6;
idler_x=10;
idler_y=25;
belt_pld=0.254;


%translate([-13-6.5-11,10,17])
translate([0,-1.5,0])
cube([4,3,6.5]);


*translate([-13-5.5-7/2,10,0])
rotate([90,180,-90])
barbell();

module barbell()
translate([32003.430664,-745.6175535,-9.48/2])
import("barbell.stl");


$fs=.2;
$fa=5;
