/* [MOUNT] */
WIDTH = 24.50;
MOUNT_DIAMETER = 4.95;
MOUNT_THICKNESS = 2.5;
MOUNT_HEIGHT= 6.75;     // 6.75

/* [SHELF] */
BRIDGE_WIDTH = WIDTH;
MIN_BRIDGE_WIDTH = WIDTH/2;
BRIDGE_HEIGHT = 14;     // MOUNT_HEIGHT
BRIDGE_ANGLE = 30;      // [0:5:60]
BRIDGE_X_OFFSET = 12;    // [0:1:20]
BRIDGE_Z_OFFSET = 2.5;    // [0:1:15]
BRIDGE_THICKNESS = 1.5;

/* [VERTICAL_BRIDGE] */
VERTICAL_BRIDGE_WIDTH = BRIDGE_WIDTH + 2;
VERTICAL_BRIDGE_OFFSET = 1;
VERTICAL_BRIDGE_THICKNESS = 1;

/* [SMA] */
SMA_HOLE_OFFSET = 1;
SMA_HOLE_DIAMETER = 6.5;
SMA_OUTLINER_DIAMETER = 0;
SMA_CUTOUT_WIDTH = WIDTH - 4*MOUNT_THICKNESS - 3.8;
SMA_CUTOUT_HEIGHT = 13;

/* [SHELF] */
WITH_SHELF= true;    //[true, false]
SHELF_LENGTH = 15;
SHELF_Y_OFFSET = 10;
SHELF_THICKNESS = 2;

/* [META] */
TEST_WIDTH = false;     // [false, true]
HULL_TYPE = 2;          // [0,1,2]
CORNERS_DIAMETER = 4;
BOUNDED = true;         // [true, false]
FN = 64;                // [0:32:256]  

/* [HIDDEN] */
$fn = FN;
DEBUG = false;

sma_holder();

module sma_holder(){
    difference(){
        if(TEST_WIDTH){
            union(){
                side_mounts(2);       
                vertical_bridge(2);                     
            }
        }
        else{
            if(HULL_TYPE==0){
                union(){
                    if(WITH_SHELF){
                        translate([0,0,MOUNT_HEIGHT])                        
                        shelf(SHELF_THICKNESS);
                    }                    
                    side_mounts(MOUNT_HEIGHT);
                    translate([0, VERTICAL_BRIDGE_OFFSET, 0])     
                    vertical_bridge(MOUNT_HEIGHT);                
                    bridge_with_mount();   
                }            
            }
            if(HULL_TYPE==1){            
                hull(){
                    if(WITH_SHELF){
                        translate([0,0,MOUNT_HEIGHT])                        
                        shelf(SHELF_THICKNESS);
                    }                     
                    side_mounts(MOUNT_HEIGHT);
                    translate([0, VERTICAL_BRIDGE_OFFSET, 0])     
                    vertical_bridge(MOUNT_HEIGHT);
                    bridge_with_mount();            
                }
            }
            if(HULL_TYPE==2){
                union(){
                    if(WITH_SHELF){
                        translate([0,0,MOUNT_HEIGHT])
                        shelf(SHELF_THICKNESS);
                    }                    
                    side_mounts(MOUNT_HEIGHT);
                    hull(){
                        translate([0, VERTICAL_BRIDGE_OFFSET, 0])                        
                        vertical_bridge(MOUNT_HEIGHT);                
                        bridge_with_mount();                            
                    }
                }            
            }
        }      

        // Poles
        side_poles();
        
        
        // Holder cutouts
        translate([0,BRIDGE_X_OFFSET, BRIDGE_THICKNESS/2 + BRIDGE_Z_OFFSET])
        rotate([BRIDGE_ANGLE,0,0])       
        union(){
            translate([0,SMA_HOLE_OFFSET,0])
            sma_hole();
            
            translate([0,SMA_HOLE_OFFSET,0])
            sma_outliner();                 
            
            translate([0,SMA_HOLE_OFFSET,0])
            sma_plate();        
        }
        
        //Additional cutout
        if(WITH_SHELF){
            union(){
                width = WIDTH - 6;
                cutout_thickness = 2;
                translate([0,0,MOUNT_HEIGHT-cutout_thickness/2])
                cube([width, 10, cutout_thickness],true);            
            }
        }
        
        if(BOUNDED){
            // LOWER bound
            translate([0,0,-WIDTH/2])
            cube([WIDTH*2, WIDTH*2, WIDTH], true);
            
            // UPPER bound    
            translate([0,0,MOUNT_HEIGHT+WIDTH/2])
            cube([WIDTH*2, WIDTH*2, WIDTH], true);   
        }        
        
    }

    if(DEBUG){
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
    
    translate([0,0, height/2])
    cylinder(height, outside_diameter/2, outside_diameter/2, true);
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
    
    translate([0,0, MOUNT_HEIGHT/2])
    cylinder(MOUNT_HEIGHT*2, MOUNT_DIAMETER/2, MOUNT_DIAMETER/2, true);        
}

module vertical_bridge(height){
    translate([0,0, height/2])    
    cube([VERTICAL_BRIDGE_WIDTH, VERTICAL_BRIDGE_THICKNESS, height], true);      
}

module bridge_with_mount(){
    translate([0,BRIDGE_X_OFFSET, BRIDGE_THICKNESS/2 + BRIDGE_Z_OFFSET])
    rotate([BRIDGE_ANGLE,0,0])    
    bridge(BRIDGE_WIDTH, MIN_BRIDGE_WIDTH, BRIDGE_HEIGHT, BRIDGE_THICKNESS);  
}

module bridge(wider_width, min_width, height, thickness){
    rounded_corners_trapeze(wider_width, min_width, height, thickness, CORNERS_DIAMETER);
}

module sma_hole(){
    color("grey")
    cylinder(BRIDGE_THICKNESS*20, SMA_HOLE_DIAMETER/2, SMA_HOLE_DIAMETER/2, true);            
}

module sma_outliner(){
    outliner_thickness = BRIDGE_THICKNESS*10;
    color("grey")    
    translate([0,0,outliner_thickness/2])    
    cylinder(outliner_thickness, SMA_OUTLINER_DIAMETER/2, SMA_OUTLINER_DIAMETER/2, true);            
}

module sma_plate(){
    outliner_thickness = BRIDGE_THICKNESS*20;
    color("grey")
    translate([0,0,outliner_thickness/2+BRIDGE_THICKNESS/2])
    cube([SMA_CUTOUT_WIDTH, SMA_CUTOUT_HEIGHT, outliner_thickness], true);            
}


module shelf(thickness){
    holder_thickness = 2;
    
    translate([0,-SHELF_LENGTH/2-SHELF_Y_OFFSET,-thickness/2])
    cube([BRIDGE_WIDTH, SHELF_LENGTH, thickness], true);           

    straight_shelf_holders(BRIDGE_WIDTH, holder_thickness);

//    translate([0,0,-MOUNT_HEIGHT+holder_thickness])
//    straight_shelf_holders(BRIDGE_WIDTH, holder_thickness);    
    
    angled_shelf_holders(BRIDGE_WIDTH, holder_thickness);
    
//    translate([0,-15,0])
//    vtx(2);
}

module straight_shelf_holders(width, thickness){
    angle = 90;
    length1 = 12;
    x_offset = width/2 - thickness/2;
    y_offset = 0;
    
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
    length1 = 15;
    x_offset = width/2 - thickness/2;
    y_offset = -1;
    
    translate([0,y_offset,-length1/2])
    rotate([angle,0,0])
    union(){
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

module vtx(h)
{
    
  HEIGHT = 2;
  fudge = 0.1;
  //From INKSCAPE
    
  SCALE = 3.58;
  translate([0,0,HEIGHT/2])
  rotate([0,0,0])    
  scale([SCALE,SCALE,HEIGHT])    
  scale([25.4/90, -25.4/90, 1]) union()
  {
    difference()
    {
       linear_extrude(height=h)
         polygon([[-8.674923,-12.135435],[-8.674923,-3.728712],[-8.674923,-2.746859],[-4.376478,-2.746859],[-4.376478,-2.634721],[-4.376478,1.861645],[-2.013831,1.861645],[-2.013831,3.869275],[-4.340304,3.869275],[-4.340304,3.560249],[-8.275981,3.560249],[-8.275981,3.567483],[-8.606711,3.567483],[-8.606711,12.106497],[-5.498372,12.106497],[-5.498372,10.396008],[-5.498372,9.813613],[-5.048271,9.813613],[-4.428154,9.813613],[-4.428154,9.381598],[-3.728455,9.381598],[-3.728455,6.487718],[-3.975986,6.487718],[-3.975986,6.479966],[-5.711280,6.479966],[-5.711280,8.034912],[-7.299296,8.034912],[-7.299296,5.429385],[-7.299296,4.503343],[-5.711280,4.503343],[-2.404504,4.503343],[-2.404504,4.602562],[-2.404504,5.429385],[-2.404504,7.744489],[-2.418458,7.744489],[-2.418458,8.329983],[0.273367,8.329983],[0.273367,9.133551],[0.951362,9.133551],[0.951362,9.736616],[0.951362,10.001200],[0.951362,10.787197],[2.505789,10.787197],[2.505789,10.001200],[4.319116,10.001200],[4.319116,10.298856],[4.970238,10.298856],[4.970238,6.775040],[5.746419,6.775040],[7.698753,6.775040],[7.698753,12.135435],[8.650118,12.135435],[8.650118,6.775040],[8.650118,2.456958],[8.650118,2.308130],[8.650118,0.968158],[8.650118,-1.984116],[8.674923,-1.984116],[8.674923,-12.059470],[8.599990,-12.059470],[8.599990,-12.065153],[4.444688,-12.065153],[0.104902,-12.065153],[0.104902,-7.004481],[-4.126365,-7.004481],[-4.126365,-12.135435],[-8.674923,-12.135435]]);
       translate([0, 0, -fudge])
         linear_extrude(height=h+2*fudge)
           polygon([[4.444688,-7.651988],[7.898741,-7.651988],[7.898741,-3.962807],[7.002155,-3.962807],[7.002155,0.633812],[0.289388,0.633812],[0.289388,-1.861127],[0.255281,-1.861127],[0.255281,-3.682204],[4.444172,-3.682204],[4.444172,-4.838205],[4.444172,-7.004481],[4.444688,-7.651988]]);
       translate([0, 0, -fudge])
         linear_extrude(height=h+2*fudge)
           polygon([[-1.462961,-4.464068],[-0.216008,-4.464068],[-0.216008,-3.682204],[-0.216008,-1.861127],[-1.462961,-1.861127],[-1.462961,-4.464068]]);
       translate([0, 0, -fudge])
         linear_extrude(height=h+2*fudge)
           polygon([[4.192508,2.456958],[5.746419,2.456958],[5.746419,5.311047],[4.970238,5.311047],[4.749064,5.311047],[4.319116,5.311047],[4.192508,5.311047],[4.192508,2.456958]]);
       translate([0, 0, -fudge])
         linear_extrude(height=h+2*fudge)
           polygon([[-1.426271,4.640802],[3.894852,4.640802],[3.894852,5.311047],[3.861779,5.311047],[3.861779,9.067406],[2.075841,9.067406],[2.075841,8.141364],[1.182873,8.141364],[1.182873,7.744489],[-1.426271,7.744489],[-1.426271,4.640802]]);
    }
  }
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
