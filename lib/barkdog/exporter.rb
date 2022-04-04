class Barkdog::Exporter
  EXCLUDE_KEYS = %w(
    overall_state
    creator
    org_id
    multi
  )

  class << self
    def export(dog, opts = {})
      self.new(dog, opts).export
    end
  end # of class methods

  def initialize(dog, options = {})
    @dog = dog
    @options = options
  end

  def export
    monitors = @dog.get_all_monitors[1]
    normalize(monitors)
  end

  private

  def normalize(monitors)
    monitor_by_name = {}

    monitors.each do |m|
      name = m.delete('name')


      EXCLUDE_KEYS.each do |key|
        m.delete(key)
      end

      if @options[:ignore_silenced]
        m['options'].delete('silenced')
      end

      if monitor_by_name[name]
        newname = name + '_conflict'
        monitor_by_name[newname] = m
      else
        monitor_by_name[name] = m
      end
    end

    monitor_by_name
  end
end

