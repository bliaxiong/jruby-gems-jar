# jruby-gems-jar

Sometimes a really simple solution is best. For distributing a ruby environment in a complex build pipeline,
a single jar file containing a ruby runtime and all the gems you want for your project 
can be a really simple way to go.

That is what this little project tries to do - package up ruby and all your gems into a single jar file, along with any executables from those gems.

## Getting Started

- First, download the jruby-complete.jar file from the latest jruby release at http://jruby.org/download.
- Rename the jruby-complete.jar file to jruby-gems.jar and place it in this project's directory.
- Now run "java -jar jruby-gems.jar -S rake -T" to see what options are available for adding / removing gems to the jar.


## The rakefile details
<pre>
rake jruby:add_gem[gem_name, version]     ( add a gem to the jruby-gems.jar file )
rake jruby:extract                        ( extract jruby and all the current gems into a tmp directory )
rake jruby:remove_gem[gem_name, version]  ( uninstall a gem from the jruby-gems.jar )
rake jruby:repackage                      ( repackage jruby and gems from tmp back into jruby-gems.jar )
rake jruby:add-source[source]             ( add gem server source )
rake jruby:remove-source[source]          ( remove gem server source )
</pre>

## Install gems with bundle install

Make sure you have a Gemfile in the same directory as the jruby-gems.jar. Run 'rake jruby:extract' which creates the tmp
folder then run 'bundle install --path tmp' and it will install the gems into the tmp folder. After installing, repackage the
jar.

## Manual install of gems

<pre>rake jruby:extract</pre>

Then to install multiple gems at once run a command line this
<pre>java -jar jruby-gems.jar -S gem install -i tmp gem1 gem2 gem3</pre>
<pre>java -jar jruby-gems.jar -S gem install -i tmp gem1 -v '1.2.3'</pre>

Then package it back up.
<pre>rake jruby:repackage</pre>

