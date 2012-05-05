require 'grit'

class WikiInitializer
  def self.create_wiki(wiki)
    unless File.exists?(Rails.root.to_s + '/wikis/' + wiki.name)
      Dir::mkdir(Rails.root.to_s + '/wikis/' + wiki.name)
      `cd #{Rails.root.to_s + '/wikis/' + wiki.name}&&touch Home.md&&git init&&git add . &&git commit -a -m "Initial commit"`
    end
  end
end