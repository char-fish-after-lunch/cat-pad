
# PlanAhead Launch Script for Post-Synthesis floorplanning, created by Project Navigator

create_project -name cat_pad -dir "C:/Users/YU_Jason/Documents/cat-pad/planAhead_run_2" -part xc3s1200efg320-4
set_property design_mode GateLvl [get_property srcset [current_run -impl]]
set_property edif_top_file "C:/Users/YU_Jason/Documents/cat-pad/cat_pad.ngc" [ get_property srcset [ current_run ] ]
add_files -norecurse { {C:/Users/YU_Jason/Documents/cat-pad} }
set_property target_constrs_file "cat_pad.ucf" [current_fileset -constrset]
add_files [list {cat_pad.ucf}] -fileset [get_property constrset [current_run]]
link_design
