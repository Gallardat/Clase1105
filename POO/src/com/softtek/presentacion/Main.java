package com.softtek.presentacion;

import com.softtek.modelo.Campos;

public class Main {
    public static void main(String[] args) {
    Campos c1 = new Campos(1);
         int y=c1.mostrar();
        System.out.println(y);
        int z=c1.incrementar(y);
        System.out.println(z);
    }
}