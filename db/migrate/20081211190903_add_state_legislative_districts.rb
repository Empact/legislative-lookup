class AddStateLegislativeDistricts < ActiveRecord::Migration
  def self.up
    config = Rails::Configuration.new
    db     = config.database_configuration[RAILS_ENV]["database"]
    user   = config.database_configuration[RAILS_ENV]["username"]
    host   = config.database_configuration[RAILS_ENV]["host"]
    password = config.database_configuration[RAILS_ENV]["password"]
    psql = %{PGPASSWORD="#{password}" psql -d #{db} -h #{host} -U #{user}}

    `tar xzf #{RAILS_ROOT}/db/state_sql_files.tar.gz -C #{RAILS_ROOT}/db`
    (1..72).each do | n |
      n = n.to_s.rjust(2, '0')
      
      `#{psql} -f #{RAILS_ROOT}/db/state/lower/senate_lower_#{n}.sql`
      `#{psql} -f #{RAILS_ROOT}/db/state/upper/senate_upper_#{n}.sql`
    end
    
    change_column(:districts, :cd, :string, :limit => 3)
    add_column(:districts, :census_geo_id, :string)
    
    execute "INSERT INTO districts (state, cd, lsad, name, lsad_trans, the_geom, state_name, level, census_geo_id) 
             SELECT state, sldl, lsad, name, lsad_trans, the_geom, '', 'state_lower', geo_id 
             FROM lower_districts"
             
    execute "INSERT INTO districts (state, cd, lsad, name, lsad_trans, the_geom, state_name, level, census_geo_id) 
             SELECT state, sldu, lsad, name, lsad_trans, the_geom, '', 'state_upper', geo_id 
             FROM upper_districts"
    
    District::FIPS_CODES.each do |fips_code, name|
      execute "UPDATE districts SET state_name = '#{name}' WHERE state = '#{fips_code}'"
    end
    
    drop_table :lower_districts
    drop_table :upper_districts
  end

  def self.down
  end
end
