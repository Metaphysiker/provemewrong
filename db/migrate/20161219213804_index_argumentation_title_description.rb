class IndexArgumentationTitleDescription < ActiveRecord::Migration[5.0]
  # An index can be created concurrently only outside of a transaction.
  disable_ddl_transaction!

  def up
    execute %{
    CREATE INDEX argumentation_on_title_idx ON argumentations USING GIN(title gin_trgm_ops);
    CREATE INDEX argumentation_on_description_idx ON argumentations USING GIN(description gin_trgm_ops);
    }
  end

  def down
    execute %{
    DROP INDEX argumentation_on_title_idx;
    }
  end
end
