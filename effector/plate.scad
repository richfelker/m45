
eho=22.5; // 0.1
pt=2; // 0.1
offcenter=0;

module effector_plate(eho=eho,offcenter=offcenter,pt=pt)
linear_extrude(height=pt,convexity=2)
effector_plate_profile(eho=eho,offcenter=offcenter);

module cooling_hole_profile(w=9,l=11,eho=eho)
translate([0,23.5+cos(60)*(eho-22.5)])
offset(r=1) offset(r=-1)
difference() {
	translate([0,-w/2])
	square([40,w],center=true);
	for (i=[0,1]) mirror([i,0])
	translate([l/2,0])
	rotate(30)
	translate([30/2,0])
	square([30,50],center=true);
}


module hotend_mount_profile(eho=eho,offcenter=offcenter)
translate([0,offcenter]) {
	difference() {
		offset(r=1) offset(r=-1)
		hull() {
			translate([0,2.5/2])
			square([18.8,13+2.5],center=true);
			translate([0,-13/2])
			square([18.8,0]+6*[-1,sqrt(3)],center=true);
		}
		for (i=[-1,1]) translate([21/2*i,0]) circle(d=5);
	}
	for (i=[-1,1]) translate([21/2*i,0]) circle(d=2.6);
}

module effector_plate_profile(eho=eho,offcenter=offcenter,cuts=true,holes=true)
difference() {

	//hull() for (a=[0:120:240]) rotate(a) translate([0,24-2/2]) square([6,2],center=true);
//	hull() for (a=[0:120:240]) rotate(a) translate([0,-eho-2]) square([bd+2,2],center=true);
	offset(r=2) offset(r=-4) offset(r=2)
	union() {
	for (a=[0:120:240]) rotate(a)
	translate([0,-eho/2-5/2]) square([35,eho+5],center=true);
	hull()
	for (a=[0:120:240]) rotate(a)
	translate([0,-eho/2-5/2]) square([28,eho+5],center=true);
	}

	if (holes)
	for (a=[0:120:240]) rotate(a)
	for (i=[-1,1])
	translate([i*12,-eho,0]) circle(d=3.1);

	if (cuts)
	for (a=[0:120:240]) rotate(a)
	translate([0,-eho,0])
	offset(r=1) offset(r=-1) square([18,4],center=true);

	*cooling_hole_profile(w=14);
	for (a=[120:120:240]) rotate(a)
	cooling_hole_profile(eho=eho);

	if (cuts)
	translate([-18/2,13/2+2.5+10])
	offset(r=1) offset(r=-1)
	square([18,4]);

	hotend_mount_profile(eho=eho,offcenter=offcenter);
}

*effector_plate(eho=eho,offcenter=offcenter);
effector_plate_profile(eho=eho,offcenter=offcenter);

$fs=.2;
$fa=6;
