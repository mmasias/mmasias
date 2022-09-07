![](../images/ClassHuman.png)
```
@startuml 
 
class Human {
    - Head mHead;
    - Heart mHeart;
    ..
    - CreditCard mCard;
    --
    + void travel(Vehicle vehicle);
}
 
Human *-up- Head : contains >
Human *-up- Heart : contains >
Human o-left- CreditCard : owns >
Human .down.> Vehicle : dependent
Human -down-> Company : associate
  
interface IProgram {
    + void program();
}

class Programmer {
    + void program();
}

Programmer -left-|> Human : extend
Programmer .up.|> IProgram : implement

@enduml
```