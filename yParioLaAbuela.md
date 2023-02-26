# mermaid

Otra herramienta de [diagramación mediante texto](https://mermaid.js.org/)

Cosas que tiene, que plantUML no:

## Grafico de git

<div align=center>

<table><tr><td>
  
```
gitGraph
    commit "this is a commit"
    branch newbranch
    checkout newbranch
    commit id:"1111"
    commit tag:"PRUEBA"
    checkout main
    commit type: HIGHLIGHT
    commit
    merge newbranch
    commit
    branch b2
    commit
 ```
</td><td>
  
```mermaid
    gitGraph
    commit "this is a commit"
    branch newbranch
    checkout newbranch
    commit id:"1111"
    commit tag:"PRUEBA"
    checkout main
    commit type: HIGHLIGHT
    commit
    merge newbranch
    commit
    branch b2
    commit
```
</td></tr></table>
</div>
  


## Grosor de líneas

```mermaid
flowchart LR
 a ---> b
 c ===> d
 e -.- f

```

## User journey

```mermaid
journey
    title My working day
    section Go to work
      Make tea: 5: Me
      Go upstairs: 3: Me
      Do work: 1: Me, Cat
    section Go home
      Go downstairs: 5: Me
      Sit down: 5: Me
```

## "Quesitos"

```mermaid
pie showData
    title Key elements in Product X
    "Calcium" : 42.96
    "Potassium" : 50.05
    "Magnesium" : 10.01
    "Iron" :  5
```


## Característica

<div align=center>

<table><tr><td>

```mermaid
```
</td><td>
  
```
```
</td></tr></table>
</div>
