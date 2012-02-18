# Database Exporter

Experimental project to gain access to system-level database import, export and copy capabilities. It's build to handle Rail's database configuration conventions.

# Database Support

Current support is for MySQL only.

# Installation & Usage

To install, add `gem 'database_exporter'` to your Gemfile or do `gem install database_exporter`.

Specs are a good example of how to use this library, here's some more:

## Export
    db = DatabaseExporter.new({'adapter' => 'mysql2', 'username' => 'root', 'database' => 'some_database'})
    db.export #=> Native MySQL database dump

## Import
    db = DatabaseExporter.new({'adapter' => 'mysql2', 'username' => 'root', 'database' => 'some_database'})
    db.import('CREATE TABLE IF NOT EXISTS some_new_table;')

## Copy
    # Database to copy from
    db = DatabaseExporter.new({'adapter' => 'mysql2', 'username' => 'root', 'database' => 'source_database'})

    # Database to copy to
    db.copy({'adapter' => 'mysql2', 'username' => 'root', 'database' => 'destination_database'})

# License

Database Exporter is released under the MIT license