require 'rubygems'
require 'optparse'
require 'haml'
require 'hpricot'
require 'yaml'

# RSSIFY_VERSION = "0.0.0"

# optparse = OptionParser.new do |opt|
#   opt.banner = "Usage: #{$0} directory [OPTIONS]"
#   opt.separator ""

#   opt.on "-v", "--version", "Show version" do
#     puts "RSSify version #{RSSIFY_VERSION}"
#     exit
#   end

#   opt.on_tail "-h", "--help", "Display this help message" do
#     puts opt
#     exit
#   end

# end

# optparse.parse!

# if not ARGV or ARGV.empty?
#   puts optparse
#   exit
# else
#   path = File.expand_path(ARGV.first)
# end

class RSSify

  def initialize(path, options={})
    full_path = File.expand_path(path)
    if !File.exists?(full_path)
      raise "#{full_path} does not exist."
    end

    if !File.directory?(full_path)
      raise "#{full_path} is not a directory."
    end

    entry_paths = Dir.glob(full_path+"/*.html")

    config = YAML::load_file(full_path+"/rssify.yml") || (raise "I need an rssify.yml file in #{full_path}")

    puts config.inspect

    feed = config['feed']
    puts feed.inspect

    entries = entry_paths.map do |entry_path|
      html = File.read(entry_path)
      doc = Hpricot(html)
      link = config['docroot'] + "/" + File.basename(entry_path)
      { :guid    => link,
        :link    => link,
        :comments=> link+"#comments",
        :title   => doc.at('head/title').inner_html,
        :pubDate => File.mtime(entry_path).strftime("%a, %d %b %Y %H:%M:%S %z"),
        :author => feed['author'],
        :description => doc.at('body').inner_html
      }
    end

    eng = Haml::Engine.new(File.read("templates/rss.haml"))
    result = eng.render(Object.new, {:feed=>feed, :entries=>entries})
    File.open("rss.xml", "w") do |f|
      f << result
    end
  end

end

#RSSify.new(ARGV.first)
