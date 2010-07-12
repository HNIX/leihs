Given /^pending$/ do
  pending
end

Given "pending - reported by $who on $date" do |who, date|
  pending
end

Given /pending - (?!reported by)(.*)/ do |explanation|
  pending
end

When /(\w+) wait (\d+) second(s?)/ do |who, seconds, plural|
  sleep seconds.to_i
end

When "I switch off JavaScript because $reason" do |reason|
  # see https://sourceforge.net/tracker/index.php?func=detail&aid=2969230&group_id=47038&atid=448266
  $browser.javascript_enabled=false
end
