require "string_scanner"

class GuardEvent
  enum Type
    StartShift
    FallAsleep
    WakeUp
  end

  getter time : Time
  property guard_id : Int32?
  getter event_type : GuardEvent::Type
  private getter record_format = /\[(?<time>.+)\] (?:Guard #(?<guard_id>\d+) begins shift|(?<event>.+))/
  private getter time_format = Time::Format.new("%Y-%m-%d %H:%M", Time::Location::UTC)

  def initialize(record : String)
    scanner = StringScanner.new record
    scanner.scan(record_format)
    @time = time_format.parse scanner["time"].not_nil!
    if scanner["guard_id"]?
      @guard_id = scanner["guard_id"].to_i
      @event_type = GuardEvent::Type::StartShift
    elsif scanner["event"]?
      @guard_id = nil
      case scanner["event"]
      when "falls asleep"
        @event_type = GuardEvent::Type::FallAsleep
      when "wakes up"
        @event_type = GuardEvent::Type::WakeUp
      else
        raise "Invalid non-StartShift event!"
      end
    else
      raise "Invalid event!"
    end
  end
end

struct GuardInfo
  getter id : Int32
  property sleep_minute_counts = Hash(Time, Int32).new

  def initialize(@id)
  end
end

events = File.read_lines("4.in").map { |record| GuardEvent.new record }

# sort by time
events.sort! { |a, b| a.time <=> b.time }

# propagate guard ids
events.each_cons(2, reuse: true) do |chunk|
  if chunk[1].guard_id == nil
    chunk[1].guard_id = chunk[0].guard_id
  end
end

guards = Hash(Int32, GuardInfo).new

events.each do |event|
  guards[event.guard_id] = GuardInfo.new event.guard_id unless guards.has_key? event.guard_id
end
