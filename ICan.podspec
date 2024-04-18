Pod::Spec.new do |spec|
  spec.name = 'ICan'
  spec.version = '1.0.0'
  spec.summary = 'A brief description of your ICan library'
  spec.homepage = 'https://github.com/Kalana97/ICanSdk' # Corrected GitHub repository URL
  spec.license = { :type => 'MIT', :file => 'LICENSE' } # Ensure LICENSE file exists in repository
  spec.author = { 'Kusal' => 'rmkalana97@gmail.com' } # Update with correct author information
  spec.source = { :git => 'https://github.com/Kalana97/ICanSdk.git', :tag => spec.version.to_s }
  spec.platform = :ios, '13.0' # Minimum iOS deployment target
  spec.source_files = 'ICan/**/*.{h,m,swift}' # Path to source files relative to repository root
end

