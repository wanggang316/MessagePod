
Pod::Spec.new do |s|

s.name                    = 'MessagePod'
s.version                 = '0.0.1'
s.summary                 = 'A fast, customizable message UI Library.'
s.homepage                = 'https://github.com/wanggang316/MessagePod'
s.license                 = { :type => 'MIT', :file => 'LICENSE' }
s.author                  = { 'gump' => '1989wg@gmail.com' }
s.social_media_url        = 'https://twitter.com/wgang316'

s.source                  = { :git => 'https://github.com/wanggang316/MessagePod.git', :tag => s.version.to_s }


s.source_files             = 'MessagePod/Classes/**/*.swift'

s.pod_target_xcconfig      = {
    'SWIFT_VERSION' => '4.0',
}

s.ios.deployment_target   = '9.0'

end
