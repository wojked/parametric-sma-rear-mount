/* [MOUNT] */
WIDTH = 25.0;
MOUNT_DIAMETER = 5.5;  //4.95
MOUNT_THICKNESS = 2.5;
MOUNT_HEIGHT= 7.00;     // 6.75

/* [BRIDGE] */
BRIDGE_WIDTH = WIDTH - 10;   //8 is not catching up to much
BRIDGE_THICKNESS = 1.5;

/* [VERTICAL_BRIDGE] */
VERTICAL_BRIDGE_WIDTH = WIDTH - 6;  //-6
VERTICAL_BRIDGE_THICKNESS = 1;

VERTICAL_BRIDGE_CUTOUT_WIDTH = VERTICAL_BRIDGE_WIDTH*2/3;
VERTICAL_BRIDGE_CUTOUT_HEIGHT = MOUNT_HEIGHT/2;

/* [SHELF] */
VTX_WIDTH = 17.5;
SHELF_WIDTH = VTX_WIDTH + 4.5 ; 
SHELF_LENGTH = 18;
SHELF_Y_OFFSET = 10;    //10 -> 6
SHELF_THICKNESS = 1.2;

/* [META] */
ZIPTIE_WIDTH = 3.5;

TEST_WIDTH = false;     // [false, true]
CORNERS_DIAMETER = 4;
BOUNDED = true;         // [true, false]
FN = 64;                // [0:32:256]  

/* [HIDDEN] */
$fn = FN;
DEBUG = false;

rotate([180,0,0])
shelf_on_poles();

module shelf_on_poles(){
    if(TEST_WIDTH){
        union(){
            side_mounts(2);       
            vertical_bridge(2);                     
        }
    }    
    else{
        difference(){
            intersection(){
                union(){
                    translate([0,0,MOUNT_HEIGHT])
                    shelf(SHELF_THICKNESS);    
                    
                    side_mounts(MOUNT_HEIGHT);
                    vertical_bridge(MOUNT_HEIGHT);  
                }
            
                if(BOUNDED){
                    bounding_box();
                }            
            }
            side_poles();
              
        }
        
        // Debug objects
//        if(DEBUG){                
//            if(BOUNDED){                
//                bounding_box();
//            }               
//        }        
//        
//        if(DEBUG){
//            side_poles();                         
//        }          
    }
}

module side_mounts(height){
    x_offset = WIDTH/2;
    
    translate([-x_offset,0,0])    
    mount(height);

    translate([x_offset,0,0])
    mount(height);    
}

module mount(height){
    outside_diameter = MOUNT_DIAMETER + MOUNT_THICKNESS;    
    
    difference(){
        //positive
        union(){
            translate([0,0, height/2])
            cylinder(height, outside_diameter/2, outside_diameter/2, true);
        }
        
        //negative
        union(){
            pole();
        }
    }
    
    if(DEBUG){
        color("red", 0.5)
        pole();
    }
}

module side_poles(){
    x_offset = WIDTH/2;
    
    translate([-x_offset,0,0])    
    pole();

    translate([x_offset,0,0])
    pole();       
}

module pole(){
    outside_diameter = MOUNT_DIAMETER + MOUNT_THICKNESS;    
    
    color("red", 0.5)
    translate([0,0, MOUNT_HEIGHT/2])
    cylinder(MOUNT_HEIGHT*2, MOUNT_DIAMETER/2, MOUNT_DIAMETER/2, true);        
}

module vertical_bridge(height){
    difference(){
        translate([0,0, height/2])    
        cube([VERTICAL_BRIDGE_WIDTH, VERTICAL_BRIDGE_THICKNESS, height], true);      
        vertical_bridge_cutout();
    }
    
    if(DEBUG){
        vertical_bridge_cutout();
    }
}

module vertical_bridge_cutout(){
    height = VERTICAL_BRIDGE_CUTOUT_HEIGHT;
    width = VERTICAL_BRIDGE_CUTOUT_WIDTH;
    
    color("red", 0.5)
    translate([0,0, MOUNT_HEIGHT])    
    translate([0,0, -height/2])    
    cube([width, VERTICAL_BRIDGE_THICKNESS*2, height], true);    
}

module shelf(thickness){
    holder_thickness = thickness + 0.5;
    width = SHELF_WIDTH;
    
    translate([0,-SHELF_LENGTH/2-SHELF_Y_OFFSET,-thickness/2])
    difference(){
        cube([width, SHELF_LENGTH, thickness], true);
        translate([0,-4,0])        
        shelf_zipties(width, thickness);    
    }
    
    straight_shelf_holders(width, holder_thickness);
    
    angled_shelf_holders(width, holder_thickness);

}

module shelf_zipties(width, thickness){
    ziptie_cutout = (SHELF_WIDTH - VTX_WIDTH)/2;    
    x_offset = width/2 - ziptie_cutout/2;
    y_offset = 0;    
    
    union(){
        translate([x_offset, 0, 0])
        shelf_ziptie(ziptie_cutout, thickness);
        
        translate([-x_offset, 0, 0])
        shelf_ziptie(ziptie_cutout, thickness);    
    }         
}

module shelf_ziptie(ziptie_cutout, thickness){
    cube([ziptie_cutout, ZIPTIE_WIDTH, thickness*2], true);  
}

module straight_shelf_holders(width, thickness){
    angle = 90;
    length1 = 10;
    x_offset = width/2 - thickness/2;
    y_offset = 2;
    
    translate([0,-y_offset,-thickness/2])
    rotate([angle,0,0])
    union(){
        translate([x_offset, 0, 0])
        shelf_holder(thickness, length1);
        
        translate([-x_offset, 0, 0])
        shelf_holder(thickness, length1);    
    }    
}

module angled_shelf_holders(width, thickness){
    angle = 60;
    length1 = 20;
    z_offset = 0;
    x_offset = width/2 - thickness/2;
    y_offset = 4;     //2.5
    
    translate([0,y_offset,-length1/2+z_offset])
    rotate([angle,0,0])
    union(){
        translate([0, 0, 0])
        shelf_holder(thickness, length1);        
        
        translate([x_offset, 0, 0])
        shelf_holder(thickness, length1);
        
        translate([-x_offset, 0, 0])
        shelf_holder(thickness, length1);    
    }
}

module shelf_holder(thickness, length){
    translate([0,0,length/2])
    cube([thickness, thickness, length], true);       
    
}

module bounding_box(){
    color("green", 0.5)
    translate([0,0,MOUNT_HEIGHT/2])                
    cube([WIDTH*2, WIDTH*3, MOUNT_HEIGHT], true);               
}

module rounded_corners_trapeze(bottom_width, upper_width, height, depth, corner_curve){
    x_translate = bottom_width-corner_curve;
    x_translate2 = upper_width-corner_curve;    
    y_translate = height-corner_curve;
    
    
    hull(){
            translate([-x_translate/2, -y_translate/2, 0])
            cylinder(depth,corner_curve/2, corner_curve/2, true);    
            
            translate([-x_translate2/2, y_translate/2, 0])
            cylinder(depth,corner_curve/2, corner_curve/2, true);

            translate([x_translate2/2, y_translate/2, 0])
            cylinder(depth,corner_curve/2, corner_curve/2, true);        
            
            translate([x_translate/2, -y_translate/2, 0])
            cylinder(depth,corner_curve/2, corner_curve/2, true);        
    }        
}
