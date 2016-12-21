class CreateSearchResultsMaterializedView < ActiveRecord::Migration[5.0]
  def up
    execute %{
        CREATE MATERIALIZED VIEW search_results AS
          SELECT
            argumentations.id                  AS argumentation_id,
            argumentations.title               AS argumentation_title,
            argumentations.description         AS argumentation_description,
            arguments.id                       AS argument_id,
            arguments.title                    AS argument_title,
            arguments.description              AS argument_description
          FROM
            argumentations
          JOIN arguments ON
            argumentations.id = arguments.parent_argumentation_id
    }

  end

  def down
    execute "DROP MATERIALIZED VIEW search_results"
  end
end
