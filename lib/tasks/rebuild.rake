task rebuild: ['stop','db:drop', 'db:create', 'db:migrate', 'db:seed','import_data','business_info', 'start'] do
    puts 'Reseeding completed.'
  end