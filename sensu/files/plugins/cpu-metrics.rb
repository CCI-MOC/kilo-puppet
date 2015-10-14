#! /usr/bin/env ruby
#  encoding: UTF-8
#
#   cpu-metrics
#
# DESCRIPTION:
#
# OUTPUT:
#   metric data
#
# PLATFORMS:
#   Linux
#
# DEPENDENCIES:
#   gem: sensu-plugin
#   gem: socket
#
# USAGE:
#
# NOTES:
#
# LICENSE:
#   Copyright 2012 Sonian, Inc <chefs@sonian.net>
#   Released under the same terms as Sensu (the MIT license); see LICENSE
#   for details.
#
require 'rubygems' if RUBY_VERSION < '1.9.0'
require 'sensu-plugin/metric/cli'
require 'socket'

class CpuGraphite < Sensu::Plugin::Metric::CLI::Graphite
  option :scheme,
         description: 'Metric naming scheme, text to prepend to metric',
         short: '-s SCHEME',
         long: '--scheme SCHEME',
         default: "#{Socket.gethostname}.cpu"

  def run
    cpu_metrics = %w(user nice system idle iowait irq softirq steal guest)
    other_metrics = %w(ctxt processes procs_running procs_blocked btime intr)
    cpu_count = 0
    #Print cpu used percentage
    usedPercentage = `top -bn 2| grep "%Cpu(s)"| tail -1| awk '{print $2 + $4 "%"}'`
    print "usedPercentage ", usedPercentage

    File.open('/proc/stat', 'r').each_line do |line|
      info = line.split(/\s+/)
      next if info.empty?
      name = info.shift

      if name.match(/cpu([0-9]+|)/)
        # #YELLOW
        cpu_count = cpu_count + 1 # rubocop:disable Style/SelfAssignment
        name = 'total' if name == 'cpu'
        info.size.times { |i| print "#{name}.#{cpu_metrics[i]}", " ", info[i], " USER_HZ","\n" }
      end

      #output "#{config[:scheme]}.#{name}", info.last if other_metrics.include? name
      print "#{name}", " ",info.last,  "\n" if other_metrics.include? name 
    end
    if cpu_count > 0
      # writes the number of cpus, the minus 1 is because /proc/stat/
      # first line is a "cpu" which is stats for total cpus
      print 'cpu_count ', cpu_count - 1
    end

    ok
  end
end
