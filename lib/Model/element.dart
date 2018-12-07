class TaskElement {
  String name;
  bool isDone;

  TaskElement({this.name,this.isDone}){
    if(isDone == null){
      this.isDone = false;
    }
  }

  set(String name,bool isDone){
    this.name = name;
    this.isDone = isDone;
  }
}