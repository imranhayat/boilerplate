task :pg do 
    p "=> Starting PG Server "
    Process.exec("sudo service postgresql start")
end