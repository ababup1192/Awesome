# Awesome

## How-To-Test
```
$ bundle install --path vendor/bundler
$ bundle exec racc -o src/parser.rb src/grammar.y
$ ruby test/lexer_test.rb
$ ruby test/parser_test.rb
```

