# *#2Think...*

```java
int x = 5;
```

---

```java
int[] t;
```

---

```java
t = new int[];
```

---

```java
t = new int[30];
```

---

```java
x = t.length;
```

---

```java
t[30] = 200;
```

---

```java
t[29] = 200;
```

---

```java
int[] tt = t;
```

---

```java
tt[29] = 1;
```

---

¿Cuántas matrices hay?

---

```java
tt = new int[3];
```

---

- ¿Cuántas zonas de memoria hay reservadas?
- ¿Cuántos arrays hay?

---

```java
t[29] = 666;
```

---

```java
tt[29] = -1;
```

---

```java
tt[2] = -1;
```

---

```java
if (t == tt){
    (...)
}
```

---

```java
t = new int[] {1,1,2,5};
tt = new int[] {1,1,2,5};

if (t==tt){
    (...)
}
```

---

## ¿Cuántas zonas se reservan?

```java
new int[10];
```

---

```java
int[] a;
```

---

```java
int[] a = new int[10];
```

---

```java
int[][] a = new [10][100];
```

---

## `int[][] a = new [10][100];`

<div align=center>

![](/images/UNEATLANTICO/prg1/referencias.svg)

</div>

---

## Formalmente

```java
final int[][] GRID = new int[][] { 
    new int[] { -1, 0 }, 
    new int[] { 1, 0 }, 
    new int[] { 0, -1 }, 
    new int[] { 0, 1 } 
};
```

Pero gracias a la inferencia de tipos, podemos hacer

```java
final int[][] GRID = { 
    { -1, 0 }, 
    { 1, 0 }, 
    { 0, -1 }, 
    { 0, 1 } 
};
```

Lo que simplifica matrices más grandes:

```java
final int[][] BIG_GRID = {
   {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
   {0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
   {1,1,1,0,1,0,1,1,1,1,1,1,1,0,1,1,1,1,0,1},
   {1,0,0,0,1,0,0,0,0,0,0,0,1,0,0,0,0,1,0,1},
   {1,0,1,1,1,1,1,1,0,1,1,0,1,1,1,1,0,1,0,1},
   {1,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,1,0,1},
   {1,1,1,1,1,1,1,1,1,1,0,1,1,1,1,1,1,1,0,1},
   {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
   {1,0,1,1,1,1,1,1,1,1,1,1,1,1,1,0,1,1,0,1},
   {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,1,1,1,1}
};
```java