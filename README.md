## Notepad
This is simple Ruby console programm for noting memos, links url and tasks

Language: Ruby, version 2.7.3

DataBase: SQLite3

### Adding posts

To add a new post, enter in the terminal:

```
ruby new_post.rb
```

Posts are saved to `notepad.db` using the` sqlite3` gem

### Viewing Notepad

To view the posts, type in the terminal:

```
ruby read.rb [options]
```

For help:

```
ruby read.rb -h

