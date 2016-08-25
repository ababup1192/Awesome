task :init do
  system("bundle install --path vendor/bundler")
end

task :compile do
  system("bundle exec racc -o src/parser.rb src/grammar.y")
end

task :test do
  Dir.glob("test/*_test.rb").each{ |testfile| system("ruby #{testfile}") }
end

task default: [:init, :compile, :test]
