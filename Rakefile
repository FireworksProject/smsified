ROOT = File.dirname(__FILE__)

task :default => :build

directory 'dist'

file 'node_modules/coffee-script' do
    npm_install 'coffee-script'
end

file 'node_modules/treadmill' do
    npm_install 'treadmill'
end

file 'node_modules/q' do
    npm_install 'q'
end

file 'dist/index.js' => ['index.coffee', 'dist'] do |task|
    brew_javascript task.prerequisites.first, task.name
end

file 'dist/MIT-LICENSE' => ['MIT-LICENSE', 'dist'] do |task|
    FileUtils.cp task.prerequisites.first, task.name
end

file 'dist/package.json' => ['package.json', 'dist'] do |task|
    FileUtils.cp task.prerequisites.first, task.name
    Dir.chdir('dist')
    sh 'npm install' do |ok, id|
        ok or fail "npm could not install arrow"
    end
    Dir.chdir(ROOT)
end

desc "Build into the dist/ directory for testing and distribution"
build_deps = [
    'dist/MIT-LICENSE',
    'dist/package.json',
    'dist/index.js'
]
task :build => build_deps do
    puts "Build done"
end

desc "Remove the dist/ directory"
task :clean do
    rm_rf 'dist'
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
