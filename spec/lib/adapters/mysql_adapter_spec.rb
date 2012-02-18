require 'spec_helper'

describe MysqlAdapter do
  context 'with a MySQL database' do
    let(:adapter) { MysqlAdapter.new({"database"=>"some_mysql_db", "host"=>"localhost", "username"=>"root", "password"=>nil}) }

    describe '#export' do
      it 'ensures the database exists' do
        adapter.should_receive(:ensure_db_exists)
        adapter.export
      end

      it 'executes the mysqdldump command' do
        Kernel.should_receive(:`).with(/mysqldump/)
        adapter.export
      end

      it 'returns the database dump' do
        adapter.export.should =~ /Database: some_mysql_db/
      end
    end

    describe '#import' do
      it 'ensures the database exists' do
        adapter.should_receive(:ensure_db_exists)
        adapter.import('SHOW DATABASES;')
      end

      it 'executes the mysql command' do
        Kernel.should_receive(:`).with(/mysql\s/)
        adapter.import('SHOW DATABASES;')
      end

      it 'imports the desired SQL' do
        sql = <<-SQL
          CREATE TABLE my_new_database_table (
                   id INT,
                   data VARCHAR(100)
                 );
        SQL
        adapter.import(sql)
        adapter.export.should =~ /my_new_database_table/
        
        # Remove the table so it doesn't disrupt future-run specs
        sql = <<-SQL
          DROP TABLE my_new_database_table;
        SQL
        adapter.import(sql)
      end
    end

    describe '#copy' do
      it 'executes the mysqldump and pipes to the mysql command' do
        Kernel.should_receive(:`).with(/mysqldump.*\|\s+mysql/)
        adapter.copy({"database"=>"new_mysql_db", "host"=>"localhost", "username"=>"root", "password"=>nil})
      end

      it 'copies one database to another' do
        # Create a new table to check that it was duplicated to the new database
        adapter.import('CREATE TABLE some_new_database_table ( id INT );')
        adapter.copy({"database"=>"new_mysql_db", "host"=>"localhost", "username"=>"root", "password"=>nil})

        # Load the new database and check that the table exists
        new_adapter = MysqlAdapter.new({"database"=>"new_mysql_db", "host"=>"localhost", "username"=>"root", "password"=>nil})
        new_adapter.export.should =~ /some_new_database_table/

        `echo "DROP DATABASE some_mysql_db" | mysql -u root`
        `echo "DROP DATABASE new_mysql_db" | mysql -u root`
      end
    end

    describe '#ensure_db_exists' do
      it 'creates the database if it does not exist' do
        `mysqldump -u root some_db_that_does_not_exist`
        $?.success?.should be_false

        adapter.ensure_db_exists('some_db_that_does_not_exist')

        `mysqldump -u root some_db_that_does_not_exist`
        $?.success?.should be_true

        `echo "DROP DATABASE some_db_that_does_not_exist" | mysql -u root`
      end
    end
  end
end