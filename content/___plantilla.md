Description: 
Date: /6/2016
Categories: 
Summary:
Keywords: 
Flags: draft

#aquí el título del post

si se crea una categoría nueva:
- añadir página haml correspondiente con su título genérico
- guardar en subdirectorio correspondiente
- incluir en el menu.txt

Description -> aquí el titulo del post (meta tag página y pestaña navegador)
Summary -> resumen que aparece en vista general



Para publicación:

git add .
git commit "new post"
git push origin master
cap staging deploy
