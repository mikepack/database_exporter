require 'forwardable'
require 'adapters/mysql_adapter'

class DatabaseExporter
  extend Forwardable

  def initialize(config)
    @adapter = case config['adapter']
    when /mysql/
      MysqlAdapter.new(config)
    end
  end

  def_delegators :@adapter, :export, :import, :copy, :ensure_db_exists
end