class CreateDistricts < ActiveRecord::Migration
  def self.up
    config = Rails::Configuration.new
    db     = config.database_configuration[RAILS_ENV]["database"]
    user   = config.database_configuration[RAILS_ENV]["username"]
    host   = config.database_configuration[RAILS_ENV]["host"]
    password = config.database_configuration[RAILS_ENV]["password"]
    psql = %{PGPASSWORD="#{password}" psql -d #{db} -h #{host} -U #{user}}

    if ENV['POSTGIS_SQL_PATH']
      `#{psql} -c 'CREATE LANGUAGE plpgsql'`
      `#{psql} -f #{File.join(ENV['POSTGIS_SQL_PATH'], 'postgis.sql')} `
      `#{psql} -f #{File.join(ENV['POSTGIS_SQL_PATH'], 'spatial_ref_sys.sql')}`
    end
    `#{psql} -f #{RAILS_ROOT}/db/congress.sql`

    add_index "districts", "the_geom", :spatial=>true

    add_column :districts, :state_name, :string
    add_column :districts, :level, :string

    execute "UPDATE districts SET level = 'federal'"
    execute "UPDATE districts SET name = '1' where name = 'One'"

    District::FIPS_CODES.each do |fips_code, name|
      execute "UPDATE districts SET state_name = '#{name}' WHERE state = '#{fips_code}'"
    end
  end

  def self.down
    drop_table :districts
  end
end
