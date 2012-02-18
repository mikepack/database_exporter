require 'forwardable'

class DatabaseExporter
  extend Forwardable

  def initialize(config)
    @datbase = case config['adapter']
    when /mysql/
      MysqlAdapter.new(config)
    end
  end

  def_delegators :@database, :export, :import, :copy, :ensure_db_exists
end