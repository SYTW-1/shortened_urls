class CreateShortenedUrls < ActiveRecord::Migration
  def up
    create_table :shortened_urls do |t|
      t.string :url
    end
    # adds a new index with the name :url
    # A database index is a data structure that improves the speed 
    # of data retrieval operations on a database table at the cost
    # of slower writes and increased storage space. Indices can be
    # created using one or more columns of a database table, providing
    # the basis for both rapid random lookups and efficient access
    # of ordered records.
    add_index :shortened_urls, :url
  end

  def down
    # The SQL DROP TABLE statement is used to remove a table
    # definition and all data, indexes, triggers, constraints, and
    # permission specifications for that table
    drop_table :shortened_urls
  end
end
