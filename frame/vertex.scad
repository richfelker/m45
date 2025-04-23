
// frame height
h=550;

// length of vertical extrusions
vl=550;

// inner diameter of extrusions
d=332;

// bed/working diameter
bd=254;

// side length of base extrusions
sl=250;

// hole diameter for screws
hd1=5.3; // 0.1

// hole diameter for washers/heads
hd2=10.6; // 0.1


vshort=h-vl;

short=sqrt(3)*(d/2+20)-sl;
echo(short);

//%translate([-40,d/2+40]) square([80,80]);


*translate([0,0,40])
linear_extrude(height=8)
circle(d=bd);

*translate([0,0,40])
linear_extrude(height=1)
intersection_for (a=[0:120:240])
rotate(a)
translate([0,d/2])
circle(r=d);


module corners(r=1,a=45) difference() {
	union() { children(); }
	offset(r=1.001*r)
	offset(delta=-r)
	children();
}

module grow_corners(r=1) {
	if (r==0) children();
	else
	offset(r=-r)
	offset(r=r)
	union() {
		children();
		offset(r=r) corners(r=r/100) children();
	}
}

module undercut(l,r,a=30) difference() {
	linear_extrude(height=l,center=true)
	rotate(45)
	scale([r/(1-tan(a)),r/(1-tan(a)),1])
	translate([-tan(a),0])
	scale([1,tan(a),1])
	rotate(-45)
	square(sqrt(2),center=true);

	*for (i=[0,1]) mirror([0,0,i])
	translate([0,0,l/2])
	rotate(-45)
	translate([0,r,0])
	rotate([45,0,0])
	translate([0,0,5*r])
	cube(10*r,center=true);

*	translate([0,0,l/2])
	translate([r*sqrt(2)/2,r*sqrt(2)/2,0])
	sphere(d=0.2);

	for (j=[0,1]) rotate(-90*j)
	for (i=[0,1]) mirror([0,0,i])
	translate([0,0,l/2])
	translate([0,r*sqrt(2)/2,0])
	rotate([45,0,0])
	translate([0,0,5*r])
	cube(10*r,center=true);

	for (i=[0,1]) mirror([0,0,i])
	translate([0,0,l/2])
	rotate(-45)
	rotate([-54.73,0,0])
	translate([0,0,5*r])
	cube(10*r,center=true);
}

module extrusion_slot(d,sc=0,cc=0) render() union() {
	x=d[0]/2;
	y=d[1]/2;
	z=d[2]/2;
	ea=30;
	if (!$preview)
	if (cc>0) for (i=[0,1],j=[0,1]) {
		mirror([i,0,0]) mirror([0,j,0])
		translate([x,y,0])
		undercut(l=2*z+2*cc,r=cc);

		mirror([i,0,0]) mirror([0,0,j])
		translate([x,0,z])
		rotate([90,0,0])
		undercut(l=2*y+2*cc,r=cc);

		mirror([0,i,0]) mirror([0,0,j])
		translate([0,y,z])
		rotate([0,-90,0])
		undercut(l=2*x+2*cc,r=cc);
	}

	*translate([x,y])
	rotate(45)
	scale([cc/(1-tan(ea)),cc/(1-tan(ea)),1])
	translate([-tan(ea),0])
	scale([1,tan(ea),1])
	rotate(-45)
	color("red")
	cube([sqrt(2),sqrt(2),2*z+2*cc],center=true);

	*for (i=[-1,1], j=[-1,1]) {
		hull() for (k=[-1,1])
		translate([i*x,j*y,k*z])
		sphere(r=cc);
		hull() for (k=[-1,1])
		translate([i*x,k*y,j*z])
		sphere(r=cc);
		hull() for (k=[-1,1])
		translate([k*x,i*y,j*z])
		sphere(r=cc);
	}
	cube([2*(x+sc),2*(y+sc),2*(z+sc)],center=true);
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

module tdcyl_old(d,h,center=false,a=0) {
	linear_extrude(height=h,center=center)
	hull() {
		circle(d=d);
		rotate(a)
		translate([0,d/2/sqrt(2)])
		rotate(45)
		square(d/2,center=true);
	}
}

*tdcyl(10,10);

*extrusion_slot([20,40,100],sc=0.15*0,cc=.6);


module delta_frame(h,d,short,sc=0,cc=0,holes=false) {
	translate([0,0,vshort/2])
	delta_columns(vl,d,sc,cc,holes);
	delta_ends(h,d,short,sc,cc,holes);
}

module delta_columns(h,d,sc,cc,holes=false) {
	for (i=[0:2]) rotate(120*i) {

		translate([0,d/2+20,h/2])
		extrusion_slot([20,40,h],sc=sc,cc=cc);
	}

	if (holes)
	for (top=[0,1])
	translate([0,0,h/2])
	mirror([0,0,top])
	translate([0,0,-h/2])	

	{
		for (y=[10,30])
		//if (!top || y==30)
		for (z=[10,30])
		for (j=[0,1])
		translate([0,d/2+y,z])
		mirror([j,0,0])
		rotate([0,90,0]) {
			tdcyl(d=hd1,h=200,a=135);
			translate([0,0,10+4])
			tdcyl(d=hd2,h=200,a=135);
		}
		for (z=[10,30])
		for (j=[0,1])
		if (!top || j==0)
		translate([0,d/2+20,z])
		mirror([0,j,0])
		rotate([-90,0,0]) {
			tdcyl(d=hd1,h=200,a=180);
			translate([0,0,20+4])
			tdcyl(d=hd2,h=200,a=180);
		}
		// extrusion end tap holes
		for (y=[10,30])
		translate([0,y+d/2,0])
		tdcyl(d=top ? hd1 : hd2,h=200,center=true,a=180);

		// pseudo chamfer at opening
		if (cc)
		translate([0,d/2+20,45/2])
		extrusion_slot([20,40,45],sc=sc,cc=cc);
	}
}

module delta_ends(h,d,short,sc,cc,holes) {
	for (top=[0,1])
	translate([0,0,h/2])
	mirror([0,0,top])
	translate([0,0,-h/2])	
//	for (z=[0,h-40]) translate([0,0,z])
	for (i=[0:2]) rotate(120*i) {
		translate([0,d/2+20])
		rotate(-60)
		translate([0,10*sqrt(3)])
		{
			translate([short/2,0])
			translate(0.5*[sqrt(3)*(d/2+20)-short,20,40])
			extrusion_slot([sqrt(3)*(d/2+20)-short,20,40],sc=sc,cc=cc);

			if (holes && i!=2)
			for (i=[0,1])
			translate([sqrt(3)*(d/2+20)/2,0,0])
			mirror([i,0,0])
			translate([-sqrt(3)*(d/2+20)/2,0,0])
			{
				for (z=[10,30])
				translate([52,10,z])
				rotate([-90,0,0]) {
					tdcyl(d=hd1,h=200,a=225);
					translate([0,0,10+2])
					tdcyl(d=hd2,h=200,a=225);
				}
				for (x=[45,60])
				if (top) translate([0,0,20])
				translate([x,10,10])
				rotate([90,0,0]) {
					tdcyl(d=hd1,h=200,a=-45);
					translate([0,0,10+4])
					tdcyl(d=hd2,h=200,a=-45);
				}
				if (!top)
				translate(top ? [60,10,10] : [45,10,30])
				rotate([90,0,0]) {
					tdcyl(d=hd1,h=200,a=-45);
					translate([0,0,10+4])
					tdcyl(d=hd2,h=200,a=-45);
				}
			}
		}
	}
}

// fit test piece
*difference() {
	rotate([45,0,0]) cube([60,40,80],center=true);
	rotate([45,0,0]) translate([0,0,20]) extrusion_slot([40,20,80],sc=0.025,cc=0.6);
	translate([0,0,-100/2-25]) cube(100,center=true);
}

module vertex() difference() {
	vertex_block();
	translate([0,-d/2-20,0]) delta_frame(h=h,d=d,short=short,sc=0.025,cc=0.6,holes=true);

	rotate([-45,0,0])
	translate([0,-80-45-5,0])
	cube(160,center=true);

	rotate([-45,0,0])
	translate([0,95+1,0])
	cube(160,center=true);

	*rotate([45,0,0])
	translate([0,95+33,0])
	cube(160,center=true);

	*rotate([45,0,0])
	translate([0,-95-10,0])
	cube(160,center=true);
}

module top_vertex() difference() {
	top_vertex_block();
	translate([0,-d/2-20,40-h]) delta_frame(h=h,d=d,short=short,sc=0.025,cc=0.6,holes=true);

	*translate([0,0,40]) rotate([0,180,0])
	rotate([-45,0,0])
	translate([0,-80-45-5,0])
	cube(160,center=true);

	translate([0,0,40]) rotate([0,180,0])
	rotate([-45,0,0])
	translate([0,95+1,0])
	cube(160,center=true);

	translate([0,0,40]) rotate([0,180,0])
	for (x=[-32:8:32])
	translate([x,0,0])
	rotate([-45,0,0])
	translate([0,6/2+15+1,0])
	rotate(45)
	cube([6,6,160],center=true);
}


module top_vertex_block() {
	rotate([0,180,0])
	difference() {
		rotate([0,180,0])
		vertex_block();

		translate([0,0,100/2-40])
		extrusion_slot([20,40,100],sc=0.025);

		// rail
		translate([-6.2,-8.2-20,-40])
		cube([12.4,8.4,40]);

		// belt path cutouts
		linear_extrude(height=100,center=true,convexity=2)
		for (i=[0,1]) mirror([i,0,0])
		translate([10,-10-4+1])
		let (w=14,l=20)
		polygon([[0,-l/2],[w/2,-l/2-w/3],[w,-l/2],[w,l/2],[w/2,l/2],[0,l/2]]);
		//polygon([[0,-l/2],[w/2,-l/2-w/3],[w,-l/2],[w,l/2],[w/2,l/2+w/3],[0,l/2]]);

		// main cavity
		translate([0,0,-30])
		linear_extrude(height=50,convexity=2)
		cavity_profile();

		// endstop cavity
		translate([0,0,-40])
		linear_extrude(height=50,convexity=2)
		cavity_profile(off=32,end=50);

		// endstop mount
		translate([0,-50,-34])
		rotate([90,0,0])
		linear_extrude(height=10,center=true,convexity=3) {
			for (i=[-1,1]) translate([19/2*i,0])
			tdcircle(d=3.2);
			translate([0,4/2])
			square([12.2,6.2+4],center=true);
		}
	}
	module cavity_profile(off=0,end=60) {
		*translate([0,-40])
		square(40,center=true);
		intersection() {
			translate([0,-(end-off)/2-off])
			square([150,end-off],center=true);
			translate([0,0,-15])
			hull() for (i=[0,1])
			mirror([i,0,0])
			rotate(-60)
			translate([160/2+15,10*sqrt(3)+30/2-40+3])
			square([160,30],center=true);
		}
	}
}

module vertex_block() {
	translate([0,0,-5])
	linear_extrude(height=50,convexity=3)
	difference() {
		translate([0,-30])
		square([140,120],center=true);

		for (i=[-1,1])
		rotate(60*i)
		translate([0,10*sqrt(3)+80/2+25+3])
		square([160,80],center=true);

		for (i=[-1,1])
		rotate(30*i)
		translate([0,-110])
		square([160,80],center=true);

		translate([0,-94])
		square([160,80],center=true);
	}
}



*top_vertex();
vertex();



$fs = .2;
$fa = $preview ? 10 : 5;

