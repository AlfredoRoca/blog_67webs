Description: Cálculo de tiempos de actividad entre Git Tags con ActivityLogger
Date: 11/6/2016
Categories: misc
Summary: En este post explico cómo he añadido está funcionalidad a mi programa ActivityLogger para calcular el tiempo dedicado en horas al desarrollo de nuevas funciones de cualquier proyecto.
Keywords: git tag

En este post explico cómo he añadido está funcionalidad a mi programa ActivityLogger para calcular el tiempo dedicado en horas al desarrollo de nuevas funciones de cualquier proyecto.
Se asume que se usa git para el control de versiones y se marca con tags los diferentes avances en la aplicación.
Lo que hace el programa es sumar todas las actividades del proyecto entre las fechas del tag anterior y el siguiente. Si se marca el final de cada nueva funcion o avance con un tag podemos, entonces, saber el tiempo dedicado en horas y realizar mejores estimaciones para futuras ofertas.

#Cálculo de tiempos de actividad entre Git Tags con ActivityLogger

Sobre Git Tagging: <https://git-scm.com/book/en/v2/Git-Basics-Tagging>

Sobre Git Log: <https://git-scm.com/docs/git-log>

##Comando git para listar los tags con la fecha

    git log --graph --tags --date-order --simplify-by-decoration  --decorate --oneline --pretty=format:"%h %ai %d %s" | grep tag:


##Un helper para calcular la duración en 'h'##

    #application_helper.rb

    def long_duration_to_s(total_seconds)
      (total_seconds/3600).ceil.to_s + "h"
    end


##La estructura de la BDD##
    
    create_table "activities", force: :cascade do |t|
      t.integer  "project_id"
      t.datetime "start"
      t.datetime "ended"
      t.decimal  "duration"
      ...
    end

    create_table "gittags", force: :cascade do |t|
      t.string   "commit"
      t.datetime "date"
      t.string   "description"
      t.datetime "created_at",        null: false
      t.datetime "updated_at",        null: false
      t.integer  "project_id"
      t.string   "activity_duration"
    end

##Edición de modelos##

    #project.rb

    has_many :gittags

    def calculate_activity_duration_per_gittag
      all_gittags = gittags.order(date: :asc)
      previous_date = DateTime.parse("1/1/1970").iso8601 # initial date
      all_gittags.map do |gt|
        gt.update_column(:activity_duration, long_duration_to_s(activities.where("start >= ? and start <= ?", previous_date, gt.date).sum(:duration)))
        previous_date = gt.date
      end
    end


    #gittag.rb

    class Gittag < ActiveRecord::Base
      belongs_to :project
    end

##Edición de controladores##

    #projects_controller.rb

    def show
      @gittags = @project.gittags.order(date: :asc)
    end


    #gittags_controller.rb

    def create
      @project.gittags.clear
      params[:gittags_text].each_line do |line| 
        gitline = line.split(" ", 6)
        @gittag = @project.gittags.create(commit: gitline.slice(1,1).first, date: DateTime.parse(gitline.slice(2,3).join(" ")).iso8601, description: gitline.slice(5, gitline.size).first )
      end

      @project.calculate_activity_duration_per_gittag

      redirect_to request.referer, notice: 'Gittags successfully created.'
    end

    def update_activity_duration_per_gittag
      @project.calculate_activity_duration_per_gittag
      redirect_to request.referer
    end



##Edición de vistas##

    #projects/show.html.erb

    <h1><%= @project.name %> Alias <%= @project.alias %></h1>

    <%= link_to 'Edit', edit_project_path(@project) %> |
    <%= link_to 'Back', projects_path %>

    <h2>Git Tags</h2>
    <p>Copy here the result text of the following console command:</p>
    <code>git log --graph --tags --date-order --simplify-by-decoration  --decorate --oneline --pretty=format:"%h %ai %d %s" | grep tag:</code>
    <p></p>

    <p>Each line should be like this:</p>
    <code>* 66ab102 2016-03-25 19:01:53 +0100  (HEAD, tag: v0.3, origin/master, master) this is the commit message</code>
    <p></p>

    <%= form_tag project_gittags_path(@project) do %>
      <%= text_area_tag :gittags_text, nil, {rows: "10", style: "width:100%;"} %>
      <%= submit_tag "Delete all previous information and add this one" %>
    <% end -%>

    <p><%= link_to "Update activity duration per Git Tag", update_activity_duration_per_gittag_project_path(@project), class: "pull-right btn btn-default" %></p>

    <table class="table table-stripped table-condensed">
      <thead>
        <tr>
          <th>commit</th>
          <th>date</th>
          <th>description</th>
          <th>activity</th>
          <th colspan="1"></th>
        </tr>
      </thead>

      <tbody>
        <% @gittags.each do |gittag| %>
          <tr>
            <td><%= gittag.commit %></td>
            <td><%= gittag.date %></td>
            <td><%= gittag.description %></td>
            <td><%= gittag.activity_duration %></td>
            <td><%= link_to 'Destroy', project_gittag_path(@project, gittag), method: :delete, data: { confirm: 'Are you sure?' } if current_user && current_user.admin? %></td>
          </tr>
        <% end %>
      </tbody>
    </table>


##Edición de rutas##

    #routes.rb

    resources :projects do
      member do
        get :update_activity_duration_per_gittag
      end
      resources :gittags
    end



##Aplicación simple para generar un historial git suficiente y comprobar listado de git tags##

bash alias for git commands:

    gac = git add . & git commit -m %1
    glb = git log --oneline --decorate --graph -all

La aplicación dummy

    mkdir sample
    cd sample
    git init
    touch index.txt
    gac "1st commit"
    vi index.txt 
    gac "implements feature 1 on master branch directly"
    git tag v0.1

    touch feature-2
    gac "implements feature 2 in master branch"
    git tag v0.2

    git checkout -b feature-3
    touch feature-3
    gac "feature-3 in branch feature-3"
    git checkout master
    git merge --no-ff feature-3 
    git tag v0.3 
    glb

        *   5027673 (HEAD, tag: v0.3, master) Merge branch 'feature-3'
        |\  
        | * e5a57c5 (feature-3) feature-3 in branch feature-3
        |/  
        * c8860e5 (tag: v0.2) implements feature 2 in master branch
        * 46f4816 (tag: v0.1) implements feature 1 on master branch directly
        * 9fa9860 1st commit

    touch bug-1
    gac "fixes bug 1"

    git tag v0.4
    git log --graph --tags --date-order --pretty=format:"%h %ai %d %s"

        * 05e5dd9 2016-06-11 12:38:06 +0200  (HEAD, tag: v0.4, master) fixes bug 1
        *   5027673 2016-06-11 12:36:49 +0200  (tag: v0.3) Merge branch 'feature-3'
        |\  
        | * e5a57c5 2016-06-11 12:31:55 +0200  (feature-3) feature-3 in branch feature-3
        |/  
        * c8860e5 2016-06-11 12:29:55 +0200  (tag: v0.2) implements feature 2 in master branch
        * 46f4816 2016-06-11 12:28:45 +0200  (tag: v0.1) implements feature 1 on master branch directly
        * 9fa9860 2016-06-11 12:27:56 +0200  1st commit

    git log --graph --tags --date-order --simplify-by-decoration --pretty=format:"%h %ai %d %s"

        * 05e5dd9 2016-06-11 12:38:06 +0200  (HEAD, tag: v0.4, master) fixes bug 1
        * 5027673 2016-06-11 12:36:49 +0200  (tag: v0.3) Merge branch 'feature-3'
        * e5a57c5 2016-06-11 12:31:55 +0200  (feature-3) feature-3 in branch feature-3
        * c8860e5 2016-06-11 12:29:55 +0200  (tag: v0.2) implements feature 2 in master branch
        * 46f4816 2016-06-11 12:28:45 +0200  (tag: v0.1) implements feature 1 on master branch directly
        * 9fa9860 2016-06-11 12:27:56 +0200  1st commit

    git log --graph --tags --date-order --simplify-by-decoration  --decorate --oneline --pretty=format:"%h %ai %d %s" | grep tag:

        * 05e5dd9 2016-06-11 12:38:06 +0200  (HEAD, tag: v0.4, master) fixes bug 1
        * 5027673 2016-06-11 12:36:49 +0200  (tag: v0.3) Merge branch 'feature-3'
        * c8860e5 2016-06-11 12:29:55 +0200  (tag: v0.2) implements feature 2 in master branch
        * 46f4816 2016-06-11 12:28:45 +0200  (tag: v0.1) implements feature 1 on master branch directly

Ya tenemos el listado de tags con sus fechas para introducir en ActivityLogger.


