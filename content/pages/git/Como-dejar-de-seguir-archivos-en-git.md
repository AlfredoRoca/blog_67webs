Description: Como dejar de seguir archivos en git (untrack)
Date: 13/7/2015
Categories: git
Summary: Git es muy potente. Aquí tienes cómo dejar de seguir archivos sin borrarlos del repositorio
Keywords: git, untrack, update-index 

#Como dejar de seguir archivos en git (untrack)

En este blog basado en NestaCMS, cuando lo ejecuto en local me aparecen directorios .sass-cache/.... que no deseo subir al repositorio.

Solución:

Añadir al ```.gitignore```

    .sass-cache/**/*

Para hacer el untrack

    git update-index --assume-unchanged .sass-cache/**/*

