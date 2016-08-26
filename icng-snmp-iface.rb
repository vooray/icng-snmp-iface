#!/usr/bin/ruby

require 'snmp'
require 'slop'

# host = '192.168.23.130'
# peer = '192.168.0.2'
# community = 'public'


$oid = {
    :inter_table => '.1.3.6.1.2.1.2.2.1',
    :index_table => '1.3.6.1.2.1.2.2.1.1',
    :descr_table => '1.3.6.1.2.1.2.2.1.2',
    :oper_table => '1.3.6.1.2.1.2.2.1.8.',
    :admin_table => '1.3.6.1.2.1.2.2.1.7.',
    :speed_table => '1.3.6.1.2.1.2.2.1.5.',
    :speed_table_64 => '1.3.6.1.2.1.31.1.1.1.15.',
    :in_octet_table => '1.3.6.1.2.1.2.2.1.10.',
    :in_octet_table_64 => '1.3.6.1.2.1.31.1.1.1.6.',
    :in_error_table => '1.3.6.1.2.1.2.2.1.14.',
    :in_discard_table => '1.3.6.1.2.1.2.2.1.13.',
    :out_octet_table => '1.3.6.1.2.1.2.2.1.16.',
    :out_octet_table_64 => '1.3.6.1.2.1.31.1.1.1.10.',
    :out_error_table => '1.3.6.1.2.1.2.2.1.20.',
    :out_discard_table => '1.3.6.1.2.1.2.2.1.19.'
}

$nagiosReturnCodes = {Ok: 0, Warning: 1, Critical: 2, Unknown: 3}

opts = Slop.parse do |o|
  o.string '-h', 'hostname'
  o.string '-C', 'community'
  o.string '-i', 'iface'
end

if ARGV.size == 0
  puts opts
  Kernel.exit(3)
end

host = opts[:h]
community = opts[:C]
iface = opts[:i]


def snmp_get(host, community, oid)
  begin
    manager = SNMP::Manager.new(:host => host, :community => community)
    response = manager.get(oid)
    return response.varbind_list[0].value
  rescue Exception => e
    #puts "Got exception"
    puts e.message
    #puts e.backtrace
    Kernel.exit(3)
  ensure
    manager.close unless manager.nil?
  end
end

