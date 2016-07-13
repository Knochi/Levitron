use <MCAD/regular_shapes.scad>


$fs=0.8; //minimum is 0.01
$fa=0.8;

// --- Ring Magnet Dimensions ---
D= 31; // Inner Diameter of Ring Magnet
RMda = 85; // Outer Diameter of Ring Magnet
RMthick = 11; // Thickness of Ring Magnet

// --- Floater Dimensions ---
FloatD = 25; //Diameter of Floater
FloatT = 4; //Thickness of Floater
FloatZ = RMthick + 14; //Levitation Hight

// --- Coil Dimensions ---
di= 5; // Diameter of core
skin= 0.8; //minimum material thickness
l= 15; //overall height of coil
domax=D*(sqrt(2)-1)-0.1; //calculate maximum outer coil diameter
do=domax;
h=(do-di-2*skin)/2; //calculate remaining height for windings

// --- Base Plate Dimensions ---
BPt = 3; //thickness

// --- Tool Dimensions ---
rhex=(25.4/8)/cos(30); //radius of a 1/4" bit, for the flat side

echo(do,h);



translate([0,0,-BPt/2]) BasePlate();

//projection(true){
    *rotate([-90,45,0]) {
        // Four Coils
        translate([0,0,l/2]){
            translate([do/2,do/2,0]) Coil();
            translate([-do/2,do/2,0]) Coil();
            translate([do/2,-do/2,0]) Coil();
            translate([-do/2,-do/2,0]) Coil();
        }
        // Ring Magnet
        RingMagnet();
        
        // Floater
        *color ("DimGray") translate([0,0,FloatZ]) cylinder(h=FloatT, d=FloatD, center=true);
        
        //Melexis Rotary IC SO-8
        *color ("coral") rotate ([0,0,45]) translate([0,0,l+skin]) cube([6.4,4.9,1.1],true);
        
        // One Coil
        *Coil();
        
        // BasePlate
        color ("LightGray",0.5)
        translate([0,0,-BPt/2]) BasePlate();
    }
//}



module Coil()
{
    // Windings
    color ("Crimson")
    *difference(){ 
        cylinder(h=l-0.1-2*skin, d=do-0.1, center=true);
        cylinder(h=l+1, d=di+0.2+2*skin, center=true);
    }
    
    // Corpus
    color ("CornFlowerBlue")
    difference(){
        cylinder(h=l, d=do, center=true);
        cylinder(h=l+1, d=di+0.1, center=true);
        cube([di+2*skin+0.1,skin,l+0.1],true);
        difference(){
            cylinder(h=(l-2*skin), d=do+2, center=true);
            cylinder(h=l+1, d=di+2*skin, center=true);
        }
    }
    // Core
    *color ("Silver") cylinder(h=l, d=di, center=true);
        
}
module Tool()
union(){
    translate([0,0,l/2+4])hexagon_prism(15,rhex);
  
    cylinder(h=l+2,d=di-0.1,center=true);
    translate([0,0,2*skin])cube([di+2*skin-0.1,skin-0.1,l],true);
    
    translate([0,0,l/2]) cylinder(h=5,r=rhex);
}

module RingMagnet()
{
    color ("DimGray") translate ([0,0,RMthick/2]) difference(){
        cylinder(d=RMda,h=RMthick,center=true);
        cylinder(d=D,h=RMthick+0.1,center=true);
    }
}

module BasePlate()
{
    width = RMda + 4;
    union(){
        cylinder(h=BPt, d=width,center=true);
        translate ([-width/2,0,-BPt/2]) cube ([width,50,BPt]);
    }
}
