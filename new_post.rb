require "sqlite3"

require_relative 'lib/post'
require_relative 'lib/link'
require_relative 'lib/memo'
require_relative 'lib/task'

puts "Привет, я твой блокно! Версия 2 + sqlite"
puts "Что вы хотите записать в блокнот?"

choices = Post.post_types.keys

choice = -1

until choice >= 0 && choice < choices.size
  choices.each_with_index do |type, index|
    puts "\t#{index}. #{type}"
  end

  choice = STDIN.gets.to_i
end

entry = Post.create(choices[choice])

entry.read_from_console

id = entry.save_to_db

puts "Ура. Запись сохранена, id = #{id}"



