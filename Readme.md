## Build the gem
 
gem build harry_potter.gemspec

## Install the gem

gem install harry_potter-0.0.1.gem

## Start the console

irb

## Instanciate HarryPotter

require "harry_potter"

hp = HarryPotter.new

## set a random fight

hp.random_fight

## get help list
HarryPotter.cmd_list()
