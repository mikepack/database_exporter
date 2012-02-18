class MysqlAdapter
  def initialize(config)
    @config = config
  end

  def export
    ensure_db_exists
    Kernel.` "mysqldump -h #{@config['host']} -u #{@config['username']} #{'-p' + @config['password'] if @config['password']} #{@config['database']}"
  end

  def import(sql)
    ensure_db_exists
    Kernel.` "echo \"#{sql}\" | mysql -h #{@config['host']} -u #{@config['username']} #{'-p' + @config['password'] if @config['password']} #{@config['database']}"
  end

  def copy(new_db_config)
    ensure_db_exists
    ensure_db_exists(new_db_config['database'])
    Kernel.` "mysqldump -h #{@config['host']} -u #{@config['username']} #{'-p' + @config['password'] if @config['password']} #{@config['database']} | mysql -h #{new_db_config['host']} -u #{new_db_config['username']} #{'-p' + new_db_config['password'] if new_db_config['password']} #{new_db_config['database']}"
  end

  def ensure_db_exists(name = @config['database'])
    `echo "CREATE DATABASE IF NOT EXISTS #{name}" | mysql -h #{@config['host']} -u #{@config['username']} #{'-p' + @config['password'] if @config['password']}`
  end
end