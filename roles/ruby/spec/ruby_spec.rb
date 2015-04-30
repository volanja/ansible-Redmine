describe command('cat /home/redmine/.rbenv/version') do
  its(:stdout) { should match /2.2.0/ }
end


