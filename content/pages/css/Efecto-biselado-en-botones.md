Description: Cómo crear un efecto de biselado en botones con CSS
Date: 1/11/2015
Categories: css
Summary: Un toque de estilo para tus botones ...

#Efecto biselado en botones con CSS

    :::sass
    .biselado {
      border: 1px solid darken(#F6EEBD, 20%);         /* Color del borde, debe ser más oscuro que fondo */
      background: #F6EEBD;                            /* Fondo */
      border-radius: 40px;                            /* Bordes redondos */
      box-shadow: inset 3px 3px 3px rgba(255,255,255,.7), inset -2px -2px 3px rgba(0,0,0,.1), 2px 2px 10px rgba(0,0,0,.1);
      text-shadow: 1px 1px 1px rgba(255,255,255,.9);  /* Sombra del texto */
      text-align: center;                             /* Alineación del texto */
      padding: 1em 1em 0;
      margin: auto;
      display: inline-block;
    }
