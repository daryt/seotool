class AddPageTitleToPage < ActiveRecord::Migration
  def change
    add_column :pages, :page_title, :string
    add_column :pages, :url, :string
  end
end
