source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '15.0'
use_frameworks!
inhibit_all_warnings!

target 'PlantID' do
    
pod 'RealmSwift'
pod 'ApphudSDK'

post_install do |installer|
  installer.pods_project.targets.each do |target|
    if target.name == 'Realm'
      create_symlink_phase = target.shell_script_build_phases.find { |x| x.name == 'Create Symlinks to Header Folders' }
      create_symlink_phase.always_out_of_date = "1"
    end
  end
end

    
end
