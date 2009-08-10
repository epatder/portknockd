require 'rubygems'
require 'hpricot'

class Rule 
  def initialize(port, passkey)
    @port = port
    @passkey = passkey
  end
end

args = [""]
n = 1
ARGV.each do|a|
  args[n] = "#{a}"
  n+=1
end

if args.length < 2
  puts "Usage: portknockerd input.file"
  exit
end

begin
  f = File.open(args[1], "r")
rescue Errno::ENOENT
  puts "error: file '#{args[1]}' does not exist.\n"
end

n = 0
ruleset = {}
# have a bad feeling about the File.read(args[1]) bit, need to change it. 
doc = Hpricot::XML(File.read(args[1]))
(doc/'ruleset').each do |doc|
  ruleset['rules'] = []
  ruleset['script'] = (doc/'script').inner_html
  ruleset['comment'] = (doc/'comment').inner_html
  
  (doc/'rule').each do |doc|
    ruleset['rules'][n] = Rule.new((doc/'port').inner_html, (doc/'passkey').inner_html)
    n+=1
  end
  
end

puts "Parsed input file #{args[1]}, will now run with ruleset of:"

p ruleset
#while n < ruleset['rules'][n].length 
#  puts "#{ruleset['rules'][n]['port']} #{ruleset['rules'][n]['passkey']}"
#  n+=1
#end
