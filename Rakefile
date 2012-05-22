ROOT = File.dirname(__FILE__)

task :default => :build

directory 'smsified'

file 'node_modules/coffee-script' do
    npm_install 'coffee-script'
end

file 'node_modules/treadmill' do
    npm_install 'treadmill'
end

file 'node_modules/q' do
    npm_install 'q'
end

file 'smsified/index.js' => ['index.coffee', 'smsified'] do |task|
    brew_javascript task.prerequisites.first, task.name
end

file 'smsified/MIT-LICENSE' => ['MIT-LICENSE', 'smsified'] do |task|
    FileUtils.cp task.prerequisites.first, task.name
end

file 'smsified/package.json' => ['package.json', 'smsified'] do |task|
    FileUtils.cp task.prerequisites.first, task.name
    Dir.chdir('smsified')
    sh 'npm install' do |ok, id|
        ok or fail "npm could not install arrow"
    end
    Dir.chdir(ROOT)
end

desc "Build into the smsified/ directory for testing and distribution"
build_deps = [
    'smsified/MIT-LICENSE',
    'smsified/package.json',
    'smsified/index.js'
]
task :build => build_deps do
    puts "Build done"
end

desc "Remove the smsified/ directory"
task :clean do
    rm_rf 'smsified'
    rm_rf 'node_modules'
end

desc "Setup development environment"
dev_deps = [
    'node_modules/coffee-script',
    'node_modules/treadmill',
    'node_modules/q'
]
task :devsetup => dev_deps do
    puts "Development environment ready"
end

desc "Run Treadmill tests"
task :test => [:devsetup, :build] do
    system 'node test/runtests.js'
end

desc "Run Treadmill tests on live SMSified service"
testlive_args = [
    :username,
    :password,
    :address,
    :target
]
task :testlive, testlive_args => [:devsetup, :build] do |task, args|
    args.with_defaults(:username => 'true')
    system "node test/runtests.js #{args[:username]} #{args[:password]} #{args[:address]} #{args[:target]}"
end

desc "Publish tarball to server for deployment"
task :publish, [:version] => :build do |task, args|
    sh "bin/publish #{args[:version]}" do |ok, id|
        ok or fail "could not publish"
    end
end

def brew_javascript(source, target)
    File.open(target, 'w') do |fd|
        fd << %x[coffee -pb #{source}]
    end
end

def npm_install(package)
    sh "npm install #{package}" do |ok, id|
        ok or fail "npm could not install #{package}"
    end
end
