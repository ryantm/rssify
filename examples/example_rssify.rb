require 'rssify'

describe RSSify do
  it "should take a path to a directory" do
    lambda { RSSify.new("examples/mock") }.should_not raise_error
  end

  it "should not take a non-existent directory" do
    lambda { RSSify.new("sdfjaldasjfalkj") }.should raise_error
  end

  it "should not take a file" do
    lambda { RSSify.new("examples/example_rssify.rb") }.should raise_error
  end

  it "should RSSify mock" do
    RSSify.new("examples/mock")
  end
end
