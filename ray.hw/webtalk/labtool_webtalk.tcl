webtalk_init -webtalk_dir C:/Xilinx/Projects/ray/ray.hw/webtalk/
webtalk_register_client -client project
webtalk_add_data -client project -key date_generated -value "Fri Oct 20 23:17:00 2023" -context "software_version_and_target_device"
webtalk_add_data -client project -key product_version -value "Vivado v2015.2 (64-bit)" -context "software_version_and_target_device"
webtalk_add_data -client project -key build_version -value "1266856" -context "software_version_and_target_device"
webtalk_add_data -client project -key os_platform -value "WIN64" -context "software_version_and_target_device"
webtalk_add_data -client project -key registration_id -value "212796689_0_0_244" -context "software_version_and_target_device"
webtalk_add_data -client project -key tool_flow -value "labtool" -context "software_version_and_target_device"
webtalk_add_data -client project -key beta -value "FALSE" -context "software_version_and_target_device"
webtalk_add_data -client project -key route_design -value "FALSE" -context "software_version_and_target_device"
webtalk_add_data -client project -key target_family -value "not_applicable" -context "software_version_and_target_device"
webtalk_add_data -client project -key target_device -value "not_applicable" -context "software_version_and_target_device"
webtalk_add_data -client project -key target_package -value "not_applicable" -context "software_version_and_target_device"
webtalk_add_data -client project -key target_speed -value "not_applicable" -context "software_version_and_target_device"
webtalk_add_data -client project -key random_id -value "3d741456-428a-451c-adbd-0069a169e425" -context "software_version_and_target_device"
webtalk_add_data -client project -key project_id -value "2b86b35f-a335-423a-874c-5627e36a85b4" -context "software_version_and_target_device"
webtalk_add_data -client project -key project_iteration -value "12" -context "software_version_and_target_device"
webtalk_add_data -client project -key os_name -value "Microsoft Windows 8 or later , 64-bit" -context "user_environment"
webtalk_add_data -client project -key os_release -value "major release  (build 9200)" -context "user_environment"
webtalk_add_data -client project -key cpu_name -value "Intel(R) Core(TM) i7-7820HQ CPU @ 2.90GHz" -context "user_environment"
webtalk_add_data -client project -key cpu_speed -value "2904 MHz" -context "user_environment"
webtalk_add_data -client project -key total_processors -value "1" -context "user_environment"
webtalk_add_data -client project -key system_ram -value "17.000 GB" -context "user_environment"
webtalk_register_client -client labtool
webtalk_add_data -client labtool -key cable -value "Digilent/Basys3/15000000" -context "labtool\\usage"
webtalk_add_data -client labtool -key chain -value "0362D093" -context "labtool\\usage"
webtalk_add_data -client labtool -key pgmcnt -value "01:00:00" -context "labtool\\usage"
webtalk_transmit -clientid 1828787982 -regid "212796689_0_0_244" -xml C:/Xilinx/Projects/ray/ray.hw/webtalk/usage_statistics_ext_labtool.xml -html C:/Xilinx/Projects/ray/ray.hw/webtalk/usage_statistics_ext_labtool.html -wdm C:/Xilinx/Projects/ray/ray.hw/webtalk/usage_statistics_ext_labtool.wdm -intro "<H3>LABTOOL Usage Report</H3><BR>"
webtalk_terminate
