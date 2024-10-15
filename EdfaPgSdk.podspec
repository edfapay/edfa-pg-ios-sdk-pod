#
#  Be sure to run `pod spec lint EdfaPgSdk.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#
#
#  ―――――――――――――――――――――――――――――――――――――――――――――――――――――
#  Create/Delete Pod on Cocoapod - Terminal Commands
#  ―――――――――――――――――――――――――――――――――――――――――――――――――――――
#  (Register) > pod trunk register <email> <user_name>
#  (Validate) > pod lib lint
#  (Create)   > pod trunk push <*.podspec>
#  (Delete)   > pod trunk delete <pod_name> <pod_version>
#


Pod::Spec.new do |spec|

    
  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  These will help people to find your library, and whilst it
  #  can feel like a chore to fill in it's definitely to your advantage. The
  #  summary should be tweet-length, and the description more in depth.
  #
  
  spec.name         = "EdfaPgSdk"
  spec.version      = "1.0.7"
  spec.summary      = "(EdfaPgSdk) Edfa Payment Gateway SDK is an payment library written in Swift."
  
  # This description is used to generate tags and improve search results.
  #   * Think: What does it do? Why did you write it? What is the focus?
  #   * Try to keep it short, snappy and to the point.
  #   * Write the description between the DESC delimiters below.
  #   * Finally, don't worry about the indent, CocoaPods strips it!
  spec.description  = <<-DESC
  EdfaPgSdk iOS SDK was developed and designed with to help the developers to easily integrate the Edfa Payment Gateway Platform for a specific merchant.
  DESC

  spec.homepage     = "https://edfapay.com"
  spec.screenshots  = "https://github.com/edfapay/edfa-pg-ios-sdk-pod/blob/main/media/sale.png?raw=true", "https://github.com/edfapay/edfa-pg-ios-sdk-pod/blob/main/media/recurring-sale.png?raw=true", "https://github.com/edfapay/edfa-pg-ios-sdk-pod/blob/main/media/capture.png?raw=true", "https://github.com/edfapay/edfa-pg-ios-sdk-pod/blob/main/media/creditvoid.png?raw=true", "https://github.com/edfapay/edfa-pg-ios-sdk-pod/blob/main/media/get-trans-status.png?raw=true", "https://github.com/edfapay/edfa-pg-ios-sdk-pod/blob/main/media/get-trans-details.png?raw=true"
  
  
  # ―――  Spec License  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Licensing your code is important. See http://choosealicense.com for more info.
  #  CocoaPods will detect a license file if there is a named LICENSE*
  #  Popular ones are 'MIT', 'BSD' and 'Apache License, Version 2.0'.
  #
  
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  
  
  # ――― Author Metadata  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Specify the authors of the library, with email addresses. Email addresses
  #  of the authors are extracted from the SCM log. E.g. $ git log. CocoaPods also
  #  accepts just a name if you'd rather not provide an email address.
  #
  #  Specify a social_media_url where others can refer to, for example a twitter
  #  profile URL.
  #
    
  spec.author       = { "EdfaPay" => "itsupport@edfapay.com" }
  
  
  # ――― Platform Specifics ――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  If this Pod runs only on iOS or OS X, then specify the platform and
  #  the deployment target. You can optionally include the target after the platform.
  #
  
  spec.platform     = :ios, "11.0"
  spec.swift_version = "5"


  # ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Specify the location from where the source should be retrieved.
  #  Supports git, hg, bzr, svn and HTTP.
  #

  spec.source       = { :git => "https://github.com/edfapay/edfa-pg-ios-sdk-pod.git", :tag => "#{spec.version}" }

  # ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  CocoaPods is smart about how it includes source code. For source files
  #  giving a folder will include any swift, h, m, mm, c & cpp files.
  #  For header files it will include any header in the folder.
  #  Not including the public_header_files will make all headers public.
  #
  spec.source_files  = "#{spec.name}/**/*.{swift,xib}"

  spec.resources = '**/*{png}'

  spec.exclude_files = "Classes/Exclude"

end
