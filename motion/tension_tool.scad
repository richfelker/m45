
module pusher_base(h=15)
difference() {

linear_extrude(height=h,convexity=3) {

polygon([
	[5,0],[-7,0],[-7,2.1],[-5,2.1],
	[-5,4],[-7,6],[-10,6],
	[-10,-3],[-3,-4],[5,-10]
]);
translate([5,-5])
circle(d=10);
}
	translate([5,-5,10]) {
		cylinder(d=5.4,h=100);
		cylinder(d=1.5,h=100,center=true);
	}

}

module pusher_a() difference() {
	pusher_base(h=20);
	for (z=[0,8,16])
	translate([0,-10,z-0.1])
	cube([20,20,4+0.2]);
}

module pusher_b() mirror([1,1,0]) difference() {
	pusher_base(h=20);
	for (z=[4,12])
	translate([0,-10,z-0.1])
	cube([20,20,4+0.2]);
}

*%pusher_a();
*color("red")
pusher_b();

*union() {
//rotate(180)
translate([20,10,0])
rotate([0,-90,0])
pusher_a();

rotate([-90,0,-90])
pusher_b();
}

module pusher_c() difference() {
linear_extrude(height=20,center=true,convexity=3) {
difference() {
	hull() {
		translate([-3,-3]) square(20-3.5);
		translate([-5,-5]) circle(d=12);
	}
	square(24);
}
//translate([0,10-3]) square([0.6,6]);
//translate([10-3,0]) square([6,0.6]);
}
*rotate(45) translate([9.8,0,0]) cube([9.8,9.8,100],center=true);
rotate(45) translate([100/2+8.5,0,0]) cube(100,center=true);
for (i=[0,1]) mirror([i,-i,0])
translate([10,-2.4,0]) rotate([90,0,0]) {
	//cylinder(d=10.5,h=100);
	//cylinder(d=4.2,h=100,center=true);
	cylinder(d=5.6,h=100);
	cylinder(d=3.3,h=100,center=true);
}
translate([-5,-5,-10]) {
translate([0,0,4+7]) cylinder(d=10.5,h=100);
cylinder(d=5.2,h=100,center=true);
linear_extrude(height=8,center=true,convexity=3)
rotate(-15)
ngon(6,7.95);
}
}

rotate([90,0,0])
rotate(180+45)
pusher_c();


module ngon(n,w) polygon([
	for (i=[1:n]) w/sqrt(3) * [cos(360*i/n), sin(360*i/n)]
	]);

$fs=.2;
$fa=5;
