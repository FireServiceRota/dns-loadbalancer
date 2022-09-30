require 'net/ping/tcp'
require 'resolv'
require 'ipaddress'

class DNSLoadBalancer
  attr_reader :hosts, :port

  def initialize(hosts, port, verbose: true)
    @hosts = hosts.split(',')
    @port = port
    @verbose = verbose
  end

  def run
    start = Time.now
    ip_addresses = hosts.flat_map do |h|
      result = resolve(h)
      log "Resolved #{h} to IP addresses: #{result}"
      result
    end
    result = find_closest(ip_addresses)
    log "Found fastest IP #{result} in #{(Time.now - start).round(2)}s"
    result
  end

  private

  def resolve(host)
    return host.to_s if IPAddress.valid_ipv4?(host.to_s)

    ipaddresses = Resolv.getaddresses(host)
    ipaddresses.select { |ip| IPAddress.valid_ipv4?(ip) }
  end

  def find_closest(ip_addresses)
    pings = ip_addresses.map do |address|
      duration = ping(address.to_s, port)
      log "Pinging #{address.ljust(16, ' ')} #{duration || 'not reachable'}"
      [address, duration]
    end.to_h

    fastest = pings.select { |_, v| v }.min_by(&:last)
    fastest&.first || raise('no server accessible')
  end

  def ping(ip_address, port)
    durations = 3.times.map do
      p = Net::Ping::TCP.new(ip_address, port, 0.5)
      p.ping?
      p.duration
    end

    durations.compact!
    return nil if durations.empty?

    durations.sum / durations.length
  end

  def log(msg)
    return unless @verbose

    puts "[DNSLoadBalancer] #{msg}"
  end
end
