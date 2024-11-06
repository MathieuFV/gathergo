class AddCountersToDestinations < ActiveRecord::Migration[7.1]
  def change
    add_column :destinations, :comments_count, :integer, default: 0
    add_column :destinations, :votes_count, :integer, default: 0
  end
end
