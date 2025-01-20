############################################################
### Set search_path
set_app_var search_path [concat $search_path /home/vlsilab2/TSMCHOME/Executable_Package/Collaterals/IP/stdcell/N16ADFP_StdCell/CCS/ /home/vlsilab2/TSMCHOME/Executable_Package/Collaterals/IP/stdio/N16ADFP_StdIO/NLDM/]
#########
#########
## Set Target Library & Min Versions for each target library
set target_library "N16ADFP_StdCelltt0p8v25c_ccs.db N16ADFP_StdIOtt0p8v1p8v25c.db"
set_app_var link_library "$target_library"
##### Set lef #######
set lef_library { /home/class/ee5327ta/N16ADFP_StdCell/updated_LEF/N16ADFP_StdCell.lef /home/vlsilab2/TSMCHOME/Executable_Package/Collaterals/IP/stdio/N16ADFP_StdIO/LEF/N16ADFP_StdIO.lef}

# Prepare work/log directories
file mkdir "./work"

echo "\n\nLibrary Settings:"
echo "========================================"
echo "search_path:     \"$search_path\""
echo "link_library:    \"$link_library\""
echo "target_library:  \"$target_library\""
echo "========================================\n\n"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# # General setup
# # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

file delete -force "./logs"
file mkdir "./logs"
file mkdir "./ndms"

# Create log files with datestamp
set timestamp [clock format [clock scan now] -format "%Y-%m-%d_%H-%M"]
set sh_output_log_file "./logs/${synopsys_program_name}.log.$timestamp"


# set GDS_OUT_LAYER_MAP           
set MW_TECH_FILE               /home/vlsilab2/TSMCHOME/Executable_Package/Collaterals/Tech/APR/N16ADFP_APR_ICC2/N16ADFP_APR_ICC2_11M.10a.tf 
set MAX_TLUPLUS_FILE           /home/vlsilab2/TSMCHOME/Executable_Package/Collaterals/Tech/RC/N16ADFP_STARRC/N16ADFP_STARRC_worst.nxtgrd 
set MIN_TLUPLUS_FILE           /home/vlsilab2/TSMCHOME/Executable_Package/Collaterals/Tech/RC/N16ADFP_STARRC/N16ADFP_STARRC_best.nxtgrd 
# set TLUPLUS_MAP_FILE            
set MW_POWER_NET                "VDD"
set MW_GROUND_NET               "VSS"


## some to guide the tool ###
set auto_restore_mw_cel_lib_setup true
set mw_logic1_net $MW_POWER_NET
set mw_logic0_net $MW_GROUND_NET
set legalize_auto_x_keepout_margin 0
set legalize_auto_y_keepout_margin 0
set no_row_gap 1
set_host_options -max_cores 4
set_app_options -name  lib.workspace.save_design_views  -value true
set_app_options -name  lib.workspace.save_layout_views  -value true
# set DESIGN_NAME counter_cr
set DESIGN_NAME N16ADFP_StdCell 

## Removing the previous LIB ### 
if {[file exists ${DESIGN_NAME}]} { sh rm -rf ${DESIGN_NAME} }

### Creating the workspace #### 
create_workspace ${DESIGN_NAME} -flow exploration  -technology $MW_TECH_FILE
read_lef $lef_library
#return
read_db $link_library
read_parasitic_tech -tlup $MAX_TLUPLUS_FILE -name tlu_max
read_parasitic_tech -tlup $MIN_TLUPLUS_FILE  -name tlu_min

group_libs
## checking workspace ## 
check_workspace
## commiting the workspace ## 
#commit_workspace -output  ${DESIGN_NAME} -directory ndms/
process_workspaces -output  ${DESIGN_NAME} -directory ndms/

