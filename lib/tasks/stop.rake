task :stop do
    p "=> Stopping Rails Server"
    if File.exist?("tmp/pids/server.pid")
      File.new("tmp/pids/server.pid").tap { |f| Process.kill 9, f.read.to_i }
    end
    p "=> Stopped"
end