package com.softtek.modelo;

public class Campos {
    // Press Alt+Enter with your caret at the highlighted text to see how
    // IntelliJ IDEA suggests fixing it.
    //Realizar una clase llamada Campos con dos métodos uno muestra y el otro
    //incrementa. El método Muestra, es una función que da como resultado el valor de x, El
    //método Incrementa: Incrementa el valor de X.,El constructor el valor inicial al campo
    //X.,Crear una instancia en el módulo principal de la aplicación, incrementar y mostrar el
    //resultado.

    int x;
    public Campos(int valor) {
        this.x=valor;
        System.out.println();
    }

    public int mostrar(){
        return x;
    }
    public int incrementar(int x){
        x++;
    return x;
    }

}
