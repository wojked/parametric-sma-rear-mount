/* [MOUNT] */
WIDTH = 29.5;
MOUNT_DIAMETER = 5.7;
MOUNT_THICKNESS = 4;
MOUNT_HEIGHT= 6.75;

/* [BRIDGE] */
BRIDGE_WIDTH = WIDTH;
MIN_BRIDGE_WIDTH = WIDTH/2;
BRIDGE_HEIGHT = 14;  // MOUNT_HEIGHT
BRIDGE_ANGLE = 30;
BRIDGE_X_OFFSET = 12;
BRIDGE_Z_OFFSET = 2;
BRIDGE_THICKNESS = 1;

/* [SMA] */
SMA_HOLE_OFFSET = 0;
SMA_HOLE_DIAMETER = 5.95;
SMA_OUTLINER_DIAMETER = 9.09;
SMA_CUTOUT_WIDTH = WIDTH - 4*MOUNT_THICKNESS;
SMA_CUTOUT_HEIGHT = 10;

/* [META] */
HULL_TYPE = 2;          // [0,1,2]
CORNERS_DIAMETER = 4;   // [16:0.5:40]
FN = 64;               // [0:32:256]  

/* [HIDDEN] */
$fn = FN;

sma_holder();

module sma_holder(){
    difference(){
        if(HULL_TYPE==0){
            union(){
                side_mounts();
                vertical_bridge();                
                bridge_with_mount();   
            }            
        }
        if(HULL_TYPE==1){            
            hull(){
                side_mounts();
                vertical_bridge();
                bridge_with_mount();            
            }
        }
        if(HULL_TYPE==2){
            union(){
                side_mounts();
                hull(){
                    vertical_bridge();                
                    bridge_with_mount();                            
                }
            }            
        }        

        
        side_poles();
        
        translate([0,BRIDGE_X_OFFSET, BRIDGE_THICKNESS/2 + BRIDGE_Z_OFFSET])
        rotate([BRIDGE_ANGLE,0,0])       
        union(){
            translate([0,SMA_HOLE_OFFSET,0])
            sma_hole();
            
            translate([0,SMA_HOLE_OFFSET,0])
            sma_outliner();                 
            
            translate([0,0,0])            
            sma_plate();        
        }
        
        // LOWER bound
        translate([0,0,-WIDTH/2])
        cube([WIDTH*2, WIDTH*2, WIDTH], true);
        
        // UPPER bound    
        translate([0,0,MOUNT_HEIGHT+WIDTH/2-0.5])
        cube([WIDTH*2, WIDTH*2, WIDTH], true);           
        
    }

 
//
//    translate([0,BRIDGE_X_OFFSET, BRIDGE_THICKNESS/2 + BRIDGE_Z_OFFSET])    
//    rotate([BRIDGE_ANGLE,0,0])       
//    sma_plate();    
}

module side_mounts(){
    x_offset = WIDTH/2 - MOUNT_DIAMETER/2;
    
    translate([-x_offset,0,0])    
    mount();

    translate([x_offset,0,0])
    mount();    
}

module mount(){
    outside_diameter = MOUNT_DIAMETER + MOUNT_THICKNESS;    
    
    translate([0,0, MOUNT_HEIGHT/2])
    cylinder(MOUNT_HEIGHT, outside_diameter/2, outside_diameter/2, true);
}

module side_poles(){
    x_offset = WIDTH/2 - MOUNT_DIAMETER/2;
    
    translate([-x_offset,0,0])    
    pole();

    translate([x_offset,0,0])
    pole();       
}

module pole(){
    outside_diameter = MOUNT_DIAMETER + MOUNT_THICKNESS;    
    
    translate([0,0, MOUNT_HEIGHT/2])
    cylinder(MOUNT_HEIGHT*2, MOUNT_DIAMETER/2, MOUNT_DIAMETER/2, true);        
}

module vertical_bridge(){
    translate([0,0, MOUNT_HEIGHT/2])    
    cube([BRIDGE_WIDTH+MOUNT_THICKNESS, BRIDGE_THICKNESS, MOUNT_HEIGHT], true);      
}

module bridge_with_mount(){
//    if(BRIDGE_X_OFFSET>0){
//        translate([0,0, BRIDGE_THICKNESS/2 + BRIDGE_Z_OFFSET])            
//        bridge(BRIDGE_WIDTH, BRIDGE_WIDTH, BRIDGE_X_OFFSET, BRIDGE_THICKNESS);    
//    }
    
    translate([0,BRIDGE_X_OFFSET, BRIDGE_THICKNESS/2 + BRIDGE_Z_OFFSET])
    rotate([BRIDGE_ANGLE,0,0])    
    bridge(BRIDGE_WIDTH, MIN_BRIDGE_WIDTH, BRIDGE_HEIGHT, BRIDGE_THICKNESS);  
}

module bridge(wider_width, min_width, height, thickness){
    rounded_corners_trapeze(wider_width, min_width, height, thickness, CORNERS_DIAMETER);
}

module sma_hole(){
    cylinder(BRIDGE_THICKNESS*10, SMA_HOLE_DIAMETER/2, SMA_HOLE_DIAMETER/2, true);            
}

module sma_outliner(){
    outliner_thickness = BRIDGE_THICKNESS*10;
    translate([0,0,outliner_thickness/2])
    cylinder(outliner_thickness, SMA_OUTLINER_DIAMETER/2, SMA_OUTLINER_DIAMETER/2, true);            
}

module sma_plate(){
    outliner_thickness = BRIDGE_THICKNESS*20;
    translate([0,0,outliner_thickness/2+BRIDGE_THICKNESS/2])
    cube([SMA_CUTOUT_WIDTH, SMA_CUTOUT_HEIGHT, outliner_thickness], true);            
}


module rounded_corners_trapeze(bottom_width, upper_width, height, depth, corner_curve){
    x_translate = bottom_width-corner_curve;
    y_translate = height-corner_curve;     
    
    x_translate2 = upper_width-corner_curve;
    
    
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
