class OsDetectorError < StandardError
end
module OsDetector
  def self.execute
    @os ||= case RUBY_PLATFORM
    when /mswin|msys|mingw|cygwin|bccwin|wince|emc/
      :windows
    when /darwin|mac os/
      :macosx
    when /linux/
      :linux
    when /solaris|bsd/
      :unix
    else
      raise OsDetectorError, "unknown os: #{RUBY_PLATFORM.inspect}"
    end
  end
end