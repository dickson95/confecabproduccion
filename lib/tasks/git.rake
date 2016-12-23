namespace :git do
  desc "Añadir todos los archivos al área de preparación y mostrar editor de texto para mensaje"
  task commit_all: :environment do
    sh %{ git add --all }
    sh %{ git commit }
  end

end
