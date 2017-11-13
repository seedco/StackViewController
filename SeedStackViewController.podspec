Pod::Spec.new do |s|
  s.name = "SeedStackViewController"
  s.module_name = "StackViewController"
  s.version = "0.4.0"
  s.summary = "Simplifies the process of building forms and other static content using UIStackView."
  s.description = "StackViewController is a Swift framework that simplifies the process of building forms and other static content using UIStackView."
  s.homepage = "https://github.com/seedco/StackViewController"
  s.license = "MIT"
  s.author = "Seed"
  s.source = {
    git: "https://github.com/seedco/StackViewController.git",
    tag: s.version.to_s
  }
  s.ios.deployment_target = "9.0"
  s.source_files = "StackViewController/*.{h,swift}"
  s.frameworks = "UIKit"
end
