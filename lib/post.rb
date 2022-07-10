require 'sqlite3'

class Post

  @@SQLITE_DB_FILE = 'notepad.db'

  def initialize
    @created_at = Time.now
    @text = nil
  end

  class << self
    def post_types
      {'Memo' => Memo, 'Link' => Link, 'Task' => Task}
    end

    def create(type)
      post_types[type].new
    end

    def find_by_id(id)
      db = SQLite3::Database.open @@SQLITE_DB_FILE
      db.results_as_hash = true

      begin
        result = db.execute("SELECT * FROM posts WHERE rowid = ?", id)
      rescue SQLite3::SQLException => e
        puts "Не удалось выполнить запрос в базе #{@@SQLITE_DB_FILE}"
        abort e.message
      ensure
        db.close if db
      end

      if result.empty?
        puts "Такой id #{id} не найдено в базе :(" 
        exit
      end

      post = create(result[0]['type'])
      post.load_data(result[0])
      return post
    end

    def find_all(type, limit)
      db = SQLite3::Database.open @@SQLITE_DB_FILE
      db.results_as_hash = false

      query = "SELECT rowid, * FROM posts "
      query += "WHERE type = :type " unless type.nil?  #используем не знак вопроса, а именнованй плейсхолдер
      query += "ORDER BY rowid DESC "
      query += "LIMIT :limit " unless limit.nil?

      begin
        statement = db.prepare(query)
      rescue SQLite3::SQLException => e
        puts "Не удалось выполнить запрос в базе #{@@SQLITE_DB_FILE}"
        abort e.message
      end

      statement.bind_param('type', type) unless type.nil?
      statement.bind_param('limit', limit) unless limit.nil?

      begin
        result = statement.execute!
      rescue SQLite3::SQLException => e
        puts "Не удалось выполнить запрос в базе #{@@SQLITE_DB_FILE}"
        abort e.message
      ensure
        statement.close if statement
        db.close if db
      end
      
      return result
    end
  end


  def read_from_console

  end

  def to_strings
    
  end

  def save
    file = File.new(file_path, "w:UTF-8")

    to_strings.each do |item|
      file.puts item
    end

    file.close
  end

  def file_path
    curr_path = File.dirname(__FILE__)

    file_name = @created_at.strftime("#{self.class.name}_%Y-%m-%d_%H-%M-%S.txt")

    return curr_path + "/recordings/" + file_name
  end

  def save_to_db
    db = SQLite3::Database.open(@@SQLITE_DB_FILE)
    db.results_as_hash = true

    begin
      db.execute(
        "INSERT INTO posts (" +
        to_db_hash.keys.join(',') + 
        ")" +
        " VALUES (" + 
        ("?, " * to_db_hash.keys.size).chomp(', ') + 
        ")", 
        to_db_hash.values
      )

    rescue SQLite3::SQLException => e
      puts "Не удалось выполнить запрос в базе #{@@SQLITE_DB_FILE}"
      abort e.message
    end
    last_row_id = db.last_insert_row_id
    db.close
    
    last_row_id
  end

  def to_db_hash
    {
      'type' => self.class.name,
      'created_at' => @created_at.to_s
    }
  end

  def load_data(data_hash)
    @created_at = Date.parse(data_hash['created_at'])
  end

end