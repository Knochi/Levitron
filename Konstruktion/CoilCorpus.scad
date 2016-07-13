use <MCAD/regular_shapes.scad>

$fs=0.2; //minimum is 0.01
$fa=0.2;
D= 31; // Inner Diameter of Ring Magnet
RMda = 85;
RMthick = 11;
di= 5; // Diameter of core
skin= 0.8; //minimum material thickness
l= 15; //overall height of coil
do=D*(sqrt(2)-1); //calculate maximum outer coil diameter
h=(do-di-2*skin)/2; //calculate remaining height for windings
rhex=(25.4/8)/cos(30); //radius of a 1/4" bit, for the flat side

echo(do,h);

//Melexis Rotary IC SO-8
*translate([0,0,l]) cube([6.4,4.9,1.1],true);

//Ring Magnet
*translate ([0,0,RMthick/2]) difference(){
    cylinder(d=RMda,h=RMthick,center=true);
    cylinder(d=D,h=RMthick+0.1,center=true);
}

// Four Coils
*translate([0,0,l/2]){
    translate([do/2,do/2,0]) Coil();
    translate([-do/2,do/2,0]) Coil();
    translate([do/2,-do/2,0]) Coil();
    translate([-do/2,-do/2,0]) Coil();
}

// One Coil
*Coil();
module Coil()
{
difference(){
    cylinder(h=l, d=do, center=true);
    cylinder(h=l+1, d=di, center=true);
    cube([di+2*skin+0.1,skin,l+0.1],true);
    difference(){
        cylinder(h=(l-2*skin), d=do+1, center=true);
        cylinder(h=l, d=di+2*skin, center=true);
    }
}
}
// Tool
union(){
    translate([0,0,l/2+4])hexagon_prism(15,rhex);
  
    cylinder(h=l+2,d=di-0.1,center=true);
    translate([0,0,2*skin])cube([di+2*skin-0.1,skin-0.1,l],true);
    
    translate([0,0,l/2]) cylinder(h=5,r=rhex);
    
    
}