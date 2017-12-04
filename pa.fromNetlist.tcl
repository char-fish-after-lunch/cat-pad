
# PlanAhead Launch Script for Post-Synthesis pin planning, created by Project Navigator

create_project -name cat_pad -dir "D:/workspace/xilinx/cat_pad/planAhead_run_3" -part xc3s1200efg320-4
set_property design_mode GateLvl [get_property srcset [current_run -impl]]
set_property edif_top_file "D:/workspace/xilinx/cat_pad/cat_pad.ngc" [ get_property srcset [ current_run ] ]
add_files -norecurse { {D:/workspace/xilinx/cat_pad} }
set_param project.pinAheadLayout  yes
set_property target_constrs_file "cat_pad.ucf" [current_fileset -constrset]
add_files [list {cat_pad.ucf}] -fileset [get_property constrset [current_run]]
link_design
