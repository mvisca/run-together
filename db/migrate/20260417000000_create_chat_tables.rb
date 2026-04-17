class CreateChatTables < ActiveRecord::Migration[7.1]
  def change
    create_table :conversations do |t|
      t.bigint :race_id, null: false
      t.timestamps
    end
    add_index :conversations, :race_id, unique: true
    add_foreign_key :conversations, :races

    create_table :conversation_participants do |t|
      t.bigint :conversation_id, null: false
      t.bigint :user_id, null: false
      t.datetime :last_read_at
      t.datetime :created_at, null: false
    end
    add_index :conversation_participants, :conversation_id, name: "index_conversation_participants_on_conversation_id"
    add_index :conversation_participants, :user_id, name: "index_conversation_participants_on_user_id"
    add_index :conversation_participants, [:conversation_id, :user_id], unique: true, name: "index_conversation_participants_uniqueness"
    add_foreign_key :conversation_participants, :conversations
    add_foreign_key :conversation_participants, :users

    create_table :messages do |t|
      t.bigint :conversation_id, null: false
      t.bigint :user_id, null: false
      t.text :body, null: false
      t.timestamps
    end
    add_index :messages, :conversation_id, name: "index_messages_on_conversation_id"
    add_index :messages, :user_id, name: "index_messages_on_user_id"
    add_index :messages, [:conversation_id, :created_at], name: "index_messages_on_conversation_and_created_at"
    add_foreign_key :messages, :conversations
    add_foreign_key :messages, :users
  end
end
