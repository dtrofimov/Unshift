platform :ios, '13.0'

target 'Unshift' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Unshift
  pod 'SnapKit'
  pod 'RxSwift'
  pod 'RxCocoa'
  pod 'Then'

  target 'UnshiftTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'UnshiftUITests' do
    # Pods for testing
  end

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    if target.name == 'RxSwift'
      target.build_configurations.each do |config|
        if config.name == 'Debug'
          config.build_settings['OTHER_SWIFT_FLAGS'] ||= ['$(inherited)', '-D TRACE_RESOURCES']
        end
      end
    end
  end
end
