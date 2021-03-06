JRUBY_GEMS_JAR = 'jruby-gems.jar'
 
namespace :jruby do

  task :init do
    FileUtils.rm_rf 'tmp'
    FileUtils.mkdir_p 'tmp'
  end

  desc 'extract jruby and all the current gems into the tmp folder'
  task :extract => :init do
    extract
  end

  desc "repackage jruby and gems from tmp into the #{JRUBY_GEMS_JAR} file"
  task :repackage do 
    repackage
  end
  
  desc "instal gems with bundle install"
  task :bundle do 
    unless Dir.entries(".").include?("tmp")
      init
      extract 
    end
   puts `java -jar #{JRUBY_GEMS_JAR} -S bundle install --path tmp`
   repackage
  end
  
  desc "add gem server as source"
  task :add_source, [:source] do |task, args|
    source = args[:source].strip
    puts `java -jar #{JRUBY_GEMS_JAR} -S gem sources -a #{source}`
  end

  desc "add a gem to the #{JRUBY_GEMS_JAR} file"
  task :add_gem, [:gem_name, :version] do |task, args|
    unless Dir.entries(".").include?("tmp")
      init
      extract 
    end
    gem_name = args[:gem_name].strip
    if args[:version]
      version = args[:version].strip
      puts `java -jar #{JRUBY_GEMS_JAR} -S gem install -i tmp #{gem_name} -v '#{version}'`
    else
      puts `java -jar #{JRUBY_GEMS_JAR} -S gem install -i tmp #{gem_name}`
    end
    repackage
  end

  desc "uninstall a gem from the #{JRUBY_GEMS_JAR} file"
  task :remove_gem, [:gem_name, :version] do |task, args|
    unless Dir.entries(".").include?("tmp")
      init
      extract 
    end
    gem_name = args[:gem_name].strip
    if args[:version]
      version = args[:version].strip
      java_cmd = "java -jar #{JRUBY_GEMS_JAR} -S gem uninstall -i tmp #{gem_name} -v '#{version}' -I -a"
    else
      puts "If there are multiple versions of a gem installed, they will all be removed."
      java_cmd = "java -jar #{JRUBY_GEMS_JAR} -S gem uninstall -i tmp #{gem_name} -I -a"
    end
    puts `#{java_cmd}`
    repackage
  end

  desc "list gems that are installed"
  task :list_gems do 
    puts `java -jar #{JRUBY_GEMS_JAR} -S gem list`
  end

  def extract
    Dir.chdir('tmp') do
      `jar -xf ../#{JRUBY_GEMS_JAR}`
    end
  end

  def repackage
    FileUtils.rm_rf JRUBY_GEMS_JAR
    FileUtils.mv(Dir.glob('tmp/bin/*'), 'tmp/META-INF/jruby.home/bin')
    `jar -cfm #{JRUBY_GEMS_JAR} jruby-gems.manifest -C tmp .`
  end

end
